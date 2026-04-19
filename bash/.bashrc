# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Only set TERM to wezterm when actually running inside WezTerm
if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
  export TERM=wezterm
fi

# Path to your oh-my-bash installation.
export OSH="$HOME/.oh-my-bash"
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

# ── Paths & Tools ─────────────────────────────────────────────────────────────
[ -f "$HOME/.config/karna/paths.sh" ] && . "$HOME/.config/karna/paths.sh"

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'

# ── GPU aliases ───────────────────────────────────────────────────────────────
alias gpu='watch -n1 nvidia-smi'
alias gpustat='nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,utilization.memory,memory.used,memory.total --format=csv,noheader,nounits'

# ── Music Setup ───────────────────────────────────────────────────────────────
if [ -f "$HOME/Desktop/karna-dotfiles/bash/music.sh" ]; then
    source "$HOME/Desktop/karna-dotfiles/bash/music.sh"
fi
