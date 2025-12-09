#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

wez_src="$repo_dir/.wezterm.lua"
motd_src="$repo_dir/.motd.sh"

wez_dst="$HOME/.wezterm.lua"
motd_dst="$HOME/.motd.sh"
zshrc="$HOME/.zshrc"

echo "Deploying WezTerm config..."
cp "$wez_src" "$wez_dst"

echo "Deploying MOTD script..."
cp "$motd_src" "$motd_dst"
chmod +x "$motd_dst"

motd_marker="# synthwave MOTD"
motd_line='[[ $- == *i* ]] && [[ -x ~/.motd.sh ]] && ~/.motd.sh'
[ -f "$zshrc" ] || touch "$zshrc"
if ! grep -Fq "$motd_line" "$zshrc"; then
  {
    echo ""
    echo "$motd_marker"
    echo "$motd_line"
  } >> "$zshrc"
  echo "Added MOTD line to $zshrc"
else
  echo "MOTD line already present in $zshrc"
fi

echo "Done. Restart your shell or 'source ~/.zshrc' to load the MOTD."
