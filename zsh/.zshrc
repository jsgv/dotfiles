export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/opt/local/bin:$PATH
export PATH=$HOME/.composer/vendor/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/.yarn/bin:$PATH
export PATH=$HOME/codeql-home/codeql:$PATH

export GO111MODULE=on
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

export LANG=en_US.UTF-8
export EDITOR=nvim
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=10000
export LESSHISTFILE=/dev/null
export NODE_REPL_HISTORY=""
export REDISCLI_HISTFILE=/dev/null
export LESSOPEN="| $(brew --prefix source-highlight)/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '
export AWS_PAGER=""
export BABEL_DISABLE_CACHE=1
export DOCKER_BUILDKIT=1
export HASURA_GRAPHQL_ENABLE_TELEMETRY=false
export STRIPE_CLI_TELEMETRY_OPTOUT=true

autoload -Uz vcs_info compinit

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

setopt PROMPT_SUBST
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*:*' unstagedstr "%F{1}*%f"
zstyle ':vcs_info:git*' formats '%m%u%c %F{4}(%b)%f'

RPROMPT='${vcs_info_msg_0_} %*'
PROMPT='%F{4}%~%f %F{8}%#%f '

compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

eval `gdircolors -b $HOME/Code/github.com/arcticicestudio/nord-dircolors/src/dir_colors`
source $HOME/.rvm/scripts/rvm
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/Code/github.com/jsgv/dotfiles/zsh/secrets.zsh
source $HOME/Code/github.com/jsgv/dotfiles/zsh/functions.zsh

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt appendhistory
setopt share_history

alias ls='gls --group-directories-first --color=always'
alias ll='gls -l --group-directories-first --color=always'
alias luamake="$HOME/Code/github.com/sumneko/lua-language-server/3rd/luamake/luamake"

RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
NOCOLOR="\033[0m"

bindkey "\e[A"    history-beginning-search-backward
bindkey "\e[B"    history-beginning-search-forward
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

typeset -aU path