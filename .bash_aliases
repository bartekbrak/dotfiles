# vim: filetype=sh
# indent 2 spaces

alias cls='printf "\ec"'

reload_aliases() {
  source ~/.bash_aliases
}
alias edit_aliases='vim ~/.bash_aliases; reload_aliases; echo aliases reloaded'
alias edit_aliases_subl='subl ~/.bash_aliases'


alias ll='ls -Alh --group-directories-first'
alias l='ls -Alh --group-directories-first -d */'
alias ls='ls --color=auto'

exists_somewhere_up() {
  # find file/dit/symlink in this and parent directories
  # usage: exists_somewhere_up .git && git status
  # todo assert $1
  local needle="$1"
  local root="${2:-$PWD}"
  while ! [[ "$root" =~ ^//[^/]*$ ]]; do
    if [ -e "${root}/${needle}" ]; then
      # echo "${root}/${needle}"
      return 0
    fi
    [ -n "$root" ] || break
    root="${root%/*}"
  done
  return 1
}
#       -s, --short
#           Give the output in the short-format.
#       -b, --branch
#           Show the branch and tracking info even in short-format.
alias s='git status -sb'
alias sv='git status -vv'
alias dif='git diff'
alias ci='git commit'
alias pull='git pull'
alias push='git push'
alias br='git branch'

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
alias cp='cp -v'
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

# Decode Mongo ObjectId (contains time(
ObjectId() {
  python -c "import bson;print bson.ObjectId('$1').generation_time.strftime('%Y.%m.%d %H:%M:%S')"
}

# default values for apps
alias time='/usr/bin/time --format "elapsed: %es"'
alias tree='tree -I \*.pyc'


# This is a trick to short cut editing most common, files by e<Tab>
alias e=vim
_often_used_config_files="
  ~/.gitconfig
  ~/.bashrc
  ~/.vimrc
  ~/.ipython/profile_default/startup/00-first.py
  ~/.config/i3/config
  ~/.config/i3status/config
  ~/.tmux.conf
  ~/dmenu.personal
  ~/.pypirc
  ~/.ssh/config
  ~/.config/greenclip.cfg
  ~/packages
  ~/.Xresources
  ~/.config/git/config
"
ee() {
  for word in $_often_used_config_files
  do
    echo $word;
  done \
    | fzf --height 40% --reverse --border --color=dark -q $1 \
    | sed "s,~,$HOME,g" \
    | xargs vim
}
_e()
{
  COMPREPLY=($(compgen -W "${_often_used_config_files}" -- ${COMP_WORDS[COMP_CWORD]}))
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
alias abort='git rebase --abort'
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
alias rebase='git fetch;git rebase -i origin/dev'
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
-o -iname Downloaded\ from\*.txt \
-o -iname \*Downloaded\*.txt \
-o -name www.\*jpg \
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
        find symlinks -type f | sed -e "s/symlinks/ /" | xargs -I% sudo rm "%"
        sudo cp -vrs ~/symlinks/* /
    )
}
which.edit() {
    sudo editor $(which $1)
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
not_mine() {
    find -not -user $USER "$@"
}

alias hosts='sudo vim /etc/hosts'
paths() { GREP_COLORS='mt=01;34' egrep --color=always '[/a-zA-Z.]{1}[a-zA-Z0-9_-.]+/[a-zA-Z0-9_-.\/]+|$'; }
tmux.reload() {
    tmux source-file ~/.tmux.conf
}
tmux.keys() {
    tmux list-keys
}
# https://www.packtpub.com/mapt/book/hardware_and_creative/9781783985166/2/ch02lvl1sec23/show-options
tmux.settings() {
    tmux show-options -g
    echo "### local #####"
    tmux show-options
}
pipi() {
    pip install $1 && pip freeze | grep -wi ^$1= | tr -d '\n' | tee | xclip -selection clipboard
}

packages() {
    cat ~/packages | sed 's/#.*$//g' | xargs sudo apt-get -y install
}
clean_pip() {
    # https://stackoverflow.com/a/11250821/1472229
    pip freeze | sed 's,-e.*egg=,,g' | xargs pip uninstall -y
    echo left:
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
    pyenv virtualenv ${1:-3.7.9} $(basename $(pwd))
    pyenv local $(basename $(pwd))
   )
   pyenv.which
}
pyenv.which() {
    pyenv which python | tee /dev/stderr | xclip -selection clipboard
    echo 'in your clipboard now'

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
    tmux send-keys -R \; clear-history
    # tmux send-keys -R \; send-keys C-l \; clear-history
}
alias r=tmux.terminal.reset
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
  # tz
  # tz -d 10:00GMT
    local tzs="
      GMT
      Europe/Warsaw
      Australia/Sydney
    "
      # America/Los_Angeles
      # Asia/Kolkata
    for x in $tzs
    do
        TZ=$x date +"%Z%t%H:%M%t$x" "$@"
    done | column -t
}

alias autoremove='sudo apt-get autoremove'
alias find='2>/dev/null find'
cors() {
    # NAME
    #        cors - simulate a call from A        to B,
    #                               from origin   to host,
    #                               from frontend to backend,
    # SYNOPSIS
    #        cors uri Origin [Host]
    #        cors $1  $2     $3
    #        cors http://regalix.tv.lvh.me:8000/api/assets/ regalix.tv.lvh.me:4200 regalix.tv.lvh.me:8000
    #        cors https://auth.xref.com/aws/healthcheck     https://dupa.com
    #
    # The Origin header is the domain the request originates from.
    # The Host is the domain the request is being sent to. This header was introduced so hosting sites could include multiple domains on a single IP.
    # https://stackoverflow.com/a/13871912/1472229
    #
    # Host defaults to $1, changing it will confuse servers, cloudflare will serve 403,
    # Skip it, if you must, read https://stackoverflow.com/questions/43156023/what-is-http-host-header
    #
    # if the response contains Access-Control-Allow-Origin: YOUR_ORIGIN_HERE
    # then all is well
    if [[ $2 == */ ]]
    then
      local warn="⚠ Origin should not end with slash."
      echo $warn
      echo
    fi
    output=$(
    \http \
        --print=hH \
        --follow \
        --pretty all \
        $1 \
        Origin:$2 \
        Host:$3 \
        'Access-Control-Request-Headers: Origin, Accept, Content-Type' \
        'Access-Control-Request-Method: GET'
    )
    echo "$output" | sed 's,Access-Control-Allow-Origin,\x1b[1;37;41m\0\x1b[0m,g'
    if [[ "$output" =~ "Access-Control-Allow-Origin" ]]; then
       echo "🆗 Access-Control-Allow-Origin present"
       echo $warn
    else
       echo "🔴 Access-Control-Allow-Origin missing"
       echo $warn
    fi
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
    find . -type d -name .git 2>/dev/null \
        | sort -i \
        | sed s,/.git,, \
        | xargs -I % sh -c '
              echo "\e[95m%\e[0m"
              git -C % -c color.status=always status -sb | sed "s/^/  /"
              git -C % -c color.status=always branch -rvvv
          '
    find . -type d -name .git 2>/dev/null \
        | sort -i \
        | sed s,/.git,, \
        | xargs -I % sh -c '
              echo "\e[95m%\e[0m"
              git -C % -c color.status=always status -sb | sed "s/^/  /"
              git -C % -c color.status=always branch -vvv
          '
}

key.fingerprint() {
  ssh-keygen        -lf $1
  ssh-keygen -E md5 -lf $1
}
checkout.all.branches() {
  for branch in $(git branch --all | grep '^\s*remotes' | egrep --invert-match '(:?HEAD|master)$'); do
      echo git branch --track $(echo $branch | sed s,remotes/origin/,,g) "$branch"
  done
  echo copy and paste now
}
branches.last_commit_dates() {
  git for-each-ref --sort=committerdate refs/heads/ --format='%(color:red)%(objectname:short)%(color:reset) %(HEAD) %(color:yellow)%(refname:short)%(color:reset) -  %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
}
usbcache_off() {
    sudo hdparm -W 0 $1
}
alias pkill='pkill -e'
alias killall='killall -v'
steal_jetbrains() {
    echo PyCharm should be killed
    ag evlsprt --silent \
      ~/.{PyCharm,WebStorm}*/config/options/{other,options}.xml \
      ~/.config/JetBrains/{PyCharm,WebStorm}*/options/other.xml \
      ~/.java/.userPrefs/prefs.xml
    find  ~/.{PyCharm,WebStorm}*/ ~/.config/JetBrains/{PyCharm,WebStorm}* -name \*evaluation.key -print -delete
    sed --silent -i '/evlsprt/d' \
      ~/.{PyCharm,WebStorm}*/config/options/{other,options}.xml \
      ~/.config/JetBrains/{PyCharm,WebStorm}*/options/other.xml \
      ~/.java/.userPrefs/prefs.xml

    rm -rfv ~/.java/.userPrefs/jetbrains
    echo "I think I'm done."

}
need_to_run() {
    git co -bwip; git add .; git ci -nmwip; git push
}
tmp() { cd ~/tmp; }
function _help() { $1 --help; }
alias ?='_help'
alias ??=man
which_vga_driver_am_i_using() {
    # both can't be loaded
    lsmod | egrep 'nvidia|nouveau'
    # better
    lspci -k | grep -A 2 -E "(VGA|3D)"
}
alias urldecode='python3 -c "import sys, html; print(html.unescape(sys.argv[1]))"'
alias wttr='http wttr.in/Warsaw'
alias mkdir='mkdir -vp'
alias yt-mp3-dl='youtube-dl -x --audio-format mp3'
alias można_teraz_bezpiecznie_wyłączyć_komputer='history.merge; sudo shutdown now'
alias suspend='history.merge; sudo pm-suspend'
alias hibernate='history.merge; sudo systemctl hibernate'

alias clean_journal='sudo journalctl --vacuum-time=2d'
alias cal='ncal -Mw'
alias http='http --print=hHbB'
history.merge() {
    # https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps
    history -a; history -c; history -r;
}
cpo() {
    cp $1 $2;
    sudo chown bartek:bartek $2
}
alias diff='diff -y --suppress-common-lines'
mount_clones() {
    rclone mount --daemon --allow-non-empty gdrive: ~/gdrive/
    rclone mount --daemon mega: ~/mega
    rclone mount --daemon photos: ~/photos
}

alarm='paplay /usr/share/sounds/ubuntu/stereo/phone-incoming-call.ogg'
usb_cache_off() {
    sudo hdparm -W 0 /dev/sdc*
}
alias fd='fdfind -IH'
mp3_to_mp4() {
    ffmpeg -loop 1 -r 1 -i "${2:-~/tmp/last.png}" -i "$1" -c:a copy -shortest -c:v libx264 output.mp4
}
alias xev.less='xev -event keyboard | egrep -o ".+event|state.*)"'

rebase_all() {
    git fetch
    local onto=${1:-origin/dev}
    for local_branch in $(git for-each-ref --format='%(refname:short)' refs/heads/ | grep -v ^dev$)
    do
        local status=$(git status --untracked-files=no --porcelain)
        if [ -z "$status" ]
        then
            echo -e "\033[92mREBASE $local_branch \033[0m"
            git checkout $local_branch
            git rebase $onto
            echo
        else
            echo "action required: $status"
            break
        fi
    done
}
track_all() {
     git fetch
    local onto=${1:-origin/dev}
    for local_branch in $(git for-each-ref --format='%(refname:short)' refs/heads/ | grep -v ^dev$)
    do
        local status=$(git status --untracked-files=no --porcelain)
        if [ -z "$status" ]
        then
            echo -e "\033[92mSET UPSTREAM $local_branch \033[0m"
            git checkout $local_branch
            git branch -u origin/$local_branch
            echo
        else
            echo "action required: $status"
            break
        fi
    done
}
rm_gone() {
    # Remove tracking branches no longer on remote
    # https://stackoverflow.com/a/33548037/1472229
    # not revised
    git fetch -p && for branch in `git for-each-ref --format '%(refname) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}'`; do git branch -D $branch; done

}
online() {
    wget -q --spider http://google.com && echo Online || echo Offline
}

track_me() {
    git branch --set-upstream-to=origin/$(git rev-parse --abbrev-ref HEAD)
}
countdown()
(
  IFS=:
  set -- $*
  secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} ))
  while [ $secs -gt 0 ]
  do
    sleep 1 &
    printf "\r%02d:%02d:%02d" $((secs/3600)) $(( (secs/60)%60)) $((secs%60))
    secs=$(( $secs - 1 ))
    wait
  done
  echo
)
breaknow() {
    i3lock -i ~/tmp/break.png -t
}
alias sync='sync && beep -r 3'
alias repo='gh repo view --web'
# calling sudo with alias will work now
# https://askubuntu.com/a/22043/35186
alias sudo='sudo '
alias mic_loop='    pactl   load-module module-loopback'
alias mic_loop_off='pactl unload-module module-loopback'
alias what_changed1="git log --oneline --name-status ORIG_HEAD.."
alias what_changed2="git diff --name-status ORIG_HEAD.."
alias chrome_glitches="pkill -f 'chrome \-\-type=gpu-process'"
alias pipu="pip install -U pip"

_gcalcli_complete()
{
  local opts="list search edit delete agenda updates calw calm quick add import remind"
  COMPREPLY=($(compgen -W "${opts}" -- ${COMP_WORDS[COMP_CWORD]}))
  return 0
}
alias gcal=gcalcli
complete -F _gcalcli_complete gcalcli gcal
function pyenv.uppip() {
  base=$(pyenv versions --bare | grep -v /envs/)
  for a_python in $base
  do
    pyenv shell $a_python
    echo switched to $a_python
    pip install -U pip
    pyenv shell -
  done
}
alias dir='fd --type directory'  # shadows useless dir, poor ls copycat
alias enen="cambrinary -w"
alias enpl="trans -brief -t pl"
word() {
  echo -e "\e[93mΔ $@\e[0m"
  enpl $1
  # strip US pronunciation
  # strip UK marker (with colour)
  enen $(echo $@ | sed s,\ ,-,g) \
    | sed 's,US.*,,g' \
    | sed 's, \x1b\[0;34;49mUK\x1b\[0m,,g'
  # store in
  echo "$@" >> ~/words
  echo '~/words:' $(wc -l ~/words | awk '{ print $1 }') collected
}
espl() {
  trans -brief -s es -t pl "$@"
}
espl_() {
  trans -s es -t pl "$@"
}


work() {
  if [[ "$*" == *--help* ]]
  # https://superuser.com/a/186304/160379
  then
    echo -e "\e[1mNAME\e[0m\n\twork - record starting to work in Google Calendar"
    echo -e "\e[1mSYNOPSIS\e[0m\n\twork [when[ duration[ under what title]]]"
    echo -e "\twork 06:00"
    echo -e "\twork 06:00 120"
    echo -e "\twork 06:00 120 two hours of straight coding"
  else
    when=${1:-now}
    shift
    duration=${1:-240}
    shift
    title=${@:-work}
    gcal add --noprompt \
      --when $when \
      --duration $duration \
      --title "$title"
  fi

}

lyrics() {
  if [[ "$*" == *--help* ]]
  # https://superuser.com/a/186304/160379
  then
    echo -e "\e[1mNAME\e[0m\n\tlyrics - fetch lyrics from makeitpersonal.co"
    echo -e "\e[1mSYNOPSIS\e[0m\n\tlyrics author name of the song"
    echo -e "\tlyrics sting shape of my heart"
    echo -e "\tlyrics 'Michael Jackson' thriller"
  else
    author=$1
    shift
    title="$@"
    set -x
    wget -q -O - "http://makeitpersonal.co/lyrics?artist=$author&title=$title"
    set +x
  fi
}

ag.quiet() {
  \ag \
    --nobreak \
    --nocolor \
    --nofilename \
    --nogroup \
    --nonumbers \
    "$@"
}

base64url() {
    # Don't wrap, make URL-safe, delete trailer.
    base64 -w 0 | tr '+/' '-_' | tr -d '='
}

jwt() {
  # https://stackoverflow.com/a/55389212/1472229
  # https://gist.github.com/rlipscombe/ada19c6b2abaabcef21500c3c56db482
  #
  # JWT is base64url, not base64, "-" and "_" are illegal
  #   in jq: gsub("-";"+") | gsub("_";"/")
  #   in sh: tr '+/' '-_'
  if [ "$#" -eq 2 ]; then
    secret_key=$2
    echo "sig provided, $secret_key"
  fi

  base64url() {
      # Don't wrap, make URL-safe, delete trailer.
      base64 -w 0 | tr '+/' '-_' | tr -d '='
  }


  local jwt_claims=$(jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[1] | @base64d | fromjson' <<< "$1")
  local jwt_header=$(jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[0] | @base64d | fromjson' <<< "$1")
  echo $jwt_claims
  local jwt_signature=$(echo -n "${jwt_header}.${jwt_claims}" | openssl dgst -sha256 -hmac "$secret_key" -binary | base64url)
  local part2=$(  jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .[2] | @base64d ' <<< "$1")
  local exp=$(echo $jwt_claims | jq '.exp')
  local orig_iat=$(echo $jwt_claims | jq '.orig_iat')
  local exp_decoded=$(date -d @$exp)
  local orig_iat_decoded=$(date -d @$orig_iat)

  # https://unix.stackexchange.com/a/45954/25780
  # sed cannot use \e or \033 directly,
  local esc=$(printf '\033')
  echo $jwt_header | jq -C
  echo $jwt_claims | jq -C \
    | sed -E "s/($exp)/\1,  $esc[2;37;40m# $exp_decoded$esc[0m/" \
    | sed -E "s/($orig_iat)/\1,  $esc[2;37;40m# $orig_iat_decoded$esc[0m/"
  echo $part2 | jq -C
  echo $jwt_signature
}

c() {
  echo "$@" | bc -l
}

szukaj() {
  local igla=$1
  shift
  local rozszerzenie=$1
  shift
  ag $igla -G "$rozszerzenie$" "$@"
}
fullpath() {
  local where="${1:-$PWD}"
  shift
  ret=$(readlink -f "$where" "$@" | tr -d '\n')
  echo -n "$ret" | xclip -selection clipboard
  echo CLIPBOARD: "$ret" 
}
alias grace_shutdown='i3-msg [class="."] kill'
alias detox_here='detox -v -r $(readlink -f .)'
examples() {
  # find files named $1 in $2, sort by date
  # find $2 -name $1 | xargs -I^ -n1 date +%Y.%m.%d\ ^ -r ^ | sort
  # https://stackoverflow.com/a/9612232/1472229
  find $2 -name $1 -print0 |
    while IFS= read -r -d '' line; do
        (
          cd $(dirname $line)
          git log -1 --date=short --format=%cd\ $line $line
        )
    done | sort
}
trans_clip_primary() {
  pidof -q clipnotify_primary || {
    while clipnotify_primary; do
          /home/bartek/bin/trans_clip
    done &
  }
}



who_missing_subs() {
  ls {1,2}* -1 | rev | cut -f 2- -d '.' | rev | uniq -c | grep -v "      2 "
}
movie_name() {
  filebot -rename --format '{y}.{n.space(".")}.{director.space(".")}.{genre.space(".")}' --db TheMovieDB -non-strict "$@"
}


make_pass_work_for_other_users() {
  # decryption failed: No secret key
  # https://stackoverflow.com/a/63131875/1472229
  xhost +local:
}
