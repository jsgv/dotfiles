export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/opt/local/bin
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$HOME/nvim/bin
export PATH=$PATH:/usr/local/opt/llvm/bin
export PATH=$PATH:$HOME/.composer/vendor/bin

export XDG_CONFIG_HOME=$HOME/.config

export GO111MODULE=on
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export GOPROXY=direct
export PATH=$PATH:$GOBIN

# export ANDROID_HOME=$HOME/Library/Android/sdk
# export PATH=$PATH:$ANDROID_HOME/platform-tools
# export PATH="/usr/local/opt/libpq/bin:$PATH"

export HOMEBREW_NO_ANALYTICS=1
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
export NEXT_TELEMETRY_DISABLED=1
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc
export GPG_TTY=$(tty)

autoload -Uz vcs_info compinit
autoload -U colors && colors

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

setopt PROMPT_SUBST
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' get-revision      true
zstyle ':vcs_info:git*' unstagedstr       '%F{1}*%f'
zstyle ':vcs_info:git*' formats           '%m%u%c %7.7i %F{4}(%b)%f'

PROMPT='%F{7}%~%f %F{178}%#%f '
RPROMPT='${vcs_info_msg_0_} %*'

compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt appendhistory
setopt share_history

alias ls='gls --group-directories-first --color=always'
alias ll='gls -l --group-directories-first --color=always'
alias tf='terraform'

RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
NOCOLOR="\033[0m"

bindkey "\e[A"    history-beginning-search-backward
bindkey "\e[B"    history-beginning-search-forward
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

typeset -aU path

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/etc/profile.d/autojump.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"
[ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
export NODE_BIN="$NVM_BIN/node"

[ -f "$HOME/.rvm/scripts/rvm" ] && source $HOME/.rvm/scripts/rvm

# Haskell
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

for i in `find -E -L $XDG_CONFIG_HOME/personal -regex ".*.(zsh|sh)"`; do
    source $i;
done

