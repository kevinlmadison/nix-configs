{ config, ... }:
{
  services.tailscale.enable = true;
  networking.nameservers = [ "100.100.100.100" ];
  networking.search = [ "taile7d08.ts.net" ];
}
