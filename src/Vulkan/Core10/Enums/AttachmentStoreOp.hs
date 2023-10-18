{-# language CPP #-}
-- No documentation found for Chapter "AttachmentStoreOp"
module Vulkan.Core10.Enums.AttachmentStoreOp  (AttachmentStoreOp( ATTACHMENT_STORE_OP_STORE
                                                                , ATTACHMENT_STORE_OP_DONT_CARE
                                                                , ATTACHMENT_STORE_OP_NONE
                                                                , ..
                                                                )) where

import Vulkan.Internal.Utils (enumReadPrec)
import Vulkan.Internal.Utils (enumShowsPrec)
import GHC.Show (showsPrec)
import Vulkan.Zero (Zero)
import Foreign.Storable (Storable)
import Data.Int (Int32)
import GHC.Read (Read(readPrec))
import GHC.Show (Show(showsPrec))

-- | VkAttachmentStoreOp - Specify how contents of an attachment are stored
-- to memory at the end of a subpass
--
-- = Description
--
-- Note
--
-- 'ATTACHMENT_STORE_OP_DONT_CARE' /can/ cause contents generated during
-- previous render passes to be discarded before reaching memory, even if
-- no write to the attachment occurs during the current render pass.
--
-- = See Also
--
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#VK_VERSION_1_0 VK_VERSION_1_0>,
-- 'Vulkan.Core10.Pass.AttachmentDescription',
-- 'Vulkan.Core12.Promoted_From_VK_KHR_create_renderpass2.AttachmentDescription2',
-- 'Vulkan.Core13.Promoted_From_VK_KHR_dynamic_rendering.RenderingAttachmentInfo'
newtype AttachmentStoreOp = AttachmentStoreOp Int32
  deriving newtype (Eq, Ord, Storable, Zero)

-- | 'ATTACHMENT_STORE_OP_STORE' specifies the contents generated during the
-- render pass and within the render area are written to memory. For
-- attachments with a depth\/stencil format, this uses the access type
-- 'Vulkan.Core10.Enums.AccessFlagBits.ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT'.
-- For attachments with a color format, this uses the access type
-- 'Vulkan.Core10.Enums.AccessFlagBits.ACCESS_COLOR_ATTACHMENT_WRITE_BIT'.
pattern ATTACHMENT_STORE_OP_STORE = AttachmentStoreOp 0

-- | 'ATTACHMENT_STORE_OP_DONT_CARE' specifies the contents within the render
-- area are not needed after rendering, and /may/ be discarded; the
-- contents of the attachment will be undefined inside the render area. For
-- attachments with a depth\/stencil format, this uses the access type
-- 'Vulkan.Core10.Enums.AccessFlagBits.ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT'.
-- For attachments with a color format, this uses the access type
-- 'Vulkan.Core10.Enums.AccessFlagBits.ACCESS_COLOR_ATTACHMENT_WRITE_BIT'.
pattern ATTACHMENT_STORE_OP_DONT_CARE = AttachmentStoreOp 1

-- | 'ATTACHMENT_STORE_OP_NONE' specifies the contents within the render area
-- are not accessed by the store operation as long as no values are written
-- to the attachment during the render pass. If values are written during
-- the render pass, this behaves identically to
-- 'ATTACHMENT_STORE_OP_DONT_CARE' and with matching access semantics.
pattern ATTACHMENT_STORE_OP_NONE = AttachmentStoreOp 1000301000

{-# COMPLETE
  ATTACHMENT_STORE_OP_STORE
  , ATTACHMENT_STORE_OP_DONT_CARE
  , ATTACHMENT_STORE_OP_NONE ::
    AttachmentStoreOp
  #-}

conNameAttachmentStoreOp :: String
conNameAttachmentStoreOp = "AttachmentStoreOp"

enumPrefixAttachmentStoreOp :: String
enumPrefixAttachmentStoreOp = "ATTACHMENT_STORE_OP_"

showTableAttachmentStoreOp :: [(AttachmentStoreOp, String)]
showTableAttachmentStoreOp =
  [ (ATTACHMENT_STORE_OP_STORE, "STORE")
  , (ATTACHMENT_STORE_OP_DONT_CARE, "DONT_CARE")
  , (ATTACHMENT_STORE_OP_NONE, "NONE")
  ]

instance Show AttachmentStoreOp where
  showsPrec =
    enumShowsPrec
      enumPrefixAttachmentStoreOp
      showTableAttachmentStoreOp
      conNameAttachmentStoreOp
      (\(AttachmentStoreOp x) -> x)
      (showsPrec 11)

instance Read AttachmentStoreOp where
  readPrec =
    enumReadPrec
      enumPrefixAttachmentStoreOp
      showTableAttachmentStoreOp
      conNameAttachmentStoreOp
      AttachmentStoreOp
