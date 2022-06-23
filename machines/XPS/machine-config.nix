{ config, lib, pkgs, ... }:
with pkgs;

let
  patchDesktop = pkg: appName: from: to: lib.hiPrio (runCommand "$patched-desktop-entry-for-${appName}" {} ''
    ${coreutils}/bin/mkdir -p $out/share/applications
    ${gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
  '');

  nvidia-offload = writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';

in
{

  imports =
    [
      ../laptop_common.nix
    ];

  services.xserver.displayManager.autoLogin = { 
    enable = true; 
    user = "kiran"; 
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
    "nvidia-x11"
    "nvidia-settings"
  ];

  # ------
  # Steam
  # ------

  programs.steam.enable = true;
  environment.systemPackages = [
    steam (patchDesktop steam "steam" "^Exec=" "&nvidia-offload ")
    nvidia-offload
  ];

  # ------
  # NVIDIA
  # ------
  
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  hardware.nvidia.prime = {
    offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

}
