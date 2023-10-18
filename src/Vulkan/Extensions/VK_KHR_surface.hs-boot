{-# language CPP #-}
-- | = Name
--
-- VK_KHR_surface - instance extension
--
-- == VK_KHR_surface
--
-- [__Name String__]
--     @VK_KHR_surface@
--
-- [__Extension Type__]
--     Instance extension
--
-- [__Registered Extension Number__]
--     1
--
-- [__Revision__]
--     25
--
-- [__Ratification Status__]
--     Ratified
--
-- [__Extension and Version Dependencies__; __Contact__]
--
--     -   James Jones
--         <https://github.com/KhronosGroup/Vulkan-Docs/issues/new?body=[VK_KHR_surface] @cubanismo%0A*Here describe the issue or question you have about the VK_KHR_surface extension* >
--
--     -   Ian Elliott
--         <https://github.com/KhronosGroup/Vulkan-Docs/issues/new?body=[VK_KHR_surface] @ianelliottus%0A*Here describe the issue or question you have about the VK_KHR_surface extension* >
--
-- == Other Extension Metadata
--
-- [__Last Modified Date__]
--     2016-08-25
--
-- [__IP Status__]
--     No known IP claims.
--
-- [__Contributors__]
--
--     -   Patrick Doane, Blizzard
--
--     -   Ian Elliott, LunarG
--
--     -   Jesse Hall, Google
--
--     -   James Jones, NVIDIA
--
--     -   David Mao, AMD
--
--     -   Norbert Nopper, Freescale
--
--     -   Alon Or-bach, Samsung
--
--     -   Daniel Rakos, AMD
--
--     -   Graham Sellers, AMD
--
--     -   Jeff Vigil, Qualcomm
--
--     -   Chia-I Wu, LunarG
--
--     -   Faith Ekstrand, Intel
--
-- == Description
--
-- The @VK_KHR_surface@ extension is an instance extension. It introduces
-- 'Vulkan.Extensions.Handles.SurfaceKHR' objects, which abstract native
-- platform surface or window objects for use with Vulkan. It also provides
-- a way to determine whether a queue family in a physical device supports
-- presenting to particular surface.
--
-- Separate extensions for each platform provide the mechanisms for
-- creating 'Vulkan.Extensions.Handles.SurfaceKHR' objects, but once
-- created they may be used in this and other platform-independent
-- extensions, in particular the @VK_KHR_swapchain@ extension.
--
-- == New Object Types
--
-- -   'Vulkan.Extensions.Handles.SurfaceKHR'
--
-- == New Commands
--
-- -   'destroySurfaceKHR'
--
-- -   'getPhysicalDeviceSurfaceCapabilitiesKHR'
--
-- -   'getPhysicalDeviceSurfaceFormatsKHR'
--
-- -   'getPhysicalDeviceSurfacePresentModesKHR'
--
-- -   'getPhysicalDeviceSurfaceSupportKHR'
--
-- == New Structures
--
-- -   'SurfaceCapabilitiesKHR'
--
-- -   'SurfaceFormatKHR'
--
-- == New Enums
--
-- -   'ColorSpaceKHR'
--
-- -   'CompositeAlphaFlagBitsKHR'
--
-- -   'PresentModeKHR'
--
-- -   'SurfaceTransformFlagBitsKHR'
--
-- == New Bitmasks
--
-- -   'CompositeAlphaFlagsKHR'
--
-- == New Enum Constants
--
-- -   'KHR_SURFACE_EXTENSION_NAME'
--
-- -   'KHR_SURFACE_SPEC_VERSION'
--
-- -   Extending 'Vulkan.Core10.Enums.ObjectType.ObjectType':
--
--     -   'Vulkan.Core10.Enums.ObjectType.OBJECT_TYPE_SURFACE_KHR'
--
-- -   Extending 'Vulkan.Core10.Enums.Result.Result':
--
--     -   'Vulkan.Core10.Enums.Result.ERROR_NATIVE_WINDOW_IN_USE_KHR'
--
--     -   'Vulkan.Core10.Enums.Result.ERROR_SURFACE_LOST_KHR'
--
-- == Examples
--
-- Note
--
-- The example code for the @VK_KHR_surface@ and @VK_KHR_swapchain@
-- extensions was removed from the appendix after revision 1.0.29. This WSI
-- example code was ported to the cube demo that is shipped with the
-- official Khronos SDK, and is being kept up-to-date in that location
-- (see:
-- <https://github.com/KhronosGroup/Vulkan-Tools/blob/master/cube/cube.c>).
--
-- == Issues
--
-- 1) Should this extension include a method to query whether a physical
-- device supports presenting to a specific window or native surface on a
-- given platform?
--
-- __RESOLVED__: Yes. Without this, applications would need to create a
-- device instance to determine whether a particular window can be
-- presented to. Knowing that a device supports presentation to a platform
-- in general is not sufficient, as a single machine might support multiple
-- seats, or instances of the platform that each use different underlying
-- physical devices. Additionally, on some platforms, such as the X Window
-- System, different drivers and devices might be used for different
-- windows depending on which section of the desktop they exist on.
--
-- 2) Should the 'getPhysicalDeviceSurfaceCapabilitiesKHR',
-- 'getPhysicalDeviceSurfaceFormatsKHR', and
-- 'getPhysicalDeviceSurfacePresentModesKHR' functions be in this extension
-- and operate on physical devices, rather than being in @VK_KHR_swapchain@
-- (i.e. device extension) and being dependent on
-- 'Vulkan.Core10.Handles.Device'?
--
-- __RESOLVED__: Yes. While it might be useful to depend on
-- 'Vulkan.Core10.Handles.Device' (and therefore on enabled extensions and
-- features) for the queries, Vulkan was released only with the
-- 'Vulkan.Core10.Handles.PhysicalDevice' versions. Many cases can be
-- resolved by a Valid Usage statement, and\/or by a separate @pNext@ chain
-- version of the query struct specific to a given extension or parameters,
-- via extensible versions of the queries:
-- 'Vulkan.Extensions.VK_EXT_full_screen_exclusive.getPhysicalDeviceSurfacePresentModes2EXT',
-- 'Vulkan.Extensions.VK_KHR_get_surface_capabilities2.getPhysicalDeviceSurfaceCapabilities2KHR',
-- and
-- 'Vulkan.Extensions.VK_KHR_get_surface_capabilities2.getPhysicalDeviceSurfaceFormats2KHR'.
--
-- 3) Should Vulkan support Xlib or XCB as the API for accessing the X
-- Window System platform?
--
-- __RESOLVED__: Both. XCB is a more modern and efficient API, but Xlib
-- usage is deeply ingrained in many applications and likely will remain in
-- use for the foreseeable future. Not all drivers necessarily need to
-- support both, but including both as options in the core specification
-- will probably encourage support, which should in turn ease adoption of
-- the Vulkan API in older codebases. Additionally, the performance
-- improvements possible with XCB likely will not have a measurable impact
-- on the performance of Vulkan presentation and other minimal window
-- system interactions defined here.
--
-- 4) Should the GBM platform be included in the list of platform enums?
--
-- __RESOLVED__: Deferred, and will be addressed with a platform-specific
-- extension to be written in the future.
--
-- == Version History
--
-- -   Revision 1, 2015-05-20 (James Jones)
--
--     -   Initial draft, based on LunarG KHR spec, other KHR specs,
--         patches attached to bugs.
--
-- -   Revision 2, 2015-05-22 (Ian Elliott)
--
--     -   Created initial Description section.
--
--     -   Removed query for whether a platform requires the use of a queue
--         for presentation, since it was decided that presentation will
--         always be modeled as being part of the queue.
--
--     -   Fixed typos and other minor mistakes.
--
-- -   Revision 3, 2015-05-26 (Ian Elliott)
--
--     -   Improved the Description section.
--
-- -   Revision 4, 2015-05-27 (James Jones)
--
--     -   Fixed compilation errors in example code.
--
-- -   Revision 5, 2015-06-01 (James Jones)
--
--     -   Added issues 1 and 2 and made related spec updates.
--
-- -   Revision 6, 2015-06-01 (James Jones)
--
--     -   Merged the platform type mappings table previously removed from
--         VK_KHR_swapchain with the platform description table in this
--         spec.
--
--     -   Added issues 3 and 4 documenting choices made when building the
--         initial list of native platforms supported.
--
-- -   Revision 7, 2015-06-11 (Ian Elliott)
--
--     -   Updated table 1 per input from the KHR TSG.
--
--     -   Updated issue 4 (GBM) per discussion with Daniel Stone. He will
--         create a platform-specific extension sometime in the future.
--
-- -   Revision 8, 2015-06-17 (James Jones)
--
--     -   Updated enum-extending values using new convention.
--
--     -   Fixed the value of VK_SURFACE_PLATFORM_INFO_TYPE_SUPPORTED_KHR.
--
-- -   Revision 9, 2015-06-17 (James Jones)
--
--     -   Rebased on Vulkan API version 126.
--
-- -   Revision 10, 2015-06-18 (James Jones)
--
--     -   Marked issues 2 and 3 resolved.
--
-- -   Revision 11, 2015-06-23 (Ian Elliott)
--
--     -   Examples now show use of function pointers for extension
--         functions.
--
--     -   Eliminated extraneous whitespace.
--
-- -   Revision 12, 2015-07-07 (Daniel Rakos)
--
--     -   Added error section describing when each error is expected to be
--         reported.
--
--     -   Replaced the term “queue node index” with “queue family index”
--         in the spec as that is the agreed term to be used in the latest
--         version of the core header and spec.
--
--     -   Replaced bool32_t with VkBool32.
--
-- -   Revision 13, 2015-08-06 (Daniel Rakos)
--
--     -   Updated spec against latest core API header version.
--
-- -   Revision 14, 2015-08-20 (Ian Elliott)
--
--     -   Renamed this extension and all of its enumerations, types,
--         functions, etc. This makes it compliant with the proposed
--         standard for Vulkan extensions.
--
--     -   Switched from “revision” to “version”, including use of the
--         VK_MAKE_VERSION macro in the header file.
--
--     -   Did miscellaneous cleanup, etc.
--
-- -   Revision 15, 2015-08-20 (Ian Elliott—​porting a 2015-07-29 change
--     from James Jones)
--
--     -   Moved the surface transform enums here from VK_WSI_swapchain so
--         they could be reused by VK_WSI_display.
--
-- -   Revision 16, 2015-09-01 (James Jones)
--
--     -   Restore single-field revision number.
--
-- -   Revision 17, 2015-09-01 (James Jones)
--
--     -   Fix example code compilation errors.
--
-- -   Revision 18, 2015-09-26 (Jesse Hall)
--
--     -   Replaced VkSurfaceDescriptionKHR with the VkSurfaceKHR object,
--         which is created via layered extensions. Added
--         VkDestroySurfaceKHR.
--
-- -   Revision 19, 2015-09-28 (Jesse Hall)
--
--     -   Renamed from VK_EXT_KHR_swapchain to VK_EXT_KHR_surface.
--
-- -   Revision 20, 2015-09-30 (Jeff Vigil)
--
--     -   Add error result VK_ERROR_SURFACE_LOST_KHR.
--
-- -   Revision 21, 2015-10-15 (Daniel Rakos)
--
--     -   Updated the resolution of issue #2 and include the surface
--         capability queries in this extension.
--
--     -   Renamed SurfaceProperties to SurfaceCapabilities as it better
--         reflects that the values returned are the capabilities of the
--         surface on a particular device.
--
--     -   Other minor cleanup and consistency changes.
--
-- -   Revision 22, 2015-10-26 (Ian Elliott)
--
--     -   Renamed from VK_EXT_KHR_surface to VK_KHR_surface.
--
-- -   Revision 23, 2015-11-03 (Daniel Rakos)
--
--     -   Added allocation callbacks to vkDestroySurfaceKHR.
--
-- -   Revision 24, 2015-11-10 (Jesse Hall)
--
--     -   Removed VkSurfaceTransformKHR. Use VkSurfaceTransformFlagBitsKHR
--         instead.
--
--     -   Rename VkSurfaceCapabilitiesKHR member maxImageArraySize to
--         maxImageArrayLayers.
--
-- -   Revision 25, 2016-01-14 (James Jones)
--
--     -   Moved VK_ERROR_NATIVE_WINDOW_IN_USE_KHR from the
--         VK_KHR_android_surface to the VK_KHR_surface extension.
--
-- -   2016-08-23 (Ian Elliott)
--
--     -   Update the example code, to not have so many characters per
--         line, and to split out a new example to show how to obtain
--         function pointers.
--
-- -   2016-08-25 (Ian Elliott)
--
--     -   A note was added at the beginning of the example code, stating
--         that it will be removed from future versions of the appendix.
--
-- == See Also
--
-- 'ColorSpaceKHR', 'CompositeAlphaFlagBitsKHR', 'CompositeAlphaFlagsKHR',
-- 'PresentModeKHR', 'SurfaceCapabilitiesKHR', 'SurfaceFormatKHR',
-- 'Vulkan.Extensions.Handles.SurfaceKHR', 'SurfaceTransformFlagBitsKHR',
-- 'destroySurfaceKHR', 'getPhysicalDeviceSurfaceCapabilitiesKHR',
-- 'getPhysicalDeviceSurfaceFormatsKHR',
-- 'getPhysicalDeviceSurfacePresentModesKHR',
-- 'getPhysicalDeviceSurfaceSupportKHR'
--
-- == Document Notes
--
-- For more information, see the
-- <https://registry.khronos.org/vulkan/specs/1.3-extensions/html/vkspec.html#VK_KHR_surface Vulkan Specification>
--
-- This page is a generated document. Fixes and changes should be made to
-- the generator scripts, not directly.
module Vulkan.Extensions.VK_KHR_surface  ( SurfaceCapabilitiesKHR
                                         , SurfaceFormatKHR
                                         , PresentModeKHR
                                         ) where

import Vulkan.CStruct (FromCStruct)
import Vulkan.CStruct (ToCStruct)
import Data.Kind (Type)

data SurfaceCapabilitiesKHR

instance ToCStruct SurfaceCapabilitiesKHR
instance Show SurfaceCapabilitiesKHR

instance FromCStruct SurfaceCapabilitiesKHR


data SurfaceFormatKHR

instance ToCStruct SurfaceFormatKHR
instance Show SurfaceFormatKHR

instance FromCStruct SurfaceFormatKHR


data PresentModeKHR

