#!/usr/bin/env bash
# install.sh — deploy hyprland-dotfiles into the standard XDG locations.
# Safe & idempotent: anything it would overwrite under ~/.config is backed up first.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.config/.dotfiles-backup-$STAMP"

echo "Installing hyprland-dotfiles from: $REPO"

# 1. Config directories -> ~/.config (back up any existing copy we'd replace)
mkdir -p "$HOME/.config"
for d in hypr waybar kitty wofi fastfetch; do
  if [ -e "$HOME/.config/$d" ]; then
    mkdir -p "$BACKUP"
    mv "$HOME/.config/$d" "$BACKUP/$d"
    echo "  backed up existing ~/.config/$d -> $BACKUP/$d"
  fi
  cp -r "$REPO/$d" "$HOME/.config/$d"
  echo "  installed ~/.config/$d"
done

# 2. Helper scripts -> ~/.local/bin (the configs call these by name from PATH)
mkdir -p "$HOME/.local/bin"
cp "$REPO"/bin/* "$HOME/.local/bin/"
chmod +x "$HOME"/.local/bin/* 2>/dev/null || true
echo "  installed $(ls "$REPO"/bin | wc -l) scripts -> ~/.local/bin"

# 3. Wallpapers -> ~/Pictures/wallpapers (hyprpaper/hyprlock point here)
mkdir -p "$HOME/Pictures/wallpapers"
cp "$REPO"/wallpapers/* "$HOME/Pictures/wallpapers/"
echo "  installed wallpapers -> ~/Pictures/wallpapers"

cat <<'NOTE'

Done. Next steps:
  - Ensure ~/.local/bin is on your PATH.
  - Reload Hyprland (SUPER+SHIFT+R) or start a fresh session.

Runtime dependencies (install with your package manager):
  hyprland waybar hyprlock hypridle hyprpaper kitty wofi mako
  grim slurp satty wl-clipboard jq pavucontrol pipewire(wpctl)
  playerctl btop fastfetch wttrbar
  fonts: Noto Sans Mono, Noto Color Emoji
NOTE
