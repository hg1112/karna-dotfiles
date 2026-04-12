#!/usr/bin/env bash

set -e

# --- Configuration ---
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# --- Utilities ---
info() { printf "\033[34;1m[INFO]\033[0m %s\n" "$1"; }
warn() { printf "\033[33;1m[WARN]\033[0m %s\n" "$1"; }
error() { printf "\033[31;1m[ERROR]\033[0m %s\n" "$1"; exit 1; }

# --- Detect OS & architecture ---
detect_env() {
    ARCH="$(uname -m)"
    OS_ID=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_ID="${ID:-}"
    fi
    IS_POPOS=false
    [[ "$OS_ID" == "pop" ]] && IS_POPOS=true
    HAS_NVIDIA=false
    command -v nvidia-smi >/dev/null 2>&1 && HAS_NVIDIA=true
    info "Detected: OS=${OS_ID} ARCH=${ARCH} PopOS=${IS_POPOS} NVIDIA=${HAS_NVIDIA}"
}

# --- System Dependencies ---
install_dependencies() {
    info "Installing system dependencies..."
    sudo apt-get update

    local pkgs=(
        "curl" "git" "build-essential" "unzip"
        "ripgrep" "fd-find"
        "python3" "python3-venv" "python3-dev" "python3-pip"
        "wget" "ca-certificates"
        "luarocks" "lua5.1" "liblua5.1-dev"
        "imagemagick"
        "ffmpeg" "cmus" "yt-dlp" "mpv"
    )

    # Monitoring tools
    pkgs+=("btop" "htop" "nvtop" "xfce4-taskmanager" "xfce4-cpugraph-plugin" "xfce4-diskperf-plugin" "xfce4-netload-plugin" "xfce4-sensors-plugin" "xfce4-systemload-plugin")

    sudo apt-get install -y "${pkgs[@]}"

    # Symlink fdfind -> fd if on Debian/Ubuntu
    if command -v fdfind >/dev/null && ! command -v fd >/dev/null; then
        sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
    fi
}

# --- Install Utilities ---
install_utilities() {
    info "Installing utility scripts..."
    sudo cp "$DOTFILES_DIR/scripts/kb-layout.sh" /usr/local/bin/kb-layout
    sudo chmod +x /usr/local/bin/kb-layout
}

# --- Mise Installation ---
install_mise() {
    if command -v mise >/dev/null 2>&1; then
        info "mise $(mise --version) is already installed."
        return
    fi

    info "Installing mise..."
    curl -fsSL https://mise.run | sh
}

# --- Mise-managed Tools (go, node, neovim, lazygit) ---
install_mise_tools() {
    # Activate mise for this script session
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(mise activate bash --shims)"

    info "Installing mise tools from mise.toml..."
    mise install --yes

    # npm globals needed by neovim plugins
    info "Installing npm global packages..."
    mise exec node -- npm install -g neovim tree-sitter-cli @mermaid-js/mermaid-cli
}

# --- Go Tools (gopls, gofumpt) ---
install_go_tools() {
    info "Installing Go tools (gopls, gofumpt)..."
    mise exec go -- go install golang.org/x/tools/gopls@latest
    mise exec go -- go install mvdan.cc/gofumpt@latest
}

# --- Oh-My-Bash Installation ---
install_oh_my_bash() {
    if [ ! -d "$HOME/.oh-my-bash" ]; then
        info "Installing Oh-My-Bash..."
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
    else
        info "Oh-My-Bash is already installed."
    fi

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

    # Mise global config
    mkdir -p "$HOME/.config/mise"
    if [ -f "$HOME/.config/mise/config.toml" ]; then
        cp "$HOME/.config/mise/config.toml" "$BACKUP_DIR/mise-config.toml"
    fi
    ln -sf "$DOTFILES_DIR/mise.toml" "$HOME/.config/mise/config.toml"

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
    if [ "$(id -u)" -eq 0 ] && [ -z "$SUDO_USER" ]; then
        error "Do not run this script as root. Run as your normal user — sudo is used internally where needed."
    fi

    detect_env
    install_dependencies
    install_utilities
    install_mise
    setup_configs
    install_mise_tools
    install_go_tools
    install_oh_my_bash

    info "Installation complete! Please restart your terminal."
}

main "$@"
