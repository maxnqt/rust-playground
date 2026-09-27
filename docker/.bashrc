# Appended to /home/dev/.bashrc in the dev container (see Dockerfile).
# Not meant to be run directly.

# ---- rust-playground shell setup ----------------------------------------

# History: large, deduplicated, and saved after every command.
# Stored in a volume, so it survives `make stop` / `make dev`.
export HISTFILE="$HOME/.history/bash_history"
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Tab completion (make targets, cargo, rustup, git)
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# Colors
alias ls='ls --color=auto'
alias grep='grep --color=auto'
export CARGO_TERM_COLOR=always

# Navigation
alias ll='ls -lah'
alias ..='cd ..'
alias ws='cd /workspace'
alias ex='cd /workspace/examples'

# Cargo shortcuts
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
alias ck='cargo check'
alias cl='cargo clippy --all-targets'

# Prompt (keep this last)
eval "$(starship init bash)"
