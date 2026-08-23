# Sourced by every zsh invocation (login, interactive, and scripts),
# unlike .zshrc which only interactive shells read.

# rustup's PATH hook — prepends ~/.cargo/bin if not already present
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
