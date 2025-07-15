{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nushell = {
    enable = true;
    environmentVariables.EDITOR = "nvim";
    environmentVariables.KUBE_EDITOR = "nvim";
    envFile.source = ./env.nu;
    configFile.source = ./config.nu;
    # shellAliases = config.home.shellAliases; # Our shell aliases are pretty simple
    shellAliases = lib.mkDefault {
      # l = "lsd -alF";
      l = "ls";
      c = "cd";
      e = "nvim";
      k = "kubectl";
      gcm = "git commit -m";
      se = "sudoedit";
      sshdemo = "ssh -i ~/repos/platform/k8s/keys/ahq.demo admin@a.demo.analyticshq.com";
      sshdev = "ssh -i ~/repos/platform/k8s/keys/ahq.dev admin@a.dev.analyticshq.com";
      sshgov = "ssh -i ~/repos/platform/k8s/keys/ahq.gov admin@a.gov.analyticshq.com";
      update =
        if pkgs.system == "aarch64-darwin"
        then "darwin-rebuild switch --flake ~/repos/nix-configs/#m3 --impure"
        else "sudo nixos-rebuild switch --flake ~/repos/nix-configs/#$(hostname) --impure";
    };
  };
}
