# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't inherit any PROMPT_COMMAND, also make sure it exists
export PROMPT_COMMAND=true
# https://github.com/neovim/neovim/issues/6134
# tells me that for nvim this is better
#export TERM=screen-256color

# Start tmux on every login shell
# Don't start tmux if it's already on. tmux takes care of that itself so this might be unnecessary
export TERMINAL=st
[[ -z "$TMUX" && -n $DISPLAY ]] && command -v tmux && { echo starting tmux; exec tmux;  }

# Ignore space-prepende commands and duplicates
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE=infinite
HISTFILESIZE=infinite

HISTTIMEFORMAT="%F %T: "

# update LINES COLUMNS after widnow resize
shopt -s checkwinsize

# . is bold, it allows you to stop prepending ./ to command from the current dir,
# that is not enabled by default in linux as it is huge security risk
export PATH="$PATH:/usr/lib/go-1.9/bin:/opt/gocode/bin:~/bin:~/.cargo/bin:node_modules/.bin:~/.yarn/bin/:."


# Map keypad del inserts a dot, useful for IPs
[[ -n $DISPLAY ]] && xmodmap -e "keycode 91 mod2 = KP_Delete period"
# Map PrtSc to Menu
[[ -n $DISPLAY ]] && xmodmap -e "keycode 107 = Menu"

# git-bash-prompt
GIT_PROMPT_SHOW_UPSTREAM=1
GIT_PROMPT_ONLY_IN_REPO=1

GIT_PROMPT_SHOW_UNTRACKED_FILES=no
GIT_PROMPT_END='\n$ '
GIT_PROMPT_START='$? \w \e[1;33m\A\e[0m \e[2;37m${timer_show}\e[0m'
# {1..$(($(tput cols) - 30))}
# $(($(tput cols) - 2))
source /opt/bash-git-prompt/gitprompt.sh

export BROWSER=google-chrome

source ~/.bash_aliases

[[ -n $DISPLAY ]] && { numlockx on; }

source ~/bin/set_pyenv

# https://github.com/paoloantinori/hhighlighter
source ~/bin/h.sh

# cat will use this
tabs -4

# https://github.com/aykamko/tag
export GOPATH=/opt/gocode
export TAG_CMD_FMT_STRING='charm {{.Filename}}:{{.LineNumber}}'
if hash ag 2>/dev/null; then
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null; }
  alias ag='tag --hidden --ignore .git --ignore node_modules --ignore build --ignore __tests --ignore tests --ignore .hg --ignore .idea'
fi


# disable caps lock
[[ -n $DISPLAY ]] && setxkbmap pl -option caps:none

export EDITOR=vim
export WINEDEBUG=-all

[[ -n $DISPLAY ]] && setxkbmap -option kpdl:dot
function timer_start {
  # SECONDS: a count of the number of (whole) seconds the shell has been running
  # timer is timer or seconds
  # this command is run on each simple command via DEBUG trap
  # but the value stays the same as the first invocation
  timer=${timer:-$SECONDS}
}

function timer_stop {
  # important that this is the last function in PROMPT_COMMAND
  timer_show="$(($SECONDS - $timer))s"
  unset timer
}

# before each subsequent command
trap 'timer_start' DEBUG
# before each subsequent prompt
export PROMPT_COMMAND="$PROMPT_COMMAND;pwd > ~/last_cd"
export PROMPT_COMMAND="$PROMPT_COMMAND;timer_stop"
# if terminal closes abruptly, history has no time to sync and vanishes
export PROMPT_COMMAND="$PROMPT_COMMAND;history -a; history -n"

# surfraw
export XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS:/usr/local/etc/xdg
touch ~/last_cd
export PYTHONUNBUFFERED=1
eval "$(direnv hook bash)"
# dont use symbols in pass generate
export PASSWORD_STORE_CHARACTER_SET=[:alnum:]
# consider .files normal, for ls and mv
# http://mywiki.wooledge.org/glob#dotglob
shopt -s dotglob
# https://stackoverflow.com/a/14118014
export GIT_PAGER=cat
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="name verbose git"
export GIT_PS1_STATESEPARATOR=""
export FPP_EDITOR=charm
export XDG_CONFIG_HOME=$HOME/.config
eval $(dircolors -b $HOME/.LS_COLORS )
#eval "$(gopass completion bash)"
source ~/.bashrc.local
cd "$(cat ~/last_cd)"

pidof -q clipnotify || {
  while clipnotify; do
       notify-send "📋 copied" "$(xclip -selection clipboard -o)" -u low;
  done &
}

GPG_TTY=$(tty)
export GPG_TTY
source "$HOME/.cargo/env"

eval `ssh-agent -s`
