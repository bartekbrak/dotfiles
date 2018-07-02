# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't inherit any PROMPT_COMMAND, also make sure it exists
export PROMPT_COMMAND='true'
# TMUX needs this, I understand very little about the reasons but changing it to 'screen' caused total havoc 
# in how Ctrl-Left/Right worked in vim so this
export TERM='xterm-256color'

# Start tmux on every login shell
# Don't start tmux if it's already on. tmux takes care of that itself so this might be unnecessary
export TERMINAL='st'
[[ -z "$TMUX" && -n $DISPLAY ]] && { echo starting tmux; exec tmux;  }

# Ignore space-prepende commands and duplicates
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE='infinite'
HISTFILESIZE='infinite'

# update LINES COLUMNS after widnow resize
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Make local-site python bin available, ~/bin is useful
# . is bold, it allows you to stop prepending ./ to command from the current dir,
# that is not enabled by default in linux as it is huge security risk
export PATH="$PATH:/usr/lib/go-1.9/bin:/opt/gocode/bin:~/bin:."


# Map keypad del inserts a dot, useful for IPs
[[ -n $DISPLAY ]] && xmodmap -e "keycode 91 mod2 = KP_Delete period"
# Map PrtSc to Menu
[[ -n $DISPLAY ]] && xmodmap -e "keycode 107 = Menu"

# git-bash-prompt
export GIT_SHOW_UNTRACKED_FILES=normal
GIT_PROMPT_END=' ${timer_show}\n$ '
source /opt/bash-git-prompt/gitprompt.sh

export BROWSER=chromium-browser

source ~/.bash_aliases
source ~/.bash_completion

[[ -n $DISPLAY ]] && { numlockx on; }

source ~/.bash/set_pyenv
# source ~/.bash/set_virtualenvwrapper

source ~/.bash_secrets

# https://github.com/paoloantinori/hhighlighter
source ~/.bash/h.sh

# cat will use this
tabs -4

source ~/.bash/tag.bash
source ~/.bash/paths.bash

# disable caps lock
[[ -n $DISPLAY ]] && setxkbmap -option caps:none

export EDITOR=vim
export WINEDEBUG=-all
export BRAT_EDITOR=charm
export PROMPT_COMMAND="$PROMPT_COMMAND;. ~/.brat_sourceme"

[[ -n $DISPLAY ]] && setxkbmap -option kpdl:dot
source /home/bartek/workspace/dynamic_term_backgroun_per_folder/dynamic_term_backgroun_per_folder
function timer_start {
  timer=${timer:-$SECONDS}
}

function timer_stop {
  timer_show="$(($SECONDS - $timer))s"
  unset timer
}

trap 'timer_start' DEBUG

if [ "$PROMPT_COMMAND" == "" ]; then
  PROMPT_COMMAND="timer_stop"
else
  PROMPT_COMMAND="$PROMPT_COMMAND; timer_stop"
fi
source ~/.bashrc.local
# surfraw
export XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS:/usr/local/etc/xdg
export PROMPT_COMMAND="$PROMPT_COMMAND;pwd > ~/last_cd"
touch ~/last_cd
cd "$(cat ~/last_cd)"
