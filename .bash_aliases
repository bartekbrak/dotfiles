# vim: filetype=sh
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
alias edit_aliases='vim ~/.bash_aliases; reload_aliases; echo aliases reloaded'
alias edit_aliases_subl='subl ~/.bash_aliases'


alias ll='ls -Alh --group-directories-first'
alias llo='stat -c "%a %n"'
alias l='ls -Alh --group-directories-first -d */'
alias ls='ls --color=auto'

s() {
  [ -e ".git" ] && git status "$@"
  [ -d ".hg" ] && hg status "$@"
}
dif() {
  [ -e ".git" ] && git diff "$@"
  [ -d ".hg" ] && hg diff "$@"
}
ci() {
  [ -e ".git" ] && git commit "$@"
  [ -d ".hg" ] && hg commit "$@"
}
pull() {
  [ -e ".git" ] && git pull "$@"
  [ -d ".hg" ] && hg pull "$@"
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



alias music='vlc -I ncurses ~/music'
alias play='vlc -I ncurses'

which.many() {
    # where in path does exectuable $1 exist
    # example:
    #     which.many python
    #     /home/bartek/.pyenv/shims/python
    #     /usr/bin/python
    test -z $1 && { echo provide arg; } || {
        for i in ${PATH//:/ }
        do
            test -x "$i/$1" && echo "$i/$1"
        done
    }
}
which.rm() {
    sudo rm $(which $1)
}
path() {
    echo $PATH | sed 's,:,\n,g'
}

# Let Open Office Spreadsheet not offer restoring documents, I often kill the app and don't care about the things I didn't save
alias localc='localc --norestore'

# I'm a grown up, I can su
# Don't complain on directories, this is bold, I know.
alias rm='rm -rfv'
alias mv='mv -v'
alias apt-get='sudo apt-get'
alias apt='sudo apt'
alias dpkg='sudo dpkg'

### cleaners
alias delete.diffcruft='find \( -name \*.orig -o -name \*.rej \) -print -delete'
alias delete.pyc='find . -name \*.pyc -print -delete'
alias delete.empty_dirs='find . -type d -empty -print -delete'
alias flatten_dir='find . -type f -exec mv "{}" -t . \;'

orphaned_pyc() {
    # orphaned means there isn't a corresponding python file
    find . -name '*.pyc' -exec bash -c 'test ! -e "${1%c}"' -- {} \; -print
}

delete.orphaned_pyc() {
   find . -name '*.pyc' -exec bash -c 'test ! -e "${1%c}"' -- {} \; -print -delete
}

stale_pyc() {
    # stale is a pyc with different date then py file
    find . -name '*.pyc' -exec bash -c 'test "$1" -ot "${1%c}"' -- {} \; -print
}

delete.stale_pyc() {
    find . -name '*.pyc' -exec bash -c 'test "$1" -ot "${1%c}"' -- {} \; -print -delete
}
pycache() {
    find . -name __pycache__ -print -type d
}

delete.pycache() {
    find . -name __pycache__ -print -type d -exec rm -rf {} +
}
delete.pytest_cache() {
    find . -name .pytest_cache -print -type d -exec rm -rf {} +

}
delete.pdb() { find -name \*.py | xargs sed -i '/pdb.set_trace()/d'; }

# Decode Mongo ObjectId (contains time(
ObjectId() {
  python -c "import bson;print bson.ObjectId('$1').generation_time.strftime('%Y.%m.%d %H:%M:%S')"
}

# alias disable_touchpad='xinput set-prop 13 "Device Enabled" 0'
# alias enable_touchpad='xinput set-prop 13 "Device Enabled" 1'

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
      ~/.bashrc.local
      ~/.vimrc
      ~/.ipython/profile_default/startup/00-first.py
      ~/.i3/config
      ~/.tmux.conf
      ~/dmenu.personal
      ~/.pypirc
      ~/.bash_secrets
      ~/.ssh/config
      ~/.config/greenclip.cfg
      ~/packages
      ~/.Xresources
      ~/.config/git/config
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
cdsitepackages() {
    #cd $(python -c 'import site; print(site.getsitepackages()[0])')
    cd $(python -c 'from distutils.sysconfig import get_python_lib; print(get_python_lib())')
}
alias d=docker-compose
alias g=git
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
alias D=docker
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
fixup.head() {
    git ci --fixup HEAD "$@"
}
fixup.sha() {
    sha=$1
    shift
    git ci --fixup $sha "$@"
}
add() {
    git add ${@:-.}
}
alias rebase='git fetch;git rebase -i origin/master'
alias rebase_root='git fetch;git rebase -i --root'
alias fetch='git fetch'
f() {
    # usage
    #   f py
    #   f py*
    local part=$1
    shift
    find -name "*$part" $@
}
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
\)'
cycle='unblock; termdown -v pl 1500; i3-msg "workspace www"; block'


where_defined() {
  # where is a function definded, WIP, doesn't catch all
  bash --debugger -lxic 'PS4='"'"'CATCHME ${BASH_SOURCE[0]} '"'"'; '$1'' |& grep '^CATCHME /'
}
link_symlinks() {
    # sudo find /etc/ -xtype l -print -delete
    (
        cd ~
        find symlinks -type f | sed -e "s/symlinks/ /" | xargs sudo rm
        sudo cp -vrs symlinks/* /
    )
}
which.edit() {
    editor $(which $1)
}
function _executables {
    local exclude=$(compgen -abkA function | sort)
    local executables=$(compgen -c)
    COMPREPLY=( $(compgen -W "$executables" -- ${COMP_WORDS[COMP_CWORD]}) )
}
complete -F _executables which.edit which.many which.rm

gpg.reload_agent() {
    gpg-connect-agent reloadagent /bye
}
x.load() {
  xrdb -load $1
}
x.merge() {
  xrdb -merge $1
}
x.theme() {
  xrdb -merge ~/iTerm2-Color-Schemes/Xresources/$1
}
_x()
{
  local opts="$(ls ~/iTerm2-Color-Schemes/Xresources/)"
  COMPREPLY=($(compgen -W "${opts}" -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}
complete -F _x x.theme
not_mine() {
    find -not -user $USER "$@"
}
alias rebase_to_root='git rebase -i --root'
alias hosts='sudo vim /etc/hosts'
paths() { GREP_COLORS='mt=01;34' egrep --color=always '[/a-zA-Z.]{1}[a-zA-Z0-9_-.]+/[a-zA-Z0-9_-.\/]+|$'; }
reload_tmux() {
    tmux source-file ~/.tmux.conf
}
# https://www.packtpub.com/mapt/book/hardware_and_creative/9781783985166/2/ch02lvl1sec23/show-options
tmux.settings() {
    tmux show-options -g
}
alias ..='cd ..'
pipi() {
    pip install $1 && pip freeze | grep -wi ^$1= | tee /dev/fd/2 | xclip -selection clipboard
    echo "copied to clipboard"
}

packages() {
    cat ~/packages | grep -v "#" | xargs sudo apt-get -y install
}
clean_pip() {
    # https://stackoverflow.com/a/11250821/1472229
    pip freeze | grep -v "^-e" | xargs pip uninstall -y
    pip freeze
}
trailing_ws() {
    find "$@" -type f -exec egrep -l " +$" {} \;
}
resolve_ssh() {
    ssh -v $1 echo |& grep Authenticating | sed -n "s/.*\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\):\([0-9]\+\) as '\(.*\)'.*/ssh \3@\1 -p \2/1p"
}
complete -F _known_hosts resolve_ssh

pyenv.new() {
   (
    set -x
    pyenv virtualenv 3.7.2 $(basename $(pwd))
    pyenv local $(basename $(pwd))
   )
}
pyenv.which() {
    pyenv which python
}
true_color_demo() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}mcolour${i} x1b[38;5;${i} \x1b[0m\n"
    done

}
color_bash_demo() {
    # https://askubuntu.com/a/279014
    for x in {0..8}; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo ""
}
tmux.terminal.reset() {
    tmux send-keys -R \; send-keys C-l \; clear-history
}
pipu() {
    pip install -U pip
}
lastkill() {
    kill %1
}
alias vb=VBoxManage
alias dmesg='dmesg -wdT'
rs() {
    source ~/source
}
# https://askubuntu.com/a/275972/35186
show_bash_variables() {
    ( set -o posix ; set ) | less
}
alias o=xdg-open
backup() {
    cp -r "$1" "$1.backup"
}
prompt.show() {
    for i in ${PROMPT_COMMAND//;/ }
    do
        echo "$i"
    done

}
tz ()
{
    for x in America/Los_Angeles Europe/Warsaw Asia/Kolkata;
    do
        TZ=$x date +"%Z%t%H:%M%t$x" "$@"
    done
}

alias autoremove='sudo apt-get autoremove'
alias find='2>/dev/null find'
cors() {
    # cors uri host origin
    # cors http://regalix.tv.lvh.me:8000/api/assets/ regalix.tv.lvh.me:8000 regalix.tv.lvh.me:4200
    #
    # The Origin header is the domain the request originates from.
    # The Host is the domain the request is being sent to. This header was introduced so hosting sites could include multiple domains on a single IP.
    # https://stackoverflow.com/a/13871912/1472229
    http \
        --print=hH \
        $1 \
        Origin:$2 \
        Host:$3 \
        'Access-Control-Request-Headers: Origin, Accept, Content-Type' \
        'Access-Control-Request-Method: GET' 
}

alias is_merge_finished="ag '>>>>>>>|<<<<<<<|======='"
fold.inplace() {
    target=$1
    shift
    fold -s "$target" "$@"  | sponge "$target"
}
work_on_sercrets() {
    export GIT_DIR=.secrets_git
}
work_on_sercrets.finish() {
    unset GIT_DIR
}
merge.me.into.master() {
  ( set -x
    git fetch &&
    git rebase origin/master &&
    git co master &&
    git pull &&
    git merge -
  )
}
merge.this.into.master() {
  ( set -x
    git fetch &&
    git checkout $1 &&
    git rebase origin/master &&
    git push -f &&
    git co master &&
    git pull &&
    git merge -
  )
}

repos.report() {
    find . -name .git | sed s,/.git,, | xargs -t -I {} git -C {} status
}

key.fingerprint() {
  ssh-keygen -E md5 -lf $1
}
checkout.all.branches() {
  for branch in $(git branch --all | grep '^\s*remotes' | egrep --invert-match '(:?HEAD|master)$'); do
      echo git branch --track $(echo $branch | sed s,remotes/origin/,,g) "$branch"
  done
}
asper() {
    ls -l ~/.ssh/config.d/asper*
}
asper.on() {
    mv ~/.ssh/config.d/asper.{disabled,conf}
    asper
}
asper.off() {
    mv ~/.ssh/config.d/asper.{conf,disabled}
    asper
}
usbcache_off() {
    sudo hdparm -W 0 $1
}
alias pkill='pkill -e'
alias killall='killall -v'
steal_pycharm() {
    echo PyCharm should be killed
    ag evlsprt --silent ~/.PyCharm*/config/options/{other,options}.xml ~/.java/.userPrefs/prefs.xml
    find  ~/.PyCharm*/ -name \*evaluation.key -delete -print
    sed --silent -i '/evlsprt/d' ~/.PyCharm*/config/options/{other,options}.xml
    sed --silent -i '/evlsprt/d' ~/.java/.userPrefs/prefs.xml
    rm -rfv ~/.java/.userPrefs/jetbrains
    echo "I think I'm done."

}
