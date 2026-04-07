export TERM=wezterm
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Path to your oh-my-bash installation.
export OSH='/home/karna/.oh-my-bash'
OSH_THEME="rana"
OMB_USE_SUDO=true
OMB_PROMPT_SHOW_PYTHON_VENV=true
completions=(git composer ssh)
aliases=(general)
plugins=(git bashmarks)

# Load Oh My Bash
if [ -f "$OSH/oh-my-bash.sh" ]; then
  source "$OSH/oh-my-bash.sh"
fi

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$PATH:/opt/nvim/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# mise (conditional activation)
if [ -x "/home/karna/.local/bin/mise" ]; then
  eval "$(/home/karna/.local/bin/mise activate bash)"
fi

# ── Conda / Miniconda ─────────────────────────────────────────────────────────
if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/opt/miniconda3/etc/profile.d/conda.sh"
    conda activate dev 2>/dev/null || true
fi

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'
