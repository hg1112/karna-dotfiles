# karna-dotfiles

Personal dotfiles for Neovim and Bash, optimized for Debian.

## Components

- **Neovim**: Custom config based on Kickstart.nvim.
- **Bash**: Oh-My-Bash with the `rana` theme and custom aliases/paths.

## Installation

To install these dotfiles on a fresh Debian system:

```bash
git clone https://github.com/YOUR_USERNAME/karna-dotfiles.git ~/karna-dotfiles
cd ~/karna-dotfiles
chmod +x install.sh
./install.sh
```

The script will:
1. Install system dependencies (`curl`, `git`, `ripgrep`, etc.).
2. Install Neovim (latest stable) to `/opt/nvim`.
3. Install Oh-My-Bash.
4. Back up your existing configs to `~/.dotfiles_backup`.
5. Symlink the new configurations.

## Requirements

- Debian-based system (Ubuntu, Kali, etc.)
- `sudo` privileges
