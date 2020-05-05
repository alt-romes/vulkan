{-# language CPP #-}
module Vulkan.Extensions.VK_KHR_external_semaphore_win32  ( getSemaphoreWin32HandleKHR
                                                          , importSemaphoreWin32HandleKHR
                                                          , ImportSemaphoreWin32HandleInfoKHR(..)
                                                          , ExportSemaphoreWin32HandleInfoKHR(..)
                                                          , D3D12FenceSubmitInfoKHR(..)
                                                          , SemaphoreGetWin32HandleInfoKHR(..)
                                                          , KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION
                                                          , pattern KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION
                                                          , KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME
                                                          , pattern KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME
                                                          , HANDLE
                                                          , DWORD
                                                          , LPCWSTR
                                                          , SECURITY_ATTRIBUTES
                                                          ) where

import Control.Exception.Base (bracket)
import Control.Monad.IO.Class (liftIO)
import Foreign.Marshal.Alloc (allocaBytesAligned)
import Foreign.Marshal.Alloc (callocBytes)
import Foreign.Marshal.Alloc (free)
import Foreign.Marshal.Utils (maybePeek)
import GHC.Base (when)
import GHC.IO (throwIO)
import Foreign.Ptr (nullPtr)
import Foreign.Ptr (plusPtr)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Cont (evalContT)
import Data.Vector (generateM)
import qualified Data.Vector (imapM_)
import qualified Data.Vector (length)
import Control.Monad.IO.Class (MonadIO)
import Data.Either (Either)
import Data.String (IsString)
import Data.Typeable (Typeable)
import Foreign.Storable (Storable)
import Foreign.Storable (Storable(peek))
import Foreign.Storable (Storable(poke))
import qualified Foreign.Storable (Storable(..))
import Foreign.Ptr (FunPtr)
import Foreign.Ptr (Ptr)
import Data.Word (Word32)
import Data.Word (Word64)
import Data.Kind (Type)
import Control.Monad.Trans.Cont (ContT(..))
import Data.Vector (Vector)
import Vulkan.CStruct.Utils (advancePtrBytes)
import Vulkan.Extensions.WSITypes (DWORD)
import Vulkan.Core10.Handles (Device)
import Vulkan.Core10.Handles (Device(..))
import Vulkan.Dynamic (DeviceCmds(pVkGetSemaphoreWin32HandleKHR))
import Vulkan.Dynamic (DeviceCmds(pVkImportSemaphoreWin32HandleKHR))
import Vulkan.Core10.Handles (Device_T)
import Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits (ExternalSemaphoreHandleTypeFlagBits)
import Vulkan.CStruct (FromCStruct)
import Vulkan.CStruct (FromCStruct(..))
import Vulkan.Extensions.WSITypes (HANDLE)
import Vulkan.Extensions.WSITypes (LPCWSTR)
import Vulkan.Core10.Enums.Result (Result)
import Vulkan.Core10.Enums.Result (Result(..))
import Vulkan.Extensions.WSITypes (SECURITY_ATTRIBUTES)
import Vulkan.Core10.Handles (Semaphore)
import Vulkan.Core11.Enums.SemaphoreImportFlagBits (SemaphoreImportFlags)
import Vulkan.Core10.Enums.StructureType (StructureType)
import Vulkan.CStruct (ToCStruct)
import Vulkan.CStruct (ToCStruct(..))
import Vulkan.Exception (VulkanException(..))
import Vulkan.Zero (Zero(..))
import Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR))
import Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR))
import Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR))
import Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR))
import Vulkan.Core10.Enums.Result (Result(SUCCESS))
import Vulkan.Extensions.WSITypes (DWORD)
import Vulkan.Extensions.WSITypes (HANDLE)
import Vulkan.Extensions.WSITypes (LPCWSTR)
import Vulkan.Extensions.WSITypes (SECURITY_ATTRIBUTES)
foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkGetSemaphoreWin32HandleKHR
  :: FunPtr (Ptr Device_T -> Ptr SemaphoreGetWin32HandleInfoKHR -> Ptr HANDLE -> IO Result) -> Ptr Device_T -> Ptr SemaphoreGetWin32HandleInfoKHR -> Ptr HANDLE -> IO Result

-- | vkGetSemaphoreWin32HandleKHR - Get a Windows HANDLE for a semaphore
--
-- = Parameters
--
-- -   @device@ is the logical device that created the semaphore being
--     exported.
--
-- -   @pGetWin32HandleInfo@ is a pointer to a
--     'SemaphoreGetWin32HandleInfoKHR' structure containing parameters of
--     the export operation.
--
-- -   @pHandle@ will return the Windows handle representing the semaphore
--     state.
--
-- = Description
--
-- For handle types defined as NT handles, the handles returned by
-- 'getSemaphoreWin32HandleKHR' are owned by the application. To avoid
-- leaking resources, the application /must/ release ownership of them
-- using the @CloseHandle@ system call when they are no longer needed.
--
-- Exporting a Windows handle from a semaphore /may/ have side effects
-- depending on the transference of the specified handle type, as described
-- in
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-importing Importing Semaphore Payloads>.
--
-- == Return Codes
--
-- [<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#fundamentals-successcodes Success>]
--
--     -   'Vulkan.Core10.Enums.Result.SUCCESS'
--
-- [<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#fundamentals-errorcodes Failure>]
--
--     -   'Vulkan.Core10.Enums.Result.ERROR_TOO_MANY_OBJECTS'
--
--     -   'Vulkan.Core10.Enums.Result.ERROR_OUT_OF_HOST_MEMORY'
--
-- = See Also
--
-- 'Vulkan.Core10.Handles.Device', 'SemaphoreGetWin32HandleInfoKHR'
getSemaphoreWin32HandleKHR :: forall io . MonadIO io => Device -> SemaphoreGetWin32HandleInfoKHR -> io (HANDLE)
getSemaphoreWin32HandleKHR device getWin32HandleInfo = liftIO . evalContT $ do
  let vkGetSemaphoreWin32HandleKHR' = mkVkGetSemaphoreWin32HandleKHR (pVkGetSemaphoreWin32HandleKHR (deviceCmds (device :: Device)))
  pGetWin32HandleInfo <- ContT $ withCStruct (getWin32HandleInfo)
  pPHandle <- ContT $ bracket (callocBytes @HANDLE 8) free
  r <- lift $ vkGetSemaphoreWin32HandleKHR' (deviceHandle (device)) pGetWin32HandleInfo (pPHandle)
  lift $ when (r < SUCCESS) (throwIO (VulkanException r))
  pHandle <- lift $ peek @HANDLE pPHandle
  pure $ (pHandle)


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkImportSemaphoreWin32HandleKHR
  :: FunPtr (Ptr Device_T -> Ptr ImportSemaphoreWin32HandleInfoKHR -> IO Result) -> Ptr Device_T -> Ptr ImportSemaphoreWin32HandleInfoKHR -> IO Result

-- | vkImportSemaphoreWin32HandleKHR - Import a semaphore from a Windows
-- HANDLE
--
-- = Parameters
--
-- -   @device@ is the logical device that created the semaphore.
--
-- -   @pImportSemaphoreWin32HandleInfo@ is a pointer to a
--     'ImportSemaphoreWin32HandleInfoKHR' structure specifying the
--     semaphore and import parameters.
--
-- = Description
--
-- Importing a semaphore payload from Windows handles does not transfer
-- ownership of the handle to the Vulkan implementation. For handle types
-- defined as NT handles, the application /must/ release ownership using
-- the @CloseHandle@ system call when the handle is no longer needed.
--
-- Applications /can/ import the same semaphore payload into multiple
-- instances of Vulkan, into the same instance from which it was exported,
-- and multiple times into a given Vulkan instance.
--
-- == Return Codes
--
-- [<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#fundamentals-successcodes Success>]
--
--     -   'Vulkan.Core10.Enums.Result.SUCCESS'
--
-- [<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#fundamentals-errorcodes Failure>]
--
--     -   'Vulkan.Core10.Enums.Result.ERROR_OUT_OF_HOST_MEMORY'
--
--     -   'Vulkan.Core10.Enums.Result.ERROR_INVALID_EXTERNAL_HANDLE'
--
-- = See Also
--
-- 'Vulkan.Core10.Handles.Device', 'ImportSemaphoreWin32HandleInfoKHR'
importSemaphoreWin32HandleKHR :: forall io . MonadIO io => Device -> ImportSemaphoreWin32HandleInfoKHR -> io ()
importSemaphoreWin32HandleKHR device importSemaphoreWin32HandleInfo = liftIO . evalContT $ do
  let vkImportSemaphoreWin32HandleKHR' = mkVkImportSemaphoreWin32HandleKHR (pVkImportSemaphoreWin32HandleKHR (deviceCmds (device :: Device)))
  pImportSemaphoreWin32HandleInfo <- ContT $ withCStruct (importSemaphoreWin32HandleInfo)
  r <- lift $ vkImportSemaphoreWin32HandleKHR' (deviceHandle (device)) pImportSemaphoreWin32HandleInfo
  lift $ when (r < SUCCESS) (throwIO (VulkanException r))


-- | VkImportSemaphoreWin32HandleInfoKHR - Structure specifying Windows
-- handle to import to a semaphore
--
-- = Description
--
-- The handle types supported by @handleType@ are:
--
-- +---------------------------------------------------------------------------------------------------------------+----------------------+-----------------------+
-- | Handle Type                                                                                                   | Transference         | Permanence Supported  |
-- +===============================================================================================================+======================+=======================+
-- | 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT'     | Reference            | Temporary,Permanent   |
-- +---------------------------------------------------------------------------------------------------------------+----------------------+-----------------------+
-- | 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT' | Reference            | Temporary,Permanent   |
-- +---------------------------------------------------------------------------------------------------------------+----------------------+-----------------------+
-- | 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT'      | Reference            | Temporary,Permanent   |
-- +---------------------------------------------------------------------------------------------------------------+----------------------+-----------------------+
--
-- Handle Types Supported by 'ImportSemaphoreWin32HandleInfoKHR'
--
-- == Valid Usage
--
-- -   @handleType@ /must/ be a value included in the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphore-handletypes-win32 Handle Types Supported by >
--     table
--
-- -   If @handleType@ is not
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT'
--     or
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT',
--     @name@ /must/ be @NULL@
--
-- -   If @handleType@ is not @0@ and @handle@ is @NULL@, @name@ /must/
--     name a valid synchronization primitive of the type specified by
--     @handleType@
--
-- -   If @handleType@ is not @0@ and @name@ is @NULL@, @handle@ /must/ be
--     a valid handle of the type specified by @handleType@
--
-- -   If @handle@ is not @NULL@, @name@ /must/ be @NULL@
--
-- -   If @handle@ is not @NULL@, it /must/ obey any requirements listed
--     for @handleType@ in
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#external-semaphore-handle-types-compatibility external semaphore handle types compatibility>
--
-- -   If @name@ is not @NULL@, it /must/ obey any requirements listed for
--     @handleType@ in
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#external-semaphore-handle-types-compatibility external semaphore handle types compatibility>
--
-- -   If @handleType@ is
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT'
--     or
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT',
--     the 'Vulkan.Core10.QueueSemaphore.SemaphoreCreateInfo'::@flags@
--     field /must/ match that of the semaphore from which @handle@ or
--     @name@ was exported
--
-- -   If @handleType@ is
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT'
--     or
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT',
--     the
--     'Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.SemaphoreTypeCreateInfo'::@semaphoreType@
--     field /must/ match that of the semaphore from which @handle@ or
--     @name@ was exported
--
-- -   If @flags@ contains
--     'Vulkan.Core11.Enums.SemaphoreImportFlagBits.SEMAPHORE_IMPORT_TEMPORARY_BIT',
--     the
--     'Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.SemaphoreTypeCreateInfo'::@semaphoreType@
--     field of the semaphore from which @handle@ or @name@ was exported
--     /must/ not be
--     'Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_TIMELINE'
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR'
--
-- -   @pNext@ /must/ be @NULL@
--
-- -   @semaphore@ /must/ be a valid 'Vulkan.Core10.Handles.Semaphore'
--     handle
--
-- -   @flags@ /must/ be a valid combination of
--     'Vulkan.Core11.Enums.SemaphoreImportFlagBits.SemaphoreImportFlagBits'
--     values
--
-- -   If @handleType@ is not @0@, @handleType@ /must/ be a valid
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.ExternalSemaphoreHandleTypeFlagBits'
--     value
--
-- == Host Synchronization
--
-- -   Host access to @semaphore@ /must/ be externally synchronized
--
-- = See Also
--
-- 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.ExternalSemaphoreHandleTypeFlagBits',
-- 'Vulkan.Core10.Handles.Semaphore',
-- 'Vulkan.Core11.Enums.SemaphoreImportFlagBits.SemaphoreImportFlags',
-- 'Vulkan.Core10.Enums.StructureType.StructureType',
-- 'importSemaphoreWin32HandleKHR'
data ImportSemaphoreWin32HandleInfoKHR = ImportSemaphoreWin32HandleInfoKHR
  { -- | @semaphore@ is the semaphore into which the payload will be imported.
    semaphore :: Semaphore
  , -- | @flags@ is a bitmask of
    -- 'Vulkan.Core11.Enums.SemaphoreImportFlagBits.SemaphoreImportFlagBits'
    -- specifying additional parameters for the semaphore payload import
    -- operation.
    flags :: SemaphoreImportFlags
  , -- | @handleType@ specifies the type of @handle@.
    handleType :: ExternalSemaphoreHandleTypeFlagBits
  , -- | @handle@ is the external handle to import, or @NULL@.
    handle :: HANDLE
  , -- | @name@ is a null-terminated UTF-16 string naming the underlying
    -- synchronization primitive to import, or @NULL@.
    name :: LPCWSTR
  }
  deriving (Typeable)
deriving instance Show ImportSemaphoreWin32HandleInfoKHR

instance ToCStruct ImportSemaphoreWin32HandleInfoKHR where
  withCStruct x f = allocaBytesAligned 48 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p ImportSemaphoreWin32HandleInfoKHR{..} f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    poke ((p `plusPtr` 16 :: Ptr Semaphore)) (semaphore)
    poke ((p `plusPtr` 24 :: Ptr SemaphoreImportFlags)) (flags)
    poke ((p `plusPtr` 28 :: Ptr ExternalSemaphoreHandleTypeFlagBits)) (handleType)
    poke ((p `plusPtr` 32 :: Ptr HANDLE)) (handle)
    poke ((p `plusPtr` 40 :: Ptr LPCWSTR)) (name)
    f
  cStructSize = 48
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    poke ((p `plusPtr` 16 :: Ptr Semaphore)) (zero)
    f

instance FromCStruct ImportSemaphoreWin32HandleInfoKHR where
  peekCStruct p = do
    semaphore <- peek @Semaphore ((p `plusPtr` 16 :: Ptr Semaphore))
    flags <- peek @SemaphoreImportFlags ((p `plusPtr` 24 :: Ptr SemaphoreImportFlags))
    handleType <- peek @ExternalSemaphoreHandleTypeFlagBits ((p `plusPtr` 28 :: Ptr ExternalSemaphoreHandleTypeFlagBits))
    handle <- peek @HANDLE ((p `plusPtr` 32 :: Ptr HANDLE))
    name <- peek @LPCWSTR ((p `plusPtr` 40 :: Ptr LPCWSTR))
    pure $ ImportSemaphoreWin32HandleInfoKHR
             semaphore flags handleType handle name

instance Storable ImportSemaphoreWin32HandleInfoKHR where
  sizeOf ~_ = 48
  alignment ~_ = 8
  peek = peekCStruct
  poke ptr poked = pokeCStruct ptr poked (pure ())

instance Zero ImportSemaphoreWin32HandleInfoKHR where
  zero = ImportSemaphoreWin32HandleInfoKHR
           zero
           zero
           zero
           zero
           zero


-- | VkExportSemaphoreWin32HandleInfoKHR - Structure specifying additional
-- attributes of Windows handles exported from a semaphore
--
-- = Description
--
-- If
-- 'Vulkan.Core11.Promoted_From_VK_KHR_external_semaphore.ExportSemaphoreCreateInfo'
-- is not present in the same @pNext@ chain, this structure is ignored.
--
-- If
-- 'Vulkan.Core11.Promoted_From_VK_KHR_external_semaphore.ExportSemaphoreCreateInfo'
-- is present in the @pNext@ chain of
-- 'Vulkan.Core10.QueueSemaphore.SemaphoreCreateInfo' with a Windows
-- @handleType@, but either 'ExportSemaphoreWin32HandleInfoKHR' is not
-- present in the @pNext@ chain, or if it is but @pAttributes@ is set to
-- @NULL@, default security descriptor values will be used, and child
-- processes created by the application will not inherit the handle, as
-- described in the MSDN documentation for “Synchronization Object Security
-- and Access Rights”1. Further, if the structure is not present, the
-- access rights used depend on the handle type.
--
-- For handles of the following types:
--
-- 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT'
--
-- The implementation /must/ ensure the access rights allow both signal and
-- wait operations on the semaphore.
--
-- For handles of the following types:
--
-- 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT'
--
-- The access rights /must/ be:
--
-- @GENERIC_ALL@
--
-- [1]
--     <https://docs.microsoft.com/en-us/windows/win32/sync/synchronization-object-security-and-access-rights>
--
-- == Valid Usage
--
-- -   If
--     'Vulkan.Core11.Promoted_From_VK_KHR_external_semaphore.ExportSemaphoreCreateInfo'::@handleTypes@
--     does not include
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT'
--     or
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT',
--     'ExportSemaphoreWin32HandleInfoKHR' /must/ not be included in the
--     @pNext@ chain of 'Vulkan.Core10.QueueSemaphore.SemaphoreCreateInfo'
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR'
--
-- -   If @pAttributes@ is not @NULL@, @pAttributes@ /must/ be a valid
--     pointer to a valid 'Vulkan.Extensions.WSITypes.SECURITY_ATTRIBUTES'
--     value
--
-- = See Also
--
-- 'Vulkan.Core10.Enums.StructureType.StructureType'
data ExportSemaphoreWin32HandleInfoKHR = ExportSemaphoreWin32HandleInfoKHR
  { -- | @pAttributes@ is a pointer to a Windows
    -- 'Vulkan.Extensions.WSITypes.SECURITY_ATTRIBUTES' structure specifying
    -- security attributes of the handle.
    attributes :: Ptr SECURITY_ATTRIBUTES
  , -- | @dwAccess@ is a 'Vulkan.Extensions.WSITypes.DWORD' specifying access
    -- rights of the handle.
    dwAccess :: DWORD
  , -- | @name@ is a null-terminated UTF-16 string to associate with the
    -- underlying synchronization primitive referenced by NT handles exported
    -- from the created semaphore.
    name :: LPCWSTR
  }
  deriving (Typeable)
deriving instance Show ExportSemaphoreWin32HandleInfoKHR

instance ToCStruct ExportSemaphoreWin32HandleInfoKHR where
  withCStruct x f = allocaBytesAligned 40 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p ExportSemaphoreWin32HandleInfoKHR{..} f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    poke ((p `plusPtr` 16 :: Ptr (Ptr SECURITY_ATTRIBUTES))) (attributes)
    poke ((p `plusPtr` 24 :: Ptr DWORD)) (dwAccess)
    poke ((p `plusPtr` 32 :: Ptr LPCWSTR)) (name)
    f
  cStructSize = 40
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    poke ((p `plusPtr` 24 :: Ptr DWORD)) (zero)
    poke ((p `plusPtr` 32 :: Ptr LPCWSTR)) (zero)
    f

instance FromCStruct ExportSemaphoreWin32HandleInfoKHR where
  peekCStruct p = do
    pAttributes <- peek @(Ptr SECURITY_ATTRIBUTES) ((p `plusPtr` 16 :: Ptr (Ptr SECURITY_ATTRIBUTES)))
    dwAccess <- peek @DWORD ((p `plusPtr` 24 :: Ptr DWORD))
    name <- peek @LPCWSTR ((p `plusPtr` 32 :: Ptr LPCWSTR))
    pure $ ExportSemaphoreWin32HandleInfoKHR
             pAttributes dwAccess name

instance Storable ExportSemaphoreWin32HandleInfoKHR where
  sizeOf ~_ = 40
  alignment ~_ = 8
  peek = peekCStruct
  poke ptr poked = pokeCStruct ptr poked (pure ())

instance Zero ExportSemaphoreWin32HandleInfoKHR where
  zero = ExportSemaphoreWin32HandleInfoKHR
           zero
           zero
           zero


-- | VkD3D12FenceSubmitInfoKHR - Structure specifying values for Direct3D 12
-- fence-backed semaphores
--
-- = Description
--
-- If the semaphore in 'Vulkan.Core10.Queue.SubmitInfo'::@pWaitSemaphores@
-- or 'Vulkan.Core10.Queue.SubmitInfo'::@pSignalSemaphores@ corresponding
-- to an entry in @pWaitSemaphoreValues@ or @pSignalSemaphoreValues@
-- respectively does not currently have a
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-payloads payload>
-- referring to a Direct3D 12 fence, the implementation /must/ ignore the
-- value in the @pWaitSemaphoreValues@ or @pSignalSemaphoreValues@ entry.
--
-- Note
--
-- As the introduction of the external semaphore handle type
-- 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT'
-- predates that of timeline semaphores, support for importing semaphore
-- payloads from external handles of that type into semaphores created
-- (implicitly or explicitly) with a
-- 'Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
-- 'Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_BINARY' is preserved
-- for backwards compatibility. However, applications /should/ prefer
-- importing such handle types into semaphores created with a
-- 'Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
-- 'Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_TIMELINE', and use the
-- 'Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.TimelineSemaphoreSubmitInfo'
-- structure instead of the 'D3D12FenceSubmitInfoKHR' structure to specify
-- the values to use when waiting for and signaling such semaphores.
--
-- == Valid Usage
--
-- -   @waitSemaphoreValuesCount@ /must/ be the same value as
--     'Vulkan.Core10.Queue.SubmitInfo'::@waitSemaphoreCount@, where
--     'Vulkan.Core10.Queue.SubmitInfo' is in the @pNext@ chain of this
--     'D3D12FenceSubmitInfoKHR' structure
--
-- -   @signalSemaphoreValuesCount@ /must/ be the same value as
--     'Vulkan.Core10.Queue.SubmitInfo'::@signalSemaphoreCount@, where
--     'Vulkan.Core10.Queue.SubmitInfo' is in the @pNext@ chain of this
--     'D3D12FenceSubmitInfoKHR' structure
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR'
--
-- -   If @waitSemaphoreValuesCount@ is not @0@, and @pWaitSemaphoreValues@
--     is not @NULL@, @pWaitSemaphoreValues@ /must/ be a valid pointer to
--     an array of @waitSemaphoreValuesCount@ @uint64_t@ values
--
-- -   If @signalSemaphoreValuesCount@ is not @0@, and
--     @pSignalSemaphoreValues@ is not @NULL@, @pSignalSemaphoreValues@
--     /must/ be a valid pointer to an array of
--     @signalSemaphoreValuesCount@ @uint64_t@ values
--
-- = See Also
--
-- 'Vulkan.Core10.Enums.StructureType.StructureType'
data D3D12FenceSubmitInfoKHR = D3D12FenceSubmitInfoKHR
  { -- | @pWaitSemaphoreValues@ is a pointer to an array of
    -- @waitSemaphoreValuesCount@ values for the corresponding semaphores in
    -- 'Vulkan.Core10.Queue.SubmitInfo'::@pWaitSemaphores@ to wait for.
    waitSemaphoreValues :: Either Word32 (Vector Word64)
  , -- | @pSignalSemaphoreValues@ is a pointer to an array of
    -- @signalSemaphoreValuesCount@ values for the corresponding semaphores in
    -- 'Vulkan.Core10.Queue.SubmitInfo'::@pSignalSemaphores@ to set when
    -- signaled.
    signalSemaphoreValues :: Either Word32 (Vector Word64)
  }
  deriving (Typeable)
deriving instance Show D3D12FenceSubmitInfoKHR

instance ToCStruct D3D12FenceSubmitInfoKHR where
  withCStruct x f = allocaBytesAligned 48 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p D3D12FenceSubmitInfoKHR{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR)
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    lift $ poke ((p `plusPtr` 16 :: Ptr Word32)) ((fromIntegral (either id (fromIntegral . Data.Vector.length) (waitSemaphoreValues)) :: Word32))
    pWaitSemaphoreValues'' <- case (waitSemaphoreValues) of
      Left _ -> pure nullPtr
      Right v -> do
        pPWaitSemaphoreValues' <- ContT $ allocaBytesAligned @Word64 ((Data.Vector.length (v)) * 8) 8
        lift $ Data.Vector.imapM_ (\i e -> poke (pPWaitSemaphoreValues' `plusPtr` (8 * (i)) :: Ptr Word64) (e)) (v)
        pure $ pPWaitSemaphoreValues'
    lift $ poke ((p `plusPtr` 24 :: Ptr (Ptr Word64))) pWaitSemaphoreValues''
    lift $ poke ((p `plusPtr` 32 :: Ptr Word32)) ((fromIntegral (either id (fromIntegral . Data.Vector.length) (signalSemaphoreValues)) :: Word32))
    pSignalSemaphoreValues'' <- case (signalSemaphoreValues) of
      Left _ -> pure nullPtr
      Right v -> do
        pPSignalSemaphoreValues' <- ContT $ allocaBytesAligned @Word64 ((Data.Vector.length (v)) * 8) 8
        lift $ Data.Vector.imapM_ (\i e -> poke (pPSignalSemaphoreValues' `plusPtr` (8 * (i)) :: Ptr Word64) (e)) (v)
        pure $ pPSignalSemaphoreValues'
    lift $ poke ((p `plusPtr` 40 :: Ptr (Ptr Word64))) pSignalSemaphoreValues''
    lift $ f
  cStructSize = 48
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    f

instance FromCStruct D3D12FenceSubmitInfoKHR where
  peekCStruct p = do
    waitSemaphoreValuesCount <- peek @Word32 ((p `plusPtr` 16 :: Ptr Word32))
    pWaitSemaphoreValues <- peek @(Ptr Word64) ((p `plusPtr` 24 :: Ptr (Ptr Word64)))
    pWaitSemaphoreValues' <- maybePeek (\j -> generateM (fromIntegral waitSemaphoreValuesCount) (\i -> peek @Word64 (((j) `advancePtrBytes` (8 * (i)) :: Ptr Word64)))) pWaitSemaphoreValues
    let pWaitSemaphoreValues'' = maybe (Left waitSemaphoreValuesCount) Right pWaitSemaphoreValues'
    signalSemaphoreValuesCount <- peek @Word32 ((p `plusPtr` 32 :: Ptr Word32))
    pSignalSemaphoreValues <- peek @(Ptr Word64) ((p `plusPtr` 40 :: Ptr (Ptr Word64)))
    pSignalSemaphoreValues' <- maybePeek (\j -> generateM (fromIntegral signalSemaphoreValuesCount) (\i -> peek @Word64 (((j) `advancePtrBytes` (8 * (i)) :: Ptr Word64)))) pSignalSemaphoreValues
    let pSignalSemaphoreValues'' = maybe (Left signalSemaphoreValuesCount) Right pSignalSemaphoreValues'
    pure $ D3D12FenceSubmitInfoKHR
             pWaitSemaphoreValues'' pSignalSemaphoreValues''

instance Zero D3D12FenceSubmitInfoKHR where
  zero = D3D12FenceSubmitInfoKHR
           (Left 0)
           (Left 0)


-- | VkSemaphoreGetWin32HandleInfoKHR - Structure describing a Win32 handle
-- semaphore export operation
--
-- = Description
--
-- The properties of the handle returned depend on the value of
-- @handleType@. See
-- 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.ExternalSemaphoreHandleTypeFlagBits'
-- for a description of the properties of the defined external semaphore
-- handle types.
--
-- == Valid Usage
--
-- -   @handleType@ /must/ have been included in
--     'Vulkan.Core11.Promoted_From_VK_KHR_external_semaphore.ExportSemaphoreCreateInfo'::@handleTypes@
--     when the @semaphore@’s current payload was created
--
-- -   If @handleType@ is defined as an NT handle,
--     'getSemaphoreWin32HandleKHR' /must/ be called no more than once for
--     each valid unique combination of @semaphore@ and @handleType@
--
-- -   @semaphore@ /must/ not currently have its payload replaced by an
--     imported payload as described below in
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-importing Importing Semaphore Payloads>
--     unless that imported payload’s handle type was included in
--     'Vulkan.Core11.Promoted_From_VK_KHR_external_semaphore_capabilities.ExternalSemaphoreProperties'::@exportFromImportedHandleTypes@
--     for @handleType@
--
-- -   If @handleType@ refers to a handle type with copy payload
--     transference semantics, as defined below in
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-importing Importing Semaphore Payloads>,
--     there /must/ be no queue waiting on @semaphore@
--
-- -   If @handleType@ refers to a handle type with copy payload
--     transference semantics, @semaphore@ /must/ be signaled, or have an
--     associated
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-signaling semaphore signal operation>
--     pending execution
--
-- -   @handleType@ /must/ be defined as an NT handle or a global share
--     handle
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR'
--
-- -   @pNext@ /must/ be @NULL@
--
-- -   @semaphore@ /must/ be a valid 'Vulkan.Core10.Handles.Semaphore'
--     handle
--
-- -   @handleType@ /must/ be a valid
--     'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.ExternalSemaphoreHandleTypeFlagBits'
--     value
--
-- = See Also
--
-- 'Vulkan.Core11.Enums.ExternalSemaphoreHandleTypeFlagBits.ExternalSemaphoreHandleTypeFlagBits',
-- 'Vulkan.Core10.Handles.Semaphore',
-- 'Vulkan.Core10.Enums.StructureType.StructureType',
-- 'getSemaphoreWin32HandleKHR'
data SemaphoreGetWin32HandleInfoKHR = SemaphoreGetWin32HandleInfoKHR
  { -- | @semaphore@ is the semaphore from which state will be exported.
    semaphore :: Semaphore
  , -- | @handleType@ is the type of handle requested.
    handleType :: ExternalSemaphoreHandleTypeFlagBits
  }
  deriving (Typeable)
deriving instance Show SemaphoreGetWin32HandleInfoKHR

instance ToCStruct SemaphoreGetWin32HandleInfoKHR where
  withCStruct x f = allocaBytesAligned 32 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p SemaphoreGetWin32HandleInfoKHR{..} f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    poke ((p `plusPtr` 16 :: Ptr Semaphore)) (semaphore)
    poke ((p `plusPtr` 24 :: Ptr ExternalSemaphoreHandleTypeFlagBits)) (handleType)
    f
  cStructSize = 32
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    poke ((p `plusPtr` 16 :: Ptr Semaphore)) (zero)
    poke ((p `plusPtr` 24 :: Ptr ExternalSemaphoreHandleTypeFlagBits)) (zero)
    f

instance FromCStruct SemaphoreGetWin32HandleInfoKHR where
  peekCStruct p = do
    semaphore <- peek @Semaphore ((p `plusPtr` 16 :: Ptr Semaphore))
    handleType <- peek @ExternalSemaphoreHandleTypeFlagBits ((p `plusPtr` 24 :: Ptr ExternalSemaphoreHandleTypeFlagBits))
    pure $ SemaphoreGetWin32HandleInfoKHR
             semaphore handleType

instance Storable SemaphoreGetWin32HandleInfoKHR where
  sizeOf ~_ = 32
  alignment ~_ = 8
  peek = peekCStruct
  poke ptr poked = pokeCStruct ptr poked (pure ())

instance Zero SemaphoreGetWin32HandleInfoKHR where
  zero = SemaphoreGetWin32HandleInfoKHR
           zero
           zero


type KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION = 1

-- No documentation found for TopLevel "VK_KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION"
pattern KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION :: forall a . Integral a => a
pattern KHR_EXTERNAL_SEMAPHORE_WIN32_SPEC_VERSION = 1


type KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME = "VK_KHR_external_semaphore_win32"

-- No documentation found for TopLevel "VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME"
pattern KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME :: forall a . (Eq a, IsString a) => a
pattern KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME = "VK_KHR_external_semaphore_win32"
