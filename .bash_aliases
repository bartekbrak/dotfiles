hesitate() {
    read -p "${1}[Enter] / [s]kip / [Ctrl-C]" ret
    [ "$ret" == "s" ] && return 1
    return 0
}

tabtitle() {
    echo -ne "\033]0;${@}\007"
}

titlebar() {
    # usage: titlebar color_string_or_var text_to_print, eg:
    #     titlebar COLOR 'Name of the section' &&
    [[ $# -eq 2 ]] || echo "titlebar takes two args";
    char='█'
    echo -en "${1}"
    for i in $(eval echo {1..$(tput cols)}); do echo -n ${char}; done
    echo -e "\r\t\t ${2} ${R}"
}

alias cls='printf "\ec"'

reload_aliases() {
  source ~/.bash_aliases
}
alias edit_aliases='vim ~/.bash_aliases -c "set syntax=sh"; reload_aliases; echo aliases reloaded'


alias ll='ls -Alh --group-directories-first'
alias llo='stat -c "%a %n"'
alias l='ls -Alh --group-directories-first -d */'
alias ls='ls --color=auto'

# git/mercurial abstraction layer
# make this a separate library
st() {
  git status "$@"
}
dif() {
  git diff "$@"
}
ci() {
  git commit "$@"
}
pull() {
  git pull "$@"
}
pulldiff() {
    git fetch 
    git log ..FETCH_HEAD
    read -p "Press enter to continue"
    git diff ..FETCH_HEAD
    git pull $@
}
push() {
  git push "$@"
}



alias music='vlc -I ncurses ~/Music'

which_many() {
    # where in path does exectuable $1 exist
    # example:
    #     which_many python
    #     /home/bartek/.pyenv/shims/python
    #     /usr/bin/python
    test -z $1 && { echo provide arg; } || {
        for i in ${PATH//:/ }
        do
            test -x "$i/$1" && echo "$i/$1"
        done
    }
}

# Let Open Office Spreadsheet not offer restoring documents, I often kill the app and don't care about the things I didn't save
alias localc='localc --norestore'

# I'm a grown up, I can su
# Don't complain on directories, this is bold, I know.
alias rm='rm -rf'
alias apt-get='sudo apt-get'
alias apt='sudo apt'
alias dpkg='sudo dpkg' 

### cleaners
alias diffcruft_delete='find \( -name \*.orig -o -name \*.rej \) -print -delete'
alias pyc_delete='find . -name \*.pyc -print -delete'
alias empty_dirs_delete='find . -type d -empty -print -delete'
alias flatten_dir='find . -type f -exec mv "{}" -t . \;'

orphaned_pyc() {
    # orphaned means there isn't a corresponding python file
    find . -name '*.pyc' -exec bash -c 'test ! -e "${1%c}"' -- {} \; -print
}

orphaned_pyc_delete() {
   find . -name '*.pyc' -exec bash -c 'test ! -e "${1%c}"' -- {} \; -print -delete
}

stale_pyc() {
    # stale is a pyc with different date then py file
    find . -name '*.pyc' -exec bash -c 'test "$1" -ot "${1%c}"' -- {} \; -print
}

stale_pyc_delete() {
    find . -name '*.pyc' -exec bash -c 'test "$1" -ot "${1%c}"' -- {} \; -print -delete
}
pycache_() {
    find . -name __pycache__ -print -type d -exec rm -rf {} +
}

pycache_delete() {
    find . -name __pycache__ -print -type d -exec rm -rf {} +
}
pdb_delete() { find -name \*.py | xargs sed -i '/pdb.set_trace()/d'; }

# Decode Mongo ObjectId (contains time(
ObjectId() {
  python -c "import bson;print bson.ObjectId('$1').generation_time.strftime('%Y.%m.%d %H:%M:%S')"
}

alias dul='du -h --max-depth=1 | sort -h'

alias disable_touchpad='xinput set-prop 13 "Device Enabled" 0'
alias enable_touchpad='xinput set-prop 13 "Device Enabled" 1'

# default values for apps
alias time='/usr/bin/time --format "elapsed: %es"'
alias tree='tree -I \*.pyc'


# This is a trick to short cut editing most common, files by e<Tab>
alias e=vim
_e()
{
  local opts="
      ~/.gitconfig
      ~/.hgrc
      ~/.bashrc
      ~/.i3status.conf
      ~/.vimrc
      ~/.config/sxhkd/sxhkdrc
      ~/workspace/ls/default/.hg/hgrc
      ~/.ipython/profile_default/startup/00-first.py
      ~/.i3/config
      ~/.tmux.conf
      ~/dmenu.personal
      ~/.pypirc
      ~/.bash_secrets
      ~/.ssh/config
      ~/packages
  "
  COMPREPLY=($(compgen -W "${opts}" -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}
complete -F _e e

kill_django() {
  echo before
  pgrep -f manage.py
  pkill -f manage.py
  echo after
  pgrep -f manage.py
}
alias charm_clean='rm ~/.PyCharm2016.?/config/port'

alias cal='cal -3'

res_16_to_9() {
  echo 1024x576 
  echo 1280x720 
  echo 1366x768 
  echo 1600x900 
  echo 1920x1080
}

reload_fonts() {
  fc-cache -f -v
}
gwerp_ibus() {
    export IBUS_ENABLE_SYNC_MODE=1
    ibus-daemon -d -r
}
cdsitepackages() {
    #cd $(python -c 'import site; print(site.getsitepackages()[0])')
    cd $(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')
}
alias d=docker-compose
complete -F _docker_compose d dl
slugify() {
    echo "$@" | iconv -t ascii//TRANSLIT | sed -r s/[^a-zA-Z0-9]+/_/g | sed -r s/^-+\|-+$//g | tr A-Z a-z
}

dips () {
    # docker with ips
    docker ps --quiet "$@" | xargs --no-run-if-empty docker inspect --format='{{printf "%.12s" .Id}}|{{.Name}}|{{.Config.Image}}|{{range $net, $conf := .NetworkSettings.Networks}}
    !{{$net}}:{{$conf.IPAddress}}{{end}}
    ' | tr "!" "\t" | tr "|" "\t"
}

alias cont='git rebase --continue'
fixup() {
    sha=${1:-HEAD}
    shift
    git ci --fixup $sha $@
}
alias add='git add .'
alias rebase='git fetch;git rebase -i origin/master'
alias fetch='git fetch'
f() {
    # usage
    #   f py
    #   f py*
    local part=$1
    shift
    find -name "*$part" $@
}
alias notmine='find . \! -user bartek -print'

#### WIP section
is_tmux() { [ -n "$TMUX" ] && echo You\'re in tmux || echo You are not in tmux; }
alias reload_xresources='xrdb -merge ~/.Xresources'
alias suspend='sudo pm-suspend'

# better write this in python
alias find_download_crap='find . \
\( \
-name WWW*jpg \
-o -name Demonoid* \
-o -name Cover.jpg \
-o -name Torrent\* \
-o -iname \*SHARE\*txt \
-o -name Uwaga\* \
-o -name \*.nfo \
-o -name Downloaded\ From\* \
-o -name VISIT\* \
-o -name Thumbs.db \
-o -name \*.url \
-o -name \*trailer\* \
\)
'
cycle='unblock; termdown -v pl 1500; i3-msg "workspace www"; block'


where_defined() {
  # where is a function definded, WIP, doesn't catch all
  bash --debugger -lxic 'PS4='"'"'CATCHME ${BASH_SOURCE[0]} '"'"'; '$1'' |& grep '^CATCHME /'
}
link_etc() {
    sudo cp -vrs /home/bartek/etc /
}
