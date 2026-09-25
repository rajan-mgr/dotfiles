#!/usr/bin/env bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

echo "==> Installing Hyprland dotfiles"

# Required packages
PACKAGES=(
    hyprland
    kitty
    waybar
    rofi-wayland
    neovim
    fastfetch
    swayosd
)

echo "==> Installing packages..."

sudo pacman -S --needed "${PACKAGES[@]}"

echo "==> Creating config directory..."
mkdir -p "$CONFIG"

# Backup existing configs
BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"

CONFIGS=(
    fastfetch
    hypr
    kitty
    nvim
    rofi
    swayosd
    waybar
)

for config in "${CONFIGS[@]}"; do
    if [ -e "$CONFIG/$config" ] || [ -L "$CONFIG/$config" ]; then
        echo "==> Backing up $config"
        mv "$CONFIG/$config" "$BACKUP/"
    fi
done

# Create symlinks
for config in "${CONFIGS[@]}"; do
    echo "==> Installing $config"
    ln -s "$DOTFILES/$config" "$CONFIG/$config"
done

echo
echo "======================================"
echo " Dotfiles installed successfully!"
echo "======================================"
echo
echo "Backup: $BACKUP"
echo
echo "Restart Hyprland to apply the configuration."
