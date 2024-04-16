{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    fenix,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages.default = let
        toolchain = fenix.packages.${system}.minimal.toolchain;
        pkgs = nixpkgs.legacyPackages.${system};
        fetchFromGitHub = builtins.fetchFromGitHub;
      in
        (pkgs.makeRustPlatform {
          cargo = toolchain;
          rustc = toolchain;
        })
        .buildRustPackage rec {
          pname = "ripgrep";
          version = "12.1.1";

          src = fetchFromGitHub {
            owner = "BurntSushi";
            repo = pname;
            rev = version;
            hash = "sha256-+s5RBC3XSgb8omTbUNLywZnP6jSxZBKSS1BmXOjRF8M=";
          };

          cargoHash = "sha256-jtBw4ahSl88L0iuCXxQgZVm1EcboWRJMNtjxLVTtzts=";

          meta = {
            description = "A fast line-oriented regex search tool, similar to ag and ack";
            homepage = "https://github.com/BurntSushi/ripgrep";
            license = nixpkgs.lib.licenses.unlicense;
            maintainers = [];
          };
        };
    });
}
