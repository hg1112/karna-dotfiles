#!/usr/bin/env bash

set -e

# --- Configuration ---
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# --- Utilities ---
info() { printf "\033[34;1m[INFO]\033[0m %s\n" "$1"; }
warn() { printf "\033[33;1m[WARN]\033[0m %s\n" "$1"; }
error() { printf "\033[31;1m[ERROR]\033[0m %s\n" "$1"; exit 1; }

# --- System Dependencies (Debian) ---
install_dependencies() {
    info "Installing system dependencies..."
    sudo apt-get update
    sudo apt-get install -y \
        curl \
        git \
        build-essential \
        unzip \
        ripgrep \
        fd-find \
        python3 \
        python3-venv \
        npm \
        wget
}

# --- Neovim Installation ---
install_neovim() {
    if command -v nvim >/dev/null && [[ "$(nvim --version | head -n 1)" == *"v0.1"* ]]; then
        info "Neovim is already installed and modern enough."
        return
    fi

    info "Installing Neovim (latest stable) to /opt/nvim..."
    wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo mkdir -p /opt/nvim
    sudo tar -xzf nvim-linux-x86_64.tar.gz -C /opt/nvim --strip-components=1
    rm nvim-linux-x86_64.tar.gz
    
    # Ensure it's in the PATH (user might need to restart shell or we add it to .bashrc)
    if [[ ":$PATH:" != *":/opt/nvim/bin:"* ]]; then
        warn "/opt/nvim/bin is not in your PATH. Adding it to .bashrc in the next step."
    fi
}

# --- Oh-My-Bash Installation ---
install_oh_my_bash() {
    if [ ! -d "$HOME/.oh-my-bash" ]; then
        info "Installing Oh-My-Bash..."
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
    else
        info "Oh-My-Bash is already installed."
    fi

    # Copy the custom 'rana' theme
    info "Setting up 'rana' theme..."
    mkdir -p "$HOME/.oh-my-bash/themes/rana"
    cp -r "$DOTFILES_DIR/bash/themes/rana/"* "$HOME/.oh-my-bash/themes/rana/"
}

# --- Symlinking Configs ---
setup_configs() {
    info "Backing up and symlinking configurations..."
    mkdir -p "$BACKUP_DIR"

    # Neovim
    if [ -d "$HOME/.config/nvim" ]; then
        mv "$HOME/.config/nvim" "$BACKUP_DIR/nvim"
    fi
    mkdir -p "$HOME/.config"
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Bash
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$BACKUP_DIR/.bashrc"
    fi
    ln -sf "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

    if [ -f "$HOME/.profile" ]; then
        cp "$HOME/.profile" "$BACKUP_DIR/.profile"
    fi
    ln -sf "$DOTFILES_DIR/bash/.profile" "$HOME/.profile"

    # Git
    if [ -f "$HOME/.gitconfig" ]; then
        cp "$HOME/.gitconfig" "$BACKUP_DIR/.gitconfig"
    fi
    ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
}

# --- Main ---
main() {
    install_dependencies
    install_neovim
    install_oh_my_bash
    setup_configs
    
    info "Installation complete! Please restart your terminal."
}

main "$@"
