# AcreetionOS Lite Zsh Config
# Lightweight version of the original AcreetionOS zshrc

# If not running interactively, don't do anything
[[ -z "$TERM" ]] && return
case "$TERM" in
    dumb) return;;
esac

# History
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Keybindings
bindkey -e
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
bindkey '^[[D' backward-char

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Prompt - matches original AcreetionOS design
PS1='${debian_chroot:+($debian_chroot)}%F{green}User%f:%F{blue} %n %F{green}Path%f: %F{blue}%~ 
%f[=--> '

# Use eza if available (modern replacement), fallback to ls
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
    alias lx='eza -l --icons --extended'
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Standard aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias update='sudo pacman -Syyu'
alias fupdate='flatpak update'
alias fastfetch='fastfetch -l /etc/AcreetionOS.txt'

# Load fastfetch on start (interactive shells only)
if [[ -o interactive ]]; then
    clear
    fastfetch -l /etc/AcreetionOS.txt
fi
