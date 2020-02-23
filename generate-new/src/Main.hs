module Main
  where

import           Relude                  hiding ( runReader
                                                , uncons
                                                , Type
                                                )
import           Relude.Extra.Map
import           Say
import           System.TimeIt
import           Polysemy
import qualified Data.HashMap.Strict as Map
import           Polysemy.Reader
import qualified Data.Vector.Storable.Sized    as VSS
import qualified Data.Vector                   as V
import qualified Data.Text                     as T
import qualified Data.List                     as List
import           Data.Text.Extra                ( lowerCaseFirst
                                                , upperCaseFirst
                                                , (<+>)
                                                )
import           Data.Text.Prettyprint.Doc      ( pretty )
import           Language.Haskell.TH            ( Name
                                                , Type(..)
                                                , nameBase
                                                )

import           Foreign.C.Types

import           CType
import           Error
import           Marshal
import           Marshal.Scheme
import           Render.Element
import           Render.Element.Write
import           Render.Aggregate
import           Bespoke.Seeds
import           Render.Spec
import           Spec.Parse

main :: IO ()
main = (runM . runErr $ go) >>= \case
  Left es -> do
    traverse_ sayErr es
    sayErr (show (length es) <+> "errors")
  Right () -> pure ()
 where
  go = do
    specText <- timeItNamed "Reading spec"
      $ readFileBS "./Vulkan-Docs/xml/vk.xml"

    spec@Spec {..} <- timeItNamed "Parsing spec" $ parseSpec specText

    let
      aliasMap :: Map.HashMap Text Text
      aliasMap =
        fromList [ (aName, aTarget) | Alias {..} <- toList specAliases ]
      resolveAlias :: Text -> Text
      resolveAlias t = case Map.lookup t aliasMap of
        Nothing -> t
        Just t' -> resolveAlias t' -- TODO: handle cycles!
      structNames :: HashSet Text
      structNames =
        fromList . (extraStructNames <>) . toList . fmap sName $ specStructs
      isStruct' = (`member` structNames)
      bitmaskNames :: HashSet Text
      bitmaskNames =
        fromList [ eName | Enum {..} <- toList specEnums, eType == ABitmask ]
      isBitmask     = (`member` bitmaskNames)
      isBitmaskType = \case
        TypeName n -> isBitmask n || isBitmask (resolveAlias n)
        _          -> False
      nonDispatchableHandleNames :: HashSet Text
      nonDispatchableHandleNames = fromList
        [ hName
        | Handle {..} <- toList specHandles
        , hDispatchable == NonDispatchable
        ]
      isNonDispatchableHandle     = (`member` nonDispatchableHandleNames)
      isNonDispatchableHandleType = \case
        TypeName n ->
          isNonDispatchableHandle n || isNonDispatchableHandle (resolveAlias n)
        _ -> False
      dispatchableHandleNames :: HashSet Text
      dispatchableHandleNames = fromList
        [ hName
        | Handle {..} <- toList specHandles
        , hDispatchable == Dispatchable
        ]
      -- TODO Remove, these will not be defaultable once we bundle the
      -- command pointers
      isDispatchableHandle     = (`member` dispatchableHandleNames)
      isDispatchableHandleType = \case
        TypeName n ->
          isDispatchableHandle n || isDispatchableHandle (resolveAlias n)
        _ -> False
      mps = MarshalParams
        (    isDefaultable'
        <||> isBitmaskType
        <||> isNonDispatchableHandleType
        <||> isDispatchableHandleType
        )
        isStruct'
        isPassAsPointerType'

    (ss, cs) <- runReader mps $ do
      ss <- timeItNamed "Marshaling structs"
        $ traverseV marshalStruct specStructs
      cs <- timeItNamed "Marshaling commands"
        $ traverseV marshalCommand specCommands
        -- TODO: Don't use all commands here, just those commands referenced by
        -- features and extensions. Similarly for specs
      pure (ss, cs)

    withTypeInfo spec $ do

      renderElements <-
        timeItNamed "Rendering"
        .   runReader renderParams
        $   traverse evaluateWHNF
        =<< renderSpec spec ss cs

      groups <- timeItNamed "Segmenting" $ do
        seeds <- specSeeds spec
        segmentRenderElements show renderElements seeds

      timeItNamed "writing"
        $ withTypeInfo spec (renderSegments "out" (mergeElements groups))

----------------------------------------------------------------
-- Names
----------------------------------------------------------------

renderParams :: RenderParams
renderParams = RenderParams
  { mkTyName                = unReservedWord . upperCaseFirst
  , mkConName               = \parent ->
                                unReservedWord
                                  . (case parent of
                                      "VkPerformanceCounterResultKHR" -> ("Counter" <>)
                                      _ -> id
                                    )
                                  . upperCaseFirst
  , mkMemberName            = unReservedWord . lowerCaseFirst
  , mkFunName               = unReservedWord
  , mkParamName             = unReservedWord
  , mkPatternName           = unReservedWord
  , mkHandleName            = unReservedWord
  , mkFuncPointerName       = unReservedWord . T.tail
  , mkFuncPointerMemberName = unReservedWord . ("p" <>) . upperCaseFirst
  , alwaysQualifiedNames    = V.fromList [''VSS.Vector]
  , mkIdiomaticType         =
    (`List.lookup` [ wrappedIdiomaticType ''Float  ''CFloat  'CFloat
                   , wrappedIdiomaticType ''Int32  ''CInt    'CInt
                   , wrappedIdiomaticType ''Double ''CDouble 'CDouble
                   , wrappedIdiomaticType ''Word64 ''CSize   'CSize
                   ]
    )
  }

wrappedIdiomaticType
  :: Name
  -- ^ Wrapped type
  -> Name
  -- ^ Wrapping type constructor
  -> Name
  -- ^ Wrapping constructor
  -> (Type, IdiomaticType)
wrappedIdiomaticType t w c =
  ( ConT w
  , IdiomaticType
    (ConT t)
    (do
      tellConImport w c
      pure (pretty (nameBase c))
    )
    (do
      tellConImport w c
      pure . Left . pretty . nameBase $ c
    )
  )

unReservedWord :: Text -> Text
unReservedWord t = if t `elem` (keywords <> preludeWords) then t <> "'" else t
 where
  keywords =
    [ "as"
    , "case"
    , "class"
    , "data family"
    , "data instance"
    , "data"
    , "default"
    , "deriving"
    , "do"
    , "else"
    , "family"
    , "forall"
    , "foreign"
    , "hiding"
    , "if"
    , "import"
    , "in"
    , "infix"
    , "infixl"
    , "infixr"
    , "instance"
    , "let"
    , "mdo"
    , "module"
    , "newtype"
    , "of"
    , "proc"
    , "qualified"
    , "rec"
    , "then"
    , "type"
    , "where"
    ]
  preludeWords = ["filter"]

----------------------------------------------------------------
-- Bespoke Vulkan stuff
----------------------------------------------------------------

isDefaultable' :: CType -> Bool
isDefaultable' t =
  -- isBitmask'              <- (isJust .) <$> asks lIsBitmask
  -- isNonDispatchableHandle <-
  --   (maybe False (\h -> hHandleType h == NonDispatchable) .) <$> asks lIsHandle
  isDefaultableForeignType t || isIntegral t
    -- TODO
    -- || isBitmask || isNonDispatchableHandle

isIntegral :: CType -> Bool
isIntegral =
  (`elem` [ Int
          , Char
          , TypeName "uint8_t"
          , TypeName "uint16_t"
          , TypeName "uint32_t"
          , TypeName "uint64_t"
          , TypeName "int8_t"
          , TypeName "int16_t"
          , TypeName "int32_t"
          , TypeName "int64_t"
          , TypeName "size_t"
          , TypeName "VkDeviceSize"
          , TypeName "VkDeviceAddress"
          ]
  )

isDefaultableForeignType :: CType -> Bool
isDefaultableForeignType =
  (`elem` [ TypeName "HANDLE"
          , TypeName "DWORD"
          , TypeName "LPCWSTR"
          , TypeName "PFN_vkInternalAllocationNotification"
          , TypeName "PFN_vkInternalFreeNotification"
          , TypeName "PFN_vkAllocationFunction"
          , TypeName "PFN_vkReallocationFunction"
          , TypeName "PFN_vkFreeFunction"
          , Ptr CType.Const (TypeName "SECURITY_ATTRIBUTES")
          ]
  )

-- | Is this a type we don't want to marshal
isPassAsPointerType' :: CType -> Bool
isPassAsPointerType' = \case
  TypeName n
    | n
      `elem` [ "MirConnection"
             , "wl_display"
             , "wl_surface"
             , "Display"
             , "xcb_connection_t"
             , "AHardwareBuffer"
             , "ANativeWindow"
             , "CAMetalLayer"
             , "SECURITY_ATTRIBUTES"
             ]
    -> True
  _ -> False

-- TODO: Remove, extra union names and handle
extraStructNames :: [Text]
extraStructNames = ["VkClearColorValue", "VkSemaphore"]

----------------------------------------------------------------
-- Utils
----------------------------------------------------------------

(<||>) :: Applicative f => f Bool -> f Bool -> f Bool
(<||>) = liftA2 (||)
