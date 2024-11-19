# Enable colors
autoload -U colors && colors
export TERM="xterm-256color"

# Enable vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' stagedstr '!'
zstyle ':vcs_info:*' unstagedstr '?'
zstyle ':vcs_info:git*' formats "%B%{$fg[red]%}{ %{$fg[blue]%}%b%{$reset_color%} %m%u%c%{$fg[red]%}%B}"

function precmd {
  vcs_info
}

function get_start_time() {
  cmd_timer=$(date +%s%3N)
}

function calc_exec_time() {
  if [ $cmd_timer ]; then
    local now=$(date +%s%3N)
    local d_ms=$(($now - $cmd_timer))
    local d_s=$((d_ms / 1000))
    local ms=$((d_ms % 1000))
    local s=$((d_s % 60))
    local m=$(((d_s / 60) % 60))
    local h=$((d_s / 3600))

    if ((h > 0)); then elapsed=${h}h${m}m
    elif ((m > 0)); then elapsed=${m}m${s}s
    elif ((s >= 10)); then elapsed=${s}.$((ms / 100))s
    elif ((s > 0)); then elapsed=${s}.$((ms / 10))s
    else elapsed=${ms}ms
    fi

    unset cmd_timer
  else
    elapsed=0
  fi
}

nix_auto_shell() {
  if [[ -f shell.nix || -f default.nix ]]; then
    echo "\u2728 Entering nix-shell for $(pwd)... \u2728"
    nice -19 nix-shell --command "echo 'Leaving nix-shell for $(pwd). Back to you reqularly scheduled shell \u26a1'"
  fi
}

nix_auto_shell # check initial directory on login

autoload -Uz add-zsh-hook
add-zsh-hook preexec get_start_time
add-zsh-hook precmd calc_exec_time
add-zsh-hook chpwd nix_auto_shell

setopt prompt_subst
PROMPT='%B%{$fg[red]%}[%{$fg[green]%}%D %T%{$fg[red]%}][%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]${vcs_info_msg_0_}%b
%{$fg[yellow]%}(rc: %? et: ${elapsed} )%{$reset_color%}'

if [[ $USER == 'root' ]]; then
    PROMPT="$PROMPT # "
else
    PROMPT="$PROMPT $ "
fi

# History in cache directory
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$XDG_DATA_HOME/zsh/history

# Mail notification
MAILCHECK=1
MAILPATH=$HOME/.maildir
autoload checkmail

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select cache-path ${XDG_CACHE_HOME}/zsh/zcompcache
zmodload zsh/complist
compinit -d ${XDG_CACHE_HOME}/zsh/zcompdump
_comp_options+=(globdots)               # Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=5

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Home and end key binding
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line

# Move back and forth one word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Check for a shell.nix file upon entering a directory
autoload -U add-zsh-hook
enter_shell_nix() {
  if [[ -f shell.nix && ! $IN_NIX_SHELL ]]; then
    echo "Entering nix-shell environment..."
    nix-shell
  fi
}
add-zsh-hook chpwd enter_shell_nix

# Change cursor shape for different vi modes
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}

zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}

zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start {
        echoti smkx
    }
    function zle_application_mode_stop {
        echoti rmkx
    }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES
typeset -A ZSH_HIGHLIGHT_PATTERNS

# Main highlighter
# To have paths colored instead of underlined
ZSH_HIGHLIGHT_STYLES[path]='fg=green'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=blue'

# Pattern highlighter
# To have commands starting with `rm -rf` in red:
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

# Cursor highlighter
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'


ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#808080,underline"

