[ -z "$PS1" ] && return

# update the values of LINES and COLUMNS.
shopt -s checkwinsize
. /usr/share/bash-completion/bash_completion
bind '"\e[A": history-search-backward';bind '"\e[B": history-search-forward'
shopt -s histappend
HISTSIZE='infinite'
HISTFILESIZE='infinite'
alias ll='ls -alF'
alias d=docker-compose
export TERMINAL=st
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# https://github.com/paoloantinori/hhighlighter
source /usr/local/bin/h.sh
alias fd='fdfind'
