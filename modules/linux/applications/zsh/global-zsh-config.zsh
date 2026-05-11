# zshrc

autoload -Uz add-zsh-hook

# Enable colors
autoload -U colors && colors
export TERM="xterm-256color"


zmodload zsh/datetime

typeset -g PROMPT_ET="0"
typeset -g PROMPT_STATUS_STRING=""
typeset -g _did_run_cmd=0

export elapsed=0
typeset -g cmd_timer_us=0

# Fast ANSI escapes (deterministic)
typeset -gr _CLR_RESET=$'\e[0m'
typeset -gr _CLR_BOLD=$'\e[1m'
typeset -gr _CLR_YELLOW=$'\e[33m'
typeset -gr _CLR_GREEN=$'\e[32m'
typeset -gr _CLR_RED=$'\e[31m'
typeset -gr _CLR_CYAN=$'\e[36m'

# Return current time in microseconds as an integer, using only zsh builtins
_now_us() {
  local t=$EPOCHREALTIME          # "seconds.microseconds"
  local sec=${t%.*}
  local frac=${t#*.}

  # Pad/trim microseconds to exactly 6 digits
  frac=${(l:6::0:)frac}
  frac=${frac[1,6]}

  print -r -- $(( sec * 1000000 + frac ))
}

function get_start_time() {
  _did_run_cmd=1
  cmd_timer_us=$(_now_us)
}

function calc_exec_time() {
  # No command was timed, or timer missing
  if (( _did_run_cmd == 0 || cmd_timer_us <= 0 )); then
    elapsed="0ms"
    PROMPT_ET="0"
    export PROMPT_ET
    cmd_timer_us=0
    return
  fi

  local now_us=$(_now_us)
  local d_us=$(( now_us - cmd_timer_us ))

  # Wall-clock can go backwards (NTP/sleep). Clamp.
  if (( d_us < 0 )); then
    d_us=0
  fi

  local d_ms=$(( d_us / 1000 ))
  local d_s=$(( d_ms / 1000 ))
  local ms=$(( d_ms % 1000 ))
  local s=$(( d_s % 60 ))
  local m=$(( (d_s / 60) % 60 ))
  local h=$(( d_s / 3600 ))

  if (( h > 0 )); then
    elapsed=${h}h${m}m
  elif (( m > 0 )); then
    elapsed=${m}m${s}s
  elif (( s >= 10 )); then
    elapsed=${s}.$(( ms / 100 ))s
  elif (( s > 0 )); then
    elapsed=${s}.$(( ms / 10 ))s
  else
    elapsed=${ms}ms
  fi

  PROMPT_ET=$elapsed
  export PROMPT_ET

  # Reset timer for next command
  cmd_timer_us=0
}

function _update_prompt_status() {
  local rc=$?
  calc_exec_time
  _did_run_cmd=0

  if (( rc == 0 )); then
    PROMPT_STATUS_STRING="${_CLR_YELLOW}(rc: ${_CLR_GREEN}0${_CLR_YELLOW} et: ${_CLR_CYAN}${elapsed}${_CLR_YELLOW})${_CLR_RESET}"
  else
    PROMPT_STATUS_STRING="${_CLR_YELLOW}(rc: ${_CLR_BOLD}${_CLR_RED}${rc}${_CLR_RESET}${_CLR_YELLOW} et: ${_CLR_CYAN}${elapsed}${_CLR_YELLOW})${_CLR_RESET}"
  fi

  export PROMPT_STATUS_STRING
}


# Check for a shell.nix file upon entering directory with nix-shells as parent
typeset -g _last_nix_shell_pwd=""

enter_shell_nix() {
  local root="$HOME/nix-shells"
  case "$PWD/" in
    "$root"/*)
      [[ "$PWD" == "$_last_nix_shell_pwd" ]] && return
      if [[ -f shell.nix && -z "$IN_NIX_SHELL" ]]; then
        _last_nix_shell_pwd="$PWD"
        echo "✨ Entering nix-shell for $PWD... ✨"
        nice -19 nix-shell
        echo "Back to your regular shell ⚡"
      fi
      ;;
  esac
}

typeset -g PROMPT_TIME=""

function _prompt_time_update() {
  PROMPT_TIME=${(%):-%D{%Y-%m-%d %H:%M:%S}}
  export PROMPT_TIME
}
add-zsh-hook precmd _prompt_time_update

add-zsh-hook preexec get_start_time
add-zsh-hook precmd _update_prompt_status

add-zsh-hook chpwd enter_shell_nix
enter_shell_nix # check initial directory on login


setopt prompt_subst
#PROMPT='%B%{$fg[red]%}[%{$fg[green]%}%D %T%{$fg[red]%}][%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%b
#%{$fg[yellow]%}(rc: %? et: ${elapsed} )%{$reset_color%}'

#if [[ $USER == 'root' ]]; then
#    PROMPT="$PROMPT👑%{$fg[red]%}>%{$reset_color%} "
#else
#    PROMPT="$PROMPT%{$fg[red]%}>%{$reset_color%} "
#fi

# History in cache directory
mkdir -p $XDG_DATA_HOME/zsh
HISTFILE=$XDG_DATA_HOME/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# Mail notification
MAILCHECK=1
MAILPATH=$HOME/.maildir
autoload checkmail

# Basic auto/tab complete
zstyle ':completion:*' menu select cache-path ${XDG_CACHE_HOME}/zsh/zcompcache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zmodload zsh/complist
compinit -C -d ${XDG_CACHE_HOME}/zsh/zcompdump
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
#preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

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

zplug "zsh-users/zsh-completions"
zplug "wfxr/forgit"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --min-height=5+
  --color=fg:#d0d0d0,fg+:#d0d0d0
  --color=hl:#5f87af,hl+:#ff0000,info:#afaf87,marker:#87ff00
  --color=prompt:#ff0000,spinner:#af5fff,pointer:#af5fff,header:#87afaf
  --color=border:#262626,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# how many lines does fzf's prompt occupies
zstyle ':fzf-tab:*' fzf-pad 4

# cd replacement (z)
eval "$(zoxide init zsh)"

# thefuck replacement
eval "$(pay-respects zsh --alias)"

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
