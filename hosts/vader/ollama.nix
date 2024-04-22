{pkgs, ...}: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  users.groups.ollama = {};
  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    # extraGroups = ["ollama"];
    home = "/home/ollama";
    shell = "/bin/false";
  };

  environment.systemPackages = with pkgs; [ollama];
}
