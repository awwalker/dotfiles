autoload -U compinit && compinit
autoload -U promptinit; promptinit
prompt pure
# ---------------------
#   	  PATH
# ---------------------
export GOPATH="$HOME/go"
export GOROOT=/usr/local/Cellar/go@1.15/1.15.13/libexec/

export PATH="$HOME/bin::${PATH}"
export PATH="$PATH:/usr/local/opt/gnupg@2.0/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"

source ~/.plaid_env ~/.quovo_env

export PATH="$PATH:${PLAID_PATH}/go.git"
export PATH="$PATH:${PLAID_PATH}/go.git/bin"
export PATH="$PATH:$PYENV_ROOT/bin"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:/usr/local/bin"

# NVM & RVM
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true

alias loadrvm='[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"'
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Preferred editor for local and remote sessions
export EDITOR=/usr/local/bin/nvim
alias vim=$EDITOR
alias vi=$EDITOR

HISTFILE=~/.zsh_history
setopt SHARE_HISTORY #Share history across terminals
export HISTCONTROL=ignoredups:ignorespace
export SAVEHIST=5000
export DISABLE_UPDATE_PROMPT=true

# ---------------------
#   	Commands
# ---------------------
#
alias cat='bat'
alias mkdir='mkdir -pv'
alias ..='cd ../'
alias ...='cd ../../'

alias ~='cd ~'

alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

f_running() { ps vwaxr -o pid,stat,%cpu,time,command | grep $1 | head -10; }

# ---------------------
# 	      GIT
# ---------------------

eval "$(hub alias -s)"
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gu='git pull'
alias ga='git add'
alias gch='git checkout'
alias gchm='git checkout master'
alias gchb='git checkout -b '
alias gd='git diff '
alias gb='git branch'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gcne="git commit --amend --no-edit"
# During rebase pick the changes @HEAD
alias grpt="git checkout --ours"
# During merge pick the changes @HEAD
alias gmpt="git checkout --theirs"
# For interacing with dot files.
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# -------------------
# 	      GO
# -------------------

export GO11MODULE="on"

# -------------------
# 	  PYTHON
# -------------------

export PYTHONDONTWRITEBYTECODE=True
eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PYTHONPATH="$PLAID_PYTHON:$QUOVO_PYTHON"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# -------------------
# 	   DOCKER
# -------------------

function stop_docks() {
    docker stop $( docker ps -aq ) && docker rm $( docker ps -aq )
}
function rm_docks() {
    docker stop $( docker ps -aq ) && docker rm $( docker ps -aq )
    docker system prune --all --volumes
}

# -------------------
#       LUA
# -------------------

alias luamake=/Users/awalker/.cache/nvim/lspconfig/sumneko_lua/lua-language-server/3rd/luamake/luamake

source /usr/local/share/fzf-tab/fzf-tab.plugin.zsh
source /usr/local/share/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey -e

# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false
