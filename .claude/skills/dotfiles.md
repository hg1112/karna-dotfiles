---
name: dotfiles
description: Skill for maintaining and extending the karna-dotfiles developer environment setup
triggers:
  - "add to dotfiles"
  - "update install.sh"
  - "add tool to setup"
  - "new path profile"
  - "add to i3"
  - "configure monitor"
---

# karna-dotfiles Skill

## Repo
`/home/karna/Desktop/karna-dotfiles/` — symlinked into home via `install.sh`.
Always edit files in the repo; symlinks make changes live immediately.

## Architecture

```
karna-dotfiles/
├── install.sh              # Single provisioning script
├── gitconfig               # Git user config
├── mise.toml               # Mise-managed tool versions (go, node, neovim, lazygit, java)
├── bash/
│   ├── .bashrc             # Interactive shell (oh-my-bash, aliases, editor)
│   ├── .profile            # Login shell (PATH bootstrap, sources .bashrc)
│   ├── paths.sh            # Loads paths/*.sh in order; symlinked to ~/.config/karna/paths.sh
│   └── paths/              # One file per tool — nvim, go, rust, mise, java, cuda, conda, idea
├── i3/
│   ├── config              # i3 WM config; symlinked to ~/.config/i3/config
│   └── i3status.conf       # Status bar; symlinked to ~/.config/i3status/config
├── nvim/                   # Neovim config; symlinked to ~/.config/nvim/
│   ├── init.lua
│   └── lua/
│       ├── kickstart/      # Base kickstart modules
│       └── custom/plugins/ # User plugins (18 total)
└── scripts/
    ├── monitor-setup.sh    # Rofi menu → xrandr; symlinked to ~/.local/bin/monitor-setup
    ├── display-hotplug.sh  # udev → X user session bridge; copied to /usr/local/bin/
    └── 99-display-hotplug.rules  # udev rule; copied to /etc/udev/rules.d/
```

## Key Rules

### Adding a new CLI tool
1. Add apt package to `install_dependencies()` pkgs array in `install.sh`
2. If it needs PATH: create `bash/paths/<tool>.sh` and add name to the loop in `bash/paths.sh`
3. If it has a config dir: add symlink block to `setup_configs()` in `install.sh` with backup guard

### PATH files pattern
Each file in `bash/paths/` is standalone and idempotent:
```bash
# bash/paths/mytool.sh
export PATH="$PATH:$HOME/.local/bin/mytool"
```
`paths.sh` loads them via `BASH_SOURCE` + `readlink -f` so symlinks resolve correctly regardless of repo location.

### install.sh patterns
```bash
# Install function
install_mytool() {
    info "Installing mytool..."
    if command -v mytool >/dev/null 2>&1; then
        info "mytool already installed."; return
    fi
    sudo apt-get install -y mytool
}

# Symlink in setup_configs() with backup guard
if [ -d "$HOME/.config/mytool" ] && [ ! -L "$HOME/.config/mytool" ]; then
    mv "$HOME/.config/mytool" "$BACKUP_DIR/mytool"
fi
ln -sf "$DOTFILES_DIR/mytool" "$HOME/.config/mytool"

# Add to main() after install_dependencies
```

### i3 config rules
- Mod key: `$mod` = Super (Win key)
- Terminal: `$term` = `x-terminal-emulator` (controlled via `update-alternatives`)
- Never hardcode paths — `exec` lines are shell-expanded so `$HOME` works
- Workspaces 1–5 → eDP (laptop), 6–10 → HDMI-A-0 (external)
- Float rules use `window_role`/`window_type` not class when possible
- Reload config: `$mod+Shift+C` (no logout needed)

### Monitor setup
- `scripts/monitor-setup.sh` — shows rofi menu when HDMI-A-0 is connected; silent laptop-only otherwise
- Display names: internal=`eDP`, external=`HDMI-A-0`
- Called on i3 start: `exec --no-startup-id monitor-setup`
- Called on hotplug: udev rule → `display-hotplug.sh` (bridges root→user X session)

## Tool Stack

| Layer | Tool | Managed by |
|---|---|---|
| Shell | Bash + Oh-My-Bash (rana theme) | dotfiles symlink |
| Terminal | Kitty | `~/.local/kitty.app`, alternatives |
| WM | i3 | dotfiles symlink |
| Editor | Neovim | mise |
| Versions | Mise | `~/.local/bin/mise` |
| Languages | Go, Node, Java (mise) + Rust (rustup) + Python (conda dev env) | paths/*.sh |
| GPU | CUDA (auto-detected) | cuda.sh |
| IDE | IntelliJ IDEA (auto-detects newest `/opt/idea-IU-*`) | idea.sh |
| AI in nvim | CodeCompanion (Anthropic + Gemini) | `ANTHROPIC_API_KEY`, `GEMINI_API_KEY` env vars |

## Neovim Custom Plugins
Located in `nvim/lua/custom/plugins/`:
- `codecompanion.lua` — Claude/Gemini AI chat (`<leader>ac/ai/aa`)
- `lazygit.lua` — Git UI (`<leader>gg/gf`)
- `toggleterm.lua` — Embedded terminals (`<C-\>`, `<leader>tf/tv/th/tt`)
- `kulala.lua` — HTTP client for `.http` files (`<leader>hs/ha/...`)
- `diagrams.lua` — Mermaid diagrams via Kitty image protocol
- `orgmode.lua` — Org-mode task/note management (`<leader>oa/oc`)
- `overseer.lua` — Task runner (`<leader>tr/tt/tl`)
- `render-markdown.lua` — Rendered markdown in normal mode
- `dashboard.lua` — Custom startup screen

## Applying Changes
- **Config change**: edit file in repo → live immediately (symlinked)
- **New tool**: edit `install.sh` → run manually or wait for next fresh install
- **PATH change**: edit `bash/paths/<tool>.sh` → `source ~/.bashrc` or re-login
- **i3 change**: edit `i3/config` → `$mod+Shift+C` to reload
- **Monitor**: run `monitor-setup` from terminal or re-login to i3
