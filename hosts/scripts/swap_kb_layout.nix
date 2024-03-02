{pkgs}:

pkgs.writeShellScriptBin "zzz" ''

  file="$HOME/.config/hypr/hyprland.conf"
  search_string="kb_variant = colemak_dh_ortho"

  # Check if the file exists
  if [ ! -e "$file" ]; then
      echo "File $file not found."
      exit 1
  fi

  # Search for the line and replace it
  if grep -q "$search_string" "$file"; then
      sed -i 's/kb_variant = colemak_dh_ortho/kb_variant = #colemak_dh_ortho/g' "$file"
      echo "Line replaced: kb_variant = colemak_dh_ortho with kb_variant = #colemak_dh_ortho"
  else
      sed -i 's/kb_variant = #colemak_dh_ortho/kb_variant = colemak_dh_ortho/g' "$file"
      echo "Line replaced: kb_variant = #colemak_dh_ortho with kb_variant = colemak_dh_ortho"
  fi

''
