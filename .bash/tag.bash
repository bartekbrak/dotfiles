# https://github.com/aykamko/tag
export GOPATH=/opt/gocode
export TAG_CMD_FMT_STRING='charm {{.Filename}}:{{.LineNumber}}'
if hash ag 2>/dev/null; then
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null; }
  alias ag='tag --hidden --ignore frontend --ignore .git --ignore node_modules --ignore build --ignore __tests --ignore tests'
fi
