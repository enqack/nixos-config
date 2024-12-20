#
# XDG settings
#

# xdg-desktop-portal plugin
export XDG_CURRENT_DESKTOP=xcb

# XDG paths
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

#
# Fixing paths
#

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export GEM_PATH="${XDG_DATA_HOME}/ruby/gems"
export GEM_SPEC_CACHE="${XDG_DATA_HOME}/ruby/specs"
export GEM_HOME="${XDG_DATA_HOME}/ruby/gems"
export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
export GTK_RC_FILES="${XDG_CONFIG_HOME}/gtk-1.0/gtkrc"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
export ICEAUTHORITY="${XDG_CACHE_HOME}/ICEauthority"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME}/java"
export MAILRC="${XDG_CONFIG_HOME}/mail/mailrc"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm/npmrc"
export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME}/ripgrep/ripgreprc"
export RXVT_SOCKET="${XDG_RUNTIME_DIR}/urxvtd"
export STACK_ROOT="${XDG_DATA_HOME}/stack"
export VAGRANT_HOME="${XDG_DATA_HOME}/vagrant"
export VAGRANT_ALIAS_FILE="${XDG_DATA_HOME}/vagrant/aliases"
export VIMINIT=":source ${XDG_CONFIG_HOME}/vim/vimrc"
export VSCODE_PORTABLE="${XDG_DATA_HOME}/vscode"
export WGETRC="${XDG_CONFIG_HOME}/wget/wgetrc"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
export XSERVERRC="${XDG_CONFIG_HOME}/X11/xserverrc"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

#
# Defautl applications
#
export READER="zathurai"
export BROWSER="google-chrome-stable"
export VIDEO="mpv"
export IMAGE="sxiv"
export EDITOR="vim"
export PAGER="less"
export TERMINAL="alacritty"
export COLORTERM="truecolor"
export OPENER="xdg-open"
export WM="hyprland"
