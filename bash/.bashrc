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

# ── PATH ──────────────────────────────────────────────────────────────────────
export PATH="$PATH:/opt/nvim/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.local/bin"

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# mise (conditional activation)
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$($HOME/.local/bin/mise activate bash)"
fi

# ── Conda / Miniconda ─────────────────────────────────────────────────────────
if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/opt/miniconda3/etc/profile.d/conda.sh"
    conda activate dev 2>/dev/null || true
fi

# ── NVIDIA / CUDA ─────────────────────────────────────────────────────────────
# Resolve the active CUDA installation (prefers versioned symlink target)
_cuda_dir=""
if [ -d "/usr/local/cuda" ]; then
    _cuda_dir="/usr/local/cuda"
elif ls /usr/local/cuda-* 2>/dev/null | head -1 | grep -q .; then
    _cuda_dir="$(ls -d /usr/local/cuda-* 2>/dev/null | sort -V | tail -1)"
fi

if [ -n "$_cuda_dir" ]; then
    export CUDA_HOME="$_cuda_dir"
    export PATH="$PATH:$CUDA_HOME/bin"
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$CUDA_HOME/lib64"
fi
unset _cuda_dir

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR='nvim'
export VISUAL='nvim'

# ── GPU aliases ───────────────────────────────────────────────────────────────
alias gpu='watch -n1 nvidia-smi'
alias gpustat='nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,utilization.memory,memory.used,memory.total --format=csv,noheader,nounits'
