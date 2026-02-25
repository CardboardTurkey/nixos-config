{
  description = "You're nixed son";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    hyprland.url = "github:hyprwm/Hyprland/v0.52.1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    catppuccin.url = "github:catppuccin/nix";
    catppuccin-vsc.url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      nix-index-database,
      apple-silicon,
      hyprland,
      hyprland-plugins,
      catppuccin,
      catppuccin-vsc,
      sops-nix,
    }:
    let
      shared_modules = hm: [
        ./configuration.nix
        nix-index-database.nixosModules.nix-index
        catppuccin.nixosModules.catppuccin
        hm.nixosModules.home-manager
        sops-nix.nixosModules.sops
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
        "containers.nix"
        "boot.nix"
        "printing.nix"
        "file_manager.nix"
        "fwupd.nix"
        "yubikey.nix"
        "qmk.nix"
        "flatpak.nix"
        "upower.nix"
        "nix-index-database.nix"
        "sops.nix"
        "hyprland.nix"
        # "cachix.nix"
        "bluetooth.nix"
        "gnupg.nix"
        "devenv.nix"
        "trash.nix"
        "system_channel.nix"
        "usbip.nix"
        "xdg.nix"
        "localsend.nix"
      ];
      sharedArgs = {
        userModPaths = builtins.map (moduleName: "${self.outPath}/user-config/${moduleName}");
        inputs = { inherit sops-nix hyprland; };
      };
      hmSharedArgs = {
        catppuccin-hm = catppuccin.homeModules.catppuccin;
        inherit
          hyprland-plugins
          ;
      };
    in
    {
      homeConfigurations."kiran-dev-machine" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./machines/kiran-dev-machine/home.nix ];
        extraSpecialArgs = {
          osConfig = {
            emulator = "kitty";
            fontSizeSmall = 12.0;
            fontSizeMedium = 15.0;
            fontSizeLargs = 19.0;
            pgp_sign = "8BC774E4A2EC75073B61A6470BBB1C8B1C3639EE";
            flavour = "frappe";
            accent = "teal";
          };
          userModPaths = sharedArgs.userModPaths;
          catppuccin-hm = catppuccin.homeModules.catppuccin;
        };
      };
      nixosConfigurations = {
        Osprey = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules =
            shared_modules home-manager
            ++ systemModPaths (
              system_modules
              ++ [
                "logiops.nix"
                "usbip_host.nix"
                "sbuk.nix"
                "office_vpn.nix"
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
          modules = [
            {
              nix.settings = {
                substituters = [ "https://hyprland.cachix.org" ];
                trusted-substituters = [ "https://hyprland.cachix.org" ];
                trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
              };
            }
          ]
          ++ shared_modules home-manager
          ++ systemModPaths (
            system_modules
            ++ [
              "atuin.nix"
              "ayden_vpn.nix"
              "battery.nix"
              "jellyfin.nix"
              "hedgedoc.nix"
              "sbuk.nix"
              "data.nix"
              "rabbit.nix"
              "vaultwarden.nix"
              "gatus.nix"
              "chatbot.nix"
              "homepage.nix"
              "pocket-id.nix"
              "paperless.nix"
              "beszel.nix"
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
                "sbuk.nix"
                "usbip_host.nix"
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
