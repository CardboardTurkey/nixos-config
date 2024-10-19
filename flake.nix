{
  description = "You're nixed son";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
  };
  outputs = { self, nixpkgs, nixos-hardware, nix-index-database, home-manager
    , apple-silicon, catppuccin, catppuccin-vsc }:
    let
      shared_modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        nix-index-database.nixosModules.nix-index
        catppuccin.nixosModules.catppuccin
        { nixpkgs.overlays = [ catppuccin-vsc.overlays.default ]; }
      ];
      systemModPaths = builtins.map
        (moduleName: "${self.outPath}/system-config/${moduleName}");
      system_modules = [
        "at.nix"
        "boot_loader.nix"
        "greetd.nix"
        "battery.nix"
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
        "docker.nix"
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
      ];
      shared_args = {
        userModPaths = builtins.map
          (moduleName: "${self.outPath}/user-config/${moduleName}");
      };
    in {
      nixosConfigurations = {
        mini = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = shared_modules
            ++ systemModPaths (system_modules ++ [ "jellyfin.nix" ]) ++ [
              apple-silicon.nixosModules.default
              ./machines/mini/machine-config.nix
              ./machines/mini/hardware-configuration.nix
              {
                home-manager.extraSpecialArgs = {
                  catppuccin-hm = catppuccin.homeManagerModules.catppuccin;
                };
              }
            ];
          specialArgs = shared_args;
        };
        XPS = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = shared_modules
            ++ systemModPaths (system_modules ++ [ "ayden_vpn.nix" "sbuk.nix" ])
            ++ [
              ./machines/XPS/machine-config.nix
              ./machines/XPS/hardware-configuration.nix
              nixos-hardware.nixosModules.dell-xps-15-7590
              {
                home-manager.extraSpecialArgs = {
                  catppuccin-hm = catppuccin.homeManagerModules.catppuccin;
                };
              }
            ];
          specialArgs = shared_args;
        };
        Goshawk = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = shared_modules ++ systemModPaths [
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
            "docker.nix"
            "boot.nix"
            "printing.nix"
            "file_manager.nix"
            "nix-index-database.nix"
            "sops.nix"
            "hyprland.nix"
            "bluetooth.nix"
            "devenv.nix"
          ] ++ [
            ./machines/Goshawk/machine-config.nix
            ./machines/Goshawk/hardware-configuration.nix
            {
              home-manager.extraSpecialArgs = {
                catppuccin-hm = catppuccin.homeManagerModules.catppuccin;
              };
            }
          ];
          specialArgs = shared_args;
        };
        pi = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = shared_modules ++ [
            ./machines/pi/machine-config.nix
            ./machines/pi/hardware-configuration.nix
          ];
          specialArgs = shared_args;
        };
      };
    };
}

