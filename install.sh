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
        "libspa-0.2-bluetooth"
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
#install_utilities() {
    #info "Installing utility scripts..."
    #sudo cp "$DOTFILES_DIR/scripts/kb-layout.sh" /usr/local/bin/kb-layout
    #sudo chmod +x /usr/local/bin/kb-layout
#}

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

# --- Kitty Terminal ---
install_kitty() {
    info "Installing kitty terminal..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

    # Symlink into PATH
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
    ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"

    # Desktop entry
    cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
    sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
        "$HOME/.local/share/applications/kitty.desktop"

    # Set as default terminal emulator
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator \
        "$HOME/.local/kitty.app/bin/kitty" 50
    sudo update-alternatives --set x-terminal-emulator "$HOME/.local/kitty.app/bin/kitty"

    info "kitty installed and set as default terminal."
}

# --- i3lock-color ---
install_i3lock_color() {
    if command -v i3lock-color >/dev/null 2>&1; then
        info "i3lock-color already installed."; return
    fi

    info "Installing i3lock-color build dependencies..."
    sudo apt-get install -y autoconf gcc make pkg-config \
        libpam0g-dev libcairo2-dev libfontconfig1-dev \
        libxcb-composite0-dev libev-dev libx11-xcb-dev \
        libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev \
        libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev \
        libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev

    info "Building i3lock-color..."
    local tmp
    tmp="$(mktemp -d)"
    git clone https://github.com/Raymo111/i3lock-color "$tmp/i3lock-color"
    cd "$tmp/i3lock-color"
    ./install-i3lock-color.sh
    cd - > /dev/null
    rm -rf "$tmp"
    info "i3lock-color installed."
}

# --- i3 Window Manager ---
install_i3() {
    info "Installing i3 and companion tools..."

    local pkgs=(
        "i3-wm" "i3status" "rofi" "picom" "dunst"
        "feh" "xss-lock" "i3lock" "network-manager-gnome" "xfce4-screenshooter"
        "arandr"
    )
    sudo apt-get install -y "${pkgs[@]}"

    if [ ! -f /usr/share/xsessions/i3.desktop ]; then
        info "Creating /usr/share/xsessions/i3.desktop..."
        sudo tee /usr/share/xsessions/i3.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=i3
Comment=Improved tiling window manager
Exec=i3
TryExec=i3
Type=Application
X-LightDM-DesktopName=i3
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;
EOF
    fi

    info "i3 installation complete."
}

# --- Zed Editor ---
install_zed() {
    if command -v zed >/dev/null 2>&1; then
        info "Zed is already installed."; return
    fi

    info "Installing Zed editor..."
    curl -f https://zed.dev/install.sh | sh
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

    # Paths
    mkdir -p "$HOME/.config/karna"
    ln -sf "$DOTFILES_DIR/bash/paths.sh" "$HOME/.config/karna/paths.sh"

    # i3
    if [ -d "$HOME/.config/i3" ] && [ ! -L "$HOME/.config/i3" ]; then
        mv "$HOME/.config/i3" "$BACKUP_DIR/i3"
    fi
    ln -sf "$DOTFILES_DIR/i3" "$HOME/.config/i3"

    # i3status
    mkdir -p "$HOME/.config/i3status"
    if [ -f "$HOME/.config/i3status/config" ] && [ ! -L "$HOME/.config/i3status/config" ]; then
        cp "$HOME/.config/i3status/config" "$BACKUP_DIR/i3status-config"
    fi
    ln -sf "$DOTFILES_DIR/i3/i3status.conf" "$HOME/.config/i3status/config"

    # WirePlumber (auto-switch to G435 when USB receiver plugged in)
    mkdir -p "$HOME/.config/wireplumber/main.lua.d"
    ln -sf "$DOTFILES_DIR/wireplumber/main.lua.d/51-g435-priority.lua" \
        "$HOME/.config/wireplumber/main.lua.d/51-g435-priority.lua"

    # Scripts
    mkdir -p "$HOME/.local/bin"
    chmod +x "$DOTFILES_DIR/scripts/monitor-setup.sh"
    chmod +x "$DOTFILES_DIR/scripts/display-hotplug.sh"
    chmod +x "$DOTFILES_DIR/scripts/lock.sh"
    ln -sf "$DOTFILES_DIR/scripts/monitor-setup.sh" "$HOME/.local/bin/monitor-setup"
    ln -sf "$DOTFILES_DIR/scripts/lock.sh" "$HOME/.local/bin/lock"
    sudo cp "$DOTFILES_DIR/scripts/display-hotplug.sh" /usr/local/bin/display-hotplug
    sudo chmod +x /usr/local/bin/display-hotplug
    sudo cp "$DOTFILES_DIR/scripts/99-display-hotplug.rules" /etc/udev/rules.d/99-display-hotplug.rules
    sudo udevadm control --reload-rules
}

# --- Main ---
main() {
    if [ "$(id -u)" -eq 0 ] && [ -z "$SUDO_USER" ]; then
        error "Do not run this script as root. Run as your normal user — sudo is used internally where needed."
    fi

    detect_env
    install_dependencies
    install_i3lock_color
    install_i3
    #install_utilities
    install_mise
    setup_configs
    systemctl --user restart wireplumber 2>/dev/null || true
    install_mise_tools
    install_go_tools
    install_oh_my_bash
    install_kitty
    install_zed

    info "Installation complete! Please restart your terminal."
}

main "$@"
