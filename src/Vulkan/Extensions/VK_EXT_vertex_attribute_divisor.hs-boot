{-# language CPP #-}
-- | = Name
--
-- VK_EXT_vertex_attribute_divisor - device extension
--
-- == VK_EXT_vertex_attribute_divisor
--
-- [__Name String__]
--     @VK_EXT_vertex_attribute_divisor@
--
-- [__Extension Type__]
--     Device extension
--
-- [__Registered Extension Number__]
--     191
--
-- [__Revision__]
--     3
--
-- [__Ratification Status__]
--     Not ratified
--
-- [__Extension and Version Dependencies__]
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#VK_KHR_get_physical_device_properties2 VK_KHR_get_physical_device_properties2>
--     or
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#versions-1.1 Version 1.1>
--
-- [__Contact__]
--
--     -   Vikram Kushwaha
--         <https://github.com/KhronosGroup/Vulkan-Docs/issues/new?body=[VK_EXT_vertex_attribute_divisor] @vkushwaha%0A*Here describe the issue or question you have about the VK_EXT_vertex_attribute_divisor extension* >
--
-- == Other Extension Metadata
--
-- [__Last Modified Date__]
--     2018-08-03
--
-- [__IP Status__]
--     No known IP claims.
--
-- [__Contributors__]
--
--     -   Vikram Kushwaha, NVIDIA
--
--     -   Faith Ekstrand, Intel
--
-- == Description
--
-- This extension allows instance-rate vertex attributes to be repeated for
-- certain number of instances instead of advancing for every instance when
-- instanced rendering is enabled.
--
-- == New Structures
--
-- -   'VertexInputBindingDivisorDescriptionEXT'
--
-- -   Extending
--     'Vulkan.Core11.Promoted_From_VK_KHR_get_physical_device_properties2.PhysicalDeviceFeatures2',
--     'Vulkan.Core10.Device.DeviceCreateInfo':
--
--     -   'PhysicalDeviceVertexAttributeDivisorFeaturesEXT'
--
-- -   Extending
--     'Vulkan.Core11.Promoted_From_VK_KHR_get_physical_device_properties2.PhysicalDeviceProperties2':
--
--     -   'PhysicalDeviceVertexAttributeDivisorPropertiesEXT'
--
-- -   Extending
--     'Vulkan.Core10.Pipeline.PipelineVertexInputStateCreateInfo':
--
--     -   'PipelineVertexInputDivisorStateCreateInfoEXT'
--
-- == New Enum Constants
--
-- -   'EXT_VERTEX_ATTRIBUTE_DIVISOR_EXTENSION_NAME'
--
-- -   'EXT_VERTEX_ATTRIBUTE_DIVISOR_SPEC_VERSION'
--
-- -   Extending 'Vulkan.Core10.Enums.StructureType.StructureType':
--
--     -   'Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_FEATURES_EXT'
--
--     -   'Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_PROPERTIES_EXT'
--
--     -   'Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_DIVISOR_STATE_CREATE_INFO_EXT'
--
-- == Issues
--
-- 1) What is the effect of a non-zero value for @firstInstance@?
--
-- __RESOLVED__: The Vulkan API should follow the OpenGL convention and
-- offset attribute fetching by @firstInstance@ while computing vertex
-- attribute offsets.
--
-- 2) Should zero be an allowed divisor?
--
-- __RESOLVED__: Yes. A zero divisor means the vertex attribute is repeated
-- for all instances.
--
-- == Examples
--
-- To create a vertex binding such that the first binding uses instanced
-- rendering and the same attribute is used for every 4 draw instances, an
-- application could use the following set of structures:
--
-- >     const VkVertexInputBindingDivisorDescriptionEXT divisorDesc =
-- >     {
-- >         .binding = 0,
-- >         .divisor = 4
-- >     };
-- >
-- >     const VkPipelineVertexInputDivisorStateCreateInfoEXT divisorInfo =
-- >     {
-- >         .sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_DIVISOR_STATE_CREATE_INFO_EXT,
-- >         .pNext = NULL,
-- >         .vertexBindingDivisorCount = 1,
-- >         .pVertexBindingDivisors = &divisorDesc
-- >     }
-- >
-- >     const VkVertexInputBindingDescription binding =
-- >     {
-- >         .binding = 0,
-- >         .stride = sizeof(Vertex),
-- >         .inputRate = VK_VERTEX_INPUT_RATE_INSTANCE
-- >     };
-- >
-- >     const VkPipelineVertexInputStateCreateInfo viInfo =
-- >     {
-- >         .sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_CREATE_INFO,
-- >         .pNext = &divisorInfo,
-- >         ...
-- >     };
-- >     //...
--
-- == Version History
--
-- -   Revision 1, 2017-12-04 (Vikram Kushwaha)
--
--     -   First Version
--
-- -   Revision 2, 2018-07-16 (Faith Ekstrand)
--
--     -   Adjust the interaction between @divisor@ and @firstInstance@ to
--         match the OpenGL convention.
--
--     -   Disallow divisors of zero.
--
-- -   Revision 3, 2018-08-03 (Vikram Kushwaha)
--
--     -   Allow a zero divisor.
--
--     -   Add a physical device features structure to query\/enable this
--         feature.
--
-- == See Also
--
-- 'PhysicalDeviceVertexAttributeDivisorFeaturesEXT',
-- 'PhysicalDeviceVertexAttributeDivisorPropertiesEXT',
-- 'PipelineVertexInputDivisorStateCreateInfoEXT',
-- 'VertexInputBindingDivisorDescriptionEXT'
--
-- == Document Notes
--
-- For more information, see the
-- <https://registry.khronos.org/vulkan/specs/1.3-extensions/html/vkspec.html#VK_EXT_vertex_attribute_divisor Vulkan Specification>
--
-- This page is a generated document. Fixes and changes should be made to
-- the generator scripts, not directly.
module Vulkan.Extensions.VK_EXT_vertex_attribute_divisor  ( PhysicalDeviceVertexAttributeDivisorFeaturesEXT
                                                          , PhysicalDeviceVertexAttributeDivisorPropertiesEXT
                                                          , PipelineVertexInputDivisorStateCreateInfoEXT
                                                          , VertexInputBindingDivisorDescriptionEXT
                                                          ) where

import Vulkan.CStruct (FromCStruct)
import Vulkan.CStruct (ToCStruct)
import Data.Kind (Type)

data PhysicalDeviceVertexAttributeDivisorFeaturesEXT

instance ToCStruct PhysicalDeviceVertexAttributeDivisorFeaturesEXT
instance Show PhysicalDeviceVertexAttributeDivisorFeaturesEXT

instance FromCStruct PhysicalDeviceVertexAttributeDivisorFeaturesEXT


data PhysicalDeviceVertexAttributeDivisorPropertiesEXT

instance ToCStruct PhysicalDeviceVertexAttributeDivisorPropertiesEXT
instance Show PhysicalDeviceVertexAttributeDivisorPropertiesEXT

instance FromCStruct PhysicalDeviceVertexAttributeDivisorPropertiesEXT


data PipelineVertexInputDivisorStateCreateInfoEXT

instance ToCStruct PipelineVertexInputDivisorStateCreateInfoEXT
instance Show PipelineVertexInputDivisorStateCreateInfoEXT

instance FromCStruct PipelineVertexInputDivisorStateCreateInfoEXT


data VertexInputBindingDivisorDescriptionEXT

instance ToCStruct VertexInputBindingDivisorDescriptionEXT
instance Show VertexInputBindingDivisorDescriptionEXT

instance FromCStruct VertexInputBindingDivisorDescriptionEXT

