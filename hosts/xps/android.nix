  programs.adb.enable = true;

  boot.kernelModules = [ "kvm-amd" ];
  virtualisation.libvirtd.enable = true;

  users.users.username = {
      ....
      extraGroups = [
          ...
          "adbusers"
      ]
  }

  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_4_19.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
            sha256 = "0h02pxzzwc5w2kfqw686bpxc13a93yq449lyzxxkxq1qilcsqjv5";
      };
      version = "4.19.107";
      modDirVersion = "4.19.107";
      };
  });
