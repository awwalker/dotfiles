fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
# ---------------------
#   PATH
# ---------------------
export GOPATH="$HOME/go"
export GOROOT="/usr/local/opt/go/libexec"

export PATH="$HOME/bin:/usr/local/bin:${PATH}"
export PATH="$PATH:/usr/local/opt/gnupg@2.0/bin"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"

source ~/.plaid_env ~/.quovo_env

export PATH="$PATH:${PLAID_PATH}/go.git"
export PATH="$PATH:${PLAID_PATH}/go.git/bin"
export PATH="$PATH:$PYENV_ROOT/bin"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# NVM & RVM
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true

alias loadrvm='[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"'
alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Preferred editor for local and remote sessions
export EDITOR=/usr/local/bin/nvim
alias vim="nvim"

setopt menu_complete
setopt appendhistory     #Append history to the history file (no overwriting)
setopt sharehistory      #Share history across terminals
setopt incappendhistory  #Immediately append to the history file, not just when a term is killed
export HISTCONTROL=ignoredups:ignorespace
export HISTFILESIZE=999999
export HISTSIZE=999999
export DISABLE_UPDATE_PROMPT=true

# ---------------------
#   Commands
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
# GIT
# ---------------------

eval "$(hub alias -s)"
alias gs='git status'
alias gc='git commit'
alias gp='git push'
alias gu='git pull'
alias ga='git add'
alias gch='git checkout '
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

# -------------------------
# GO
# -------------------------

export GO11MODULE="on"

# ------------------------
# PYTHON
# ------------------------

export PYTHONDONTWRITEBYTECODE=True
eval "$(pyenv init -)"
export PYENV_ROOT="$HOME/.pyenv"
export PYTHONPATH="$PLAID_PYTHON:$QUOVO_PYTHON"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# ------------------------
# DOCKER
# ------------------------
alias rdocker='
    env
    DOCKER_TLS_VERIFY="1" \
    DOCKER_HOST="tcp://awalker.devenv.plaid.io:2376" \
    DOCKER_CERT_PATH="/Users/awalker/plaid/go.git/resources/development-certs/remote_devenv_certs" \
    docker'

function stop_docks() {
    docker stop `docker ps -aq` && docker rm `docker ps -aq`
}
function rm_docks() {
    docker stop `docker ps -aq` && docker rm `docker ps -aq`
    docker system prune --all --volumes
}

# --------------------
# FZF
# --------------------

pods ()
{
    k config set --current --namespace invst-team
    k get po | fzf --preview="kubectl logs {1}" --bind="ctrl-h:execute@printf 'KEYBINDINGS
CTRL-L    Get pod logs
CTRL-D    Describe pod
CTRL-R    Reload pods
CTRL-E    Exec a shell on the container
CTRL-A    Attach to pod' | less@,ctrl-l:execute(kubectl logs {1} | less),ctrl-d:execute(kubectl describe po {1} | less),ctrl-r:reload(kubectl get po),ctrl-e:execute(kubectl exec -ti {1} bash < /dev/tty > /dev/tty 2>&1),ctrl-a:execute(kubectl attach {1})"
}

export FZF_DEFAULT_COMMAND='rg --files --follow --hidden -g "!{node_modules/*,.git/*}" -- '

# If current selection is a text file show its content,
# if its a directory show its content the rest is ignored
export FZF_CTRL_T_OPTS="--preview-window wrap --preview '
if [[ -f {} ]]; then
    file --mime {} | grep -q \"text\/.*;\" && bat --color \"always\" {} || (tput setaf 1; file --mime {})
elif [[ -d {} ]]; then
    exa -l --color always {}
else;
    tput setaf 1; echo YOU ARE NOT SUPPOSED TO SEE THIS!
fi'"

export KEYTIMEOUT=1

# PYENV HELPERS
vzv() {
    pyenv activate $(pyenv virtualenvs | fzf | cut -d '(' -f 1)
}
rmvenv() {
    pyenv virtualenv-delete $(pyenv virtualenvs | fzf | cut -d '(' -f 1)
}
mkvenv() {
    pyenv virtualenv $(pyenv versions | fzf | cut -d '(' -f 1) $1
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
POWERLEVEL9K_MODE='nerdfont-complete'
source ~/.zsh/powerlevel9k/powerlevel9k.zsh-theme
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey -e
# OPENSSL
# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# export CFLAGS="-I$(brew --prefix openssl)/include"
# export CPPFLAGS="-I$(brew --prefix openssl)/include"
# export LDFLAGS="-L$(brew --prefix openssl)/lib"
