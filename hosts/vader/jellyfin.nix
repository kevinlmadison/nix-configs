{ pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "kelevra";
  };
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    transmission-gtk
  ];
}
