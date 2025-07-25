{
  description = "You're nixed son";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager-stable = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon/release-2025-05-17";
    catppuccin.url = "github:catppuccin/nix";
    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
    launcher-theme = {
      url = "https://raw.githubusercontent.com/adi1090x/rofi/refs/heads/master/files/launchers/type-3/style-1.rasi";
      flake = false;
    };
    rofi-emoji-theme = {
      url = "https://raw.githubusercontent.com/adi1090x/rofi/refs/heads/master/files/launchers/type-2/style-2.rasi";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixpkgs-stable,
      home-manager-stable,
      nixos-hardware,
      nix-index-database,
      apple-silicon,
      catppuccin,
      catppuccin-vsc,
      launcher-theme,
      rofi-emoji-theme,
    }:
    let
      shared_modules = hm: [
        ./configuration.nix
        nix-index-database.nixosModules.nix-index
        catppuccin.nixosModules.catppuccin
        hm.nixosModules.home-manager
        { nixpkgs.overlays = [ catppuccin-vsc.overlays.default ]; }
      ];
      systemModPaths = builtins.map (moduleName: "${self.outPath}/system-config/${moduleName}");
      system_modules = [
        "at.nix"
        "boot_loader.nix"
        "greetd.nix"
        "font.nix"
        "pam.nix"
        "pkgs_core.nix"
        "pkgs_aux.nix"
        "users.nix"
        "tailscale.nix"
        "openssh.nix"
        "location.nix"
        "network.nix"
        "sound.nix"
        "office_vpn.nix"
        "containers.nix"
        "boot.nix"
        "printing.nix"
        "file_manager.nix"
        "fwupd.nix"
        "yubikey.nix"
        "qmk.nix"
        "flatpak.nix"
        "upower.nix"
        # "hedgedoc.nix"
        "nix-index-database.nix"
        "sops.nix"
        "hyprland.nix"
        "bluetooth.nix"
        "gnupg.nix"
        "devenv.nix"
        "trash.nix"
        "system_channel.nix"
        "usbip.nix"
      ];
      sharedArgs = {
        userModPaths = builtins.map (moduleName: "${self.outPath}/user-config/${moduleName}");
      };
      hmSharedArgs = {
        catppuccin-hm = catppuccin.homeModules.catppuccin;
        inherit launcher-theme rofi-emoji-theme;
      };
    in
    {
      nixosConfigurations = {
        Osprey = nixpkgs-stable.lib.nixosSystem {
          system = "aarch64-linux";
          modules =
            shared_modules home-manager-stable
            ++ systemModPaths (
              system_modules
              ++ [
                "logiops.nix"
                "usbip_host.nix"
                "sbuk.nix"
              ]
            )
            ++ [
              apple-silicon.nixosModules.default
              ./machines/mini/machine-config.nix
              ./machines/mini/hardware-configuration.nix
              {
                home-manager.extraSpecialArgs = hmSharedArgs;
              }
            ];
          specialArgs = sharedArgs;
        };
        Kestrel = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            shared_modules home-manager
            ++ systemModPaths (
              system_modules
              ++ [
                "atuin.nix"
                "ayden_vpn.nix"
                "battery.nix"
                "jellyfin.nix"
                "hedgedoc.nix"
                "sbuk.nix"
              ]
            )
            ++ [
              ./machines/XPS/machine-config.nix
              ./machines/XPS/hardware-configuration.nix
              nixos-hardware.nixosModules.dell-xps-15-7590
              {
                home-manager.extraSpecialArgs = hmSharedArgs;
              }
            ];
          specialArgs = sharedArgs;
        };
        Harrier = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            shared_modules home-manager
            ++ systemModPaths (
              system_modules
              ++ [
                "battery.nix"
                # "data.nix"
                "sbuk.nix"
              ]
            )
            ++ [
              ./machines/Harrier/machine-config.nix
              ./machines/Harrier/hardware-configuration.nix
              nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen4
              {
                home-manager.extraSpecialArgs = hmSharedArgs;
              }
            ];
          specialArgs = sharedArgs;
        };
        Goshawk = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            shared_modules home-manager
            ++ systemModPaths [
              "at.nix"
              "greetd.nix"
              "font.nix"
              "pam.nix"
              "pkgs_core.nix"
              "users.nix"
              "tailscale.nix"
              "openssh.nix"
              "location.nix"
              "network.nix"
              "sound.nix"
              "boot.nix"
              "printing.nix"
              "file_manager.nix"
              "nix-index-database.nix"
              "sops.nix"
              "hyprland.nix"
              "bluetooth.nix"
              "devenv.nix"
            ]
            ++ [
              ./machines/Goshawk/machine-config.nix
              ./machines/Goshawk/hardware-configuration.nix
              {
                home-manager.extraSpecialArgs = hmSharedArgs;
              }
            ];
          specialArgs = sharedArgs;
        };
        pi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = shared_modules ++ [
            ./machines/pi/machine-config.nix
            ./machines/pi/hardware-configuration.nix
          ];
          specialArgs = sharedArgs;
        };
      };
    };
}
