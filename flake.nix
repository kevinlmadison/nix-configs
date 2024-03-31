{
  description = "Kevin's NixOS Flake";

  inputs = {
    # Nix Packages
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Hardware Modules
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixos-hardware.url = "github:kevinlmadison/nixos-hardware/master";

    # Nix Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    # nix-darwin.url = "github:kevinlmadison/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Nix Vim
    # nixvim.url = "github:nix-community/nixvim/9f7c78852f37126244b43e71e5158cdc3d70ad0a";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "github:kevinlmadison/neovim-flake";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    nix-darwin,
    # nixvim,
    neovim-flake,
    ...
  } @ inputs: {
    darwinConfigurations = {
      "m3" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/m3/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.kelevra = import ./home;
          }
        ];
      };
    };
    darwinPackages = self.darwinConfigurations."m3".pkgs;

    images = {
      rpi = self.nixosConfigurations.rpi.config.system.build.sdImage;
    };

    nixosConfigurations = {
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

      "vader" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/vader/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.kelevra = import ./home;
          }
          nixos-hardware.nixosModules.msi-b350-tomahawk
        ];
      };

      "thinkpad" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/thinkpad/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.kelevra = import ./home;
          }
          nixos-hardware.nixosModules.lenovo-thinkpad-x220
        ];
      };

      "xps" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/xps/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.kelevra = import ./home;
          }
          #j-link.nixosModule
          nixos-hardware.nixosModules.dell-xps-13-9360
        ];
      };
    };
  };
}
