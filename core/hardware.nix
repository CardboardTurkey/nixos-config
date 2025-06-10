{ lib, ... }:
{
  options = {
    nvidiaOffload = lib.mkOption {
      default = {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };
      type = lib.types.attrs;
      description = "The env vars required to activate GPU";
    };
  };
}
