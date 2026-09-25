#!/usr/bin/env bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

echo "==> Installing Hyprland dotfiles"
echo

# --------------------------------------------------
# Official Arch packages
# --------------------------------------------------

PACKAGES=(
    # Window manager / desktop
    hyprland
    waybar
    rofi-wayland
    kitty

    # Terminal / editor / system info
    neovim
    fastfetch
    btop
    cava

    # Notifications / OSD
    mako
    swayosd

    # Wallpaper / screenshots / clipboard
    swww
    grim
    slurp
    wl-clipboard

    # Authentication / desktop integration
    polkit-kde-agent

    # Brightness / media
    brightnessctl
    playerctl

    # Network / Bluetooth
    networkmanager
    network-manager-applet
    blueman

    # File manager
    dolphin

    # Fonts
    ttf-jetbrains-mono-nerd
)

echo "==> Installing required packages..."
sudo pacman -S --needed "${PACKAGES[@]}"

# --------------------------------------------------
# Create config directory
# --------------------------------------------------

echo "==> Creating ~/.config..."
mkdir -p "$CONFIG"

# --------------------------------------------------
# Backup existing configurations
# --------------------------------------------------

BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

CONFIGS=(
    fastfetch
    hypr
    kitty
    nvim
    rofi
    swayosd
    waybar
)

BACKUP_NEEDED=false

for config in "${CONFIGS[@]}"; do
    if [ -e "$CONFIG/$config" ] || [ -L "$CONFIG/$config" ]; then
        BACKUP_NEEDED=true
        break
    fi
done

if [ "$BACKUP_NEEDED" = true ]; then
    echo "==> Existing configs found."
    echo "==> Creating backup at:"
    echo "    $BACKUP"

    mkdir -p "$BACKUP"

    for config in "${CONFIGS[@]}"; do
        if [ -e "$CONFIG/$config" ] || [ -L "$CONFIG/$config" ]; then
            echo "    Backing up $config"
            mv "$CONFIG/$config" "$BACKUP/"
        fi
    done
fi

# --------------------------------------------------
# Install dotfiles using symlinks
# --------------------------------------------------

echo
echo "==> Linking dotfiles..."

for config in "${CONFIGS[@]}"; do
    if [ -d "$DOTFILES/$config" ] || [ -f "$DOTFILES/$config" ]; then
        echo "    $config"
        ln -s "$DOTFILES/$config" "$CONFIG/$config"
    else
        echo "    WARNING: $config not found in repository"
    fi
done

# --------------------------------------------------
# Enable useful services
# --------------------------------------------------

echo
echo "==> Enabling NetworkManager..."

sudo systemctl enable --now NetworkManager

echo
echo "=========================================="
echo " Hyprland dotfiles installed successfully"
echo "=========================================="
echo

if [ "$BACKUP_NEEDED" = true ]; then
    echo "Previous configs were backed up to:"
    echo "$BACKUP"
    echo
fi

echo "Installed configs:"
for config in "${CONFIGS[@]}"; do
    echo "  ✓ $config"
done

echo
echo "You can now start Hyprland."