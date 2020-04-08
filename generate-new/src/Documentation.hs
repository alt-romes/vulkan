{-# LANGUAGE RecursiveDo         #-}

module Documentation
  ( Documentation(..)
  , Documentee(..)
  , docBookToDocumentation
  , splitDocumentation
  , guessDocumentee
  , iterateSuffixesM
  , main
  ) where

import           Control.Monad
import           Data.Default
import           Data.Foldable
import           Data.Maybe
import           Documentation.RunAsciiDoctor
                                         hiding ( main )
import           Relude                  hiding ( rem
                                                , elem
                                                )
import           Say
import           System.Environment
import           Text.Pandoc
import           Spec.Name

data Documentation = Documentation
  { dDocumentee    :: Documentee
    -- ^ The name of the thing being documented
  , dDocumentation :: Pandoc
    -- ^ The documentation itself
  }
  deriving (Show)

data Documentee
  = TopLevel CName
  | Nested CName CName
  deriving (Show, Eq, Ord)

docBookToDocumentation
  :: (Documentee -> Bool)
  -- ^ Is a valid documentee name
  -> Text
  -- ^ The docbook string
  -> Either Text [Documentation]
docBookToDocumentation isValid db = mdo
  let readerOptions = def
  pandoc             <- first show $ runPure (readDocBook readerOptions db)
  (removed, subDocs) <- splitDocumentation name pandoc
  name               <- guessDocumentee isValid removed
  pure $ Documentation (TopLevel name) removed : subDocs

guessDocumentee :: (Documentee -> Bool) -> Pandoc -> Either Text CName
guessDocumentee isValid (Pandoc _ bs) = do
  firstWord <- case bs of
    Para (Str n : _) : _ -> pure n
    _ -> Left "Unable to find first word in documentation"
  if isValid (TopLevel (CName firstWord))
    then pure (CName firstWord)
    -- TODO: Fix error message here.
    else Left "First word of documentation doesn't begin with \"vk\" or \"pfn\""

-- | If the description is a bullet list of "enames" then remove those from the
-- original documentation and return them separately.
--
-- Return the original documentation with the new document sections removed
splitDocumentation :: CName -> Pandoc -> Either Text (Pandoc, [Documentation])
splitDocumentation parent (Pandoc meta bs) = do
  (es, bs') <- iterateSuffixesM (splitPrefix meta) bs
  pure (Pandoc meta bs', join (catMaybes es))
  where
    splitPrefix m = \case
      -- Remove the "Document Notes" section
      Section "_document_notes"  _    rem -> pure (Nothing, rem)

      -- Remove the "C Specification" section
      Section "_c_specification" _    rem -> pure (Nothing, rem)

      -- Remove the "Name" header
      Section "_name"            bs'' rem -> pure (Nothing, bs'' ++ rem)

      -- If the description section is a list of documentation for enumeration
      -- values or members, split them into separate documentation elements
      -- TODO: command parameters
      xs@(Section sectionTag bs'' rem)
        | h : _ <- xs, sectionTag `elem` ["_description", "_members"]
        -> case memberDocs parent m bs'' of
          Left  _                    -> pure (Nothing, xs)
          Right (ds, []            ) -> pure (Just ds, rem)
          Right (ds, leftoverBlocks) -> do
            let includeSubdocumentation = any
                  (\case
                    Para ws ->
                      [Str "The", Space, Str "following", Space, Str "bits"]
                        `isPrefixOf` ws

                    _ -> False
                  )
                  leftoverBlocks
                --- ^ Include the member docs as well, some documentation makes
                -- reference to them and makes no sense without the bullet
                -- points, for instance 'VkFormatFeatureFlagBits'
                ps = if includeSubdocumentation then bs'' else leftoverBlocks
            pure (Just ds, h : ps ++ rem)

      -- Leave everything else alone
      xs -> pure (Nothing, xs)

pattern Section :: Text -> [Block] -> [Block] -> [Block]
pattern Section ref blocks remainder
  <- Header headerLevel (ref, _, _) _
   : (break (isHeaderLE headerLevel) -> (blocks, remainder))

isHeaderLE :: Int -> Block -> Bool
isHeaderLE n = \case
  Header n' _ _ -> n' <= n
  _             -> False

-- Handle struct members, enum docs and function parameter documentation
memberDocs
  :: CName
  -- ^ Parent name
  -> Meta
  -> [Block]
  -> Either Text ([Documentation], [Block])
  -- ^ The documentation and the leftover blocks
memberDocs parent m blocks =
  let extractBulletList = \case
        BulletList bullets ->
          let enumDoc :: [Block] -> Either Text Documentation
              enumDoc = \case
                p@(Para (Code ("", [], []) memberName : _)) : ps -> pure
                  Documentation { dDocumentee = Nested parent (CName memberName)
                                , dDocumentation = Pandoc m (p : ps)
                                }
                _ -> Left "Unhandled member documentation declaration"
          in  (, []) <$> traverse enumDoc bullets
        d -> Right ([], [d])
  in  mconcat <$> traverse extractBulletList blocks

main :: IO ()
main = do
  [d, m] <- getArgs
  manTxtToDocbook [] d m >>= \case
    Left  e  -> sayErr e
    Right d' -> case docBookToDocumentation (const True) d' of
      Left  e  -> sayErr e
      Right ds -> for_ ds sayShow

----------------------------------------------------------------
-- Utils
----------------------------------------------------------------

iterateSuffixesM
  :: forall m a b
   . Monad m
  => ([a] -> m (b, [a]))
  -- ^ A function which takes a list transforming it and returning something
  -> [a]
  -- ^ A list to extract parts from
  -> m ([b], [a])
  -- ^ (The list of (non-empty) extracted prefixes, the list without those
  -- prefixes)
iterateSuffixesM split' = foldrM go ([], [])
  where
    go :: a -> ([b], [a]) -> m ([b], [a])
    go x (ss, xs) = first (: ss) <$> split' (x : xs)
