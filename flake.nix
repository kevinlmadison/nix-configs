{
  description = "Kevin's NixOS Flake";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs: {
    darwinConfigurations = {
      "Kevins-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
	  ./hosts/m3/default.nix 
        ];
      };
    };
    darwinPackages = self.darwinConfigurations."Kevins-MacBook-Pro".pkgs;

    nixosConfigurations = {

      "thinkpad" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/thinkpad/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kelevra = import ./home;
          }
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
            home-manager.users.kelevra = import ./home;
          }
        ];
      };
    };
  };
}
