# karna-dotfiles

Personal dotfiles for Neovim and Bash, supporting Debian-based systems including **Pop!_OS with NVIDIA GPUs**.

## Components

- **Neovim**: Custom config based on Kickstart.nvim.
- **Bash**: Oh-My-Bash with the `rana` theme and custom aliases/paths.

## Installation

```bash
git clone https://github.com/YOUR_USERNAME/karna-dotfiles.git ~/karna-dotfiles
cd ~/karna-dotfiles
chmod +x install.sh
./install.sh
```

The script will:
1. Detect your OS and architecture (x86\_64 / arm64) and whether NVIDIA drivers are present.
2. Install system dependencies (`curl`, `git`, `ripgrep`, etc.).
   - On Pop!\_OS: also installs `nvtop` for GPU monitoring.
3. Install Neovim (latest stable, ≥ 0.10) to `/opt/nvim`.
4. Install Oh-My-Bash.
5. Back up your existing configs to `~/.dotfiles_backup`.
6. Symlink the new configurations.

## NVIDIA / CUDA

`~/.bashrc` automatically adds CUDA to `PATH` and `LD_LIBRARY_PATH` when `/usr/local/cuda` (or a versioned `/usr/local/cuda-X.Y`) is present.

Useful aliases added by default:

| Alias | Command |
|-------|---------|
| `gpu` | `watch -n1 nvidia-smi` |
| `gpustat` | one-line GPU utilisation summary |

## Requirements

- Debian-based system (Ubuntu, Pop!\_OS, Kali, etc.)
- `sudo` privileges
