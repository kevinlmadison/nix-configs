{pkgs}:

pkgs.writeShellScriptBin "k_reload" ''

  if [[ -z $(pgrep "$1") ]]; then
    pkill "$1" && "$1" &
  fi

''