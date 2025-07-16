{
  description = "Kevin's NixOS Flake";

  inputs = {
    # Some cool flake utils for smooth configuration
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";

    # Nix Packages
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Hardware Modules
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nix Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Vim
    nixvim.url = "github:nix-community/nixvim/9f7c78852f37126244b43e71e5158cdc3d70ad0a";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # Peronal Neovim Flake
    neovim-flake.url = "github:kevinlmadison/neovim-flake";

    # # Dylan **loves** candy
    # hyprland.url = "github:hyprwm/Hyprland/v0.47.1";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs";
    # hyprland.inputs.systems.follows = "systems";

    # At this point I'm stuck with Miryoku
    # kmonad.url = "github:kmonad/kmonad?dir=nix";
    # kmonad.inputs.nixpkgs.follows = "nixpkgs";

    # # Com'on rust
    # rust-overlay.url = "github:oxalica/rust-overlay";
    # rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nix-darwin,
    neovim-flake,
    # kmonad,
    ...
  } @ inputs: let
    username = "kelevra";
    stateVersion = "24.05";
    home-modules = {
      home-manager.backupFileExtension = "bak";
      home-manager.useGlobalPkgs = false;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs username stateVersion;};
      home-manager.users.kelevra = import ./home;
    };
    allowUnfree = {
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = pkg: true;
      };
    };
  in {
    darwinConfigurations = {
      "m3" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/m3/default.nix
          home-manager.darwinModules.home-manager
          home-modules
          allowUnfree
          # ({pkgs, ...}: {
          #   nixpkgs.overlays = [inputs.rust-overlay.overlays.default];
          #   environment.systemPackages = [pkgs.rust-bin.stable.latest.default];
          # })
        ];
      };
    };

    nixosConfigurations = {
      "vader" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/vader/default.nix
          home-manager.nixosModules.home-manager
          home-modules
          nixos-hardware.nixosModules.msi-b350-tomahawk
        ];
      };

      "thinkpad" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/thinkpad/default.nix
          home-manager.nixosModules.home-manager
          home-modules
          nixos-hardware.nixosModules.lenovo-thinkpad-x220
        ];
      };

      "xps" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/xps/default.nix
          home-manager.nixosModules.home-manager
          home-modules
          #j-link.nixosModule
          nixos-hardware.nixosModules.dell-xps-13-9360
        ];
      };

      images = {
        rpi = self.nixosConfigurations.rpi.config.system.build.sdImage;
      };

      # nix build .#nixosConfigurations.rpi.config.system.build.sdImage
      "rpi" = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/rpi
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.kelevra = import ./home/rpi;
          }
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          {
            config = {
              system = {
                stateVersion = "23.11";
              };
            };
          }
        ];
      };
    };
  };
}
