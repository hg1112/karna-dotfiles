# ~/.profile: executed by Bourne-compatible login shells.

# Mise shims — must come before the bashrc guard so non-interactive shells get go/node/etc.
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi
. "$HOME/.cargo/env"
