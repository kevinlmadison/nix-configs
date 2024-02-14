{ pkgs, inputs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  imports = [
      ./tailscale.nix
  ];

  environment.systemPackages = with pkgs; [ 
    neovim
    git
    fzf
    kitty
    clang
  ];

  # https://github.com/nix-community/home-manager/issues/4026
  users.users.kelevra = {
    home = "/Users/kelevra";
    name = "kelevra";
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
