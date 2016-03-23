export __OS__=$(uname)

# gem
export GEM_HOME=${HOME}/.gem
export GEM_PATH=${GEM_HOME}

if [ $__OS__ = "Darwin" ] && [ -f /usr/libexec/java_home ] ; then
  # java
  export JAVA_HOME=$(/usr/libexec/java_home)
else

fi

export MANPATH="/usr/local/opt/findutils/libexec/gnuman:$MANPATH"

# ellipsis
# export ELLIPSIS_HOME=${HOME}/ellipsis.home
# export ELLIPSIS_PACKAGES=${HOME}/ellipsis/packages
export ELLIPSIS_PROTO=git
export PATH=${PATH}:~/.ellipsis/bin:/bin:/sbin
fpath=($HOME/.ellipsis/comp $fpath)
autoload -U compinit; compinit

# path
if [ -d "${HOME}/bin" ] ; then
    export PATH=${PATH}:${HOME}/bin
fi

# Browser
#

if [ $__OS__ = "Darwin" ] ; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

##
## Language
##
# if [[ -z "$LANG" ]]; then
#   export LANG='en_US.UTF-8'
# fi

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR=/tmp/$LOGNAME
  mkdir -p -m 700 "$TMPDIR"
fi

# function rm () {
#   local path
#   for path in "$@"; do
#     # ignore any arguments
#     if [[ "$path" = -* ]]; then :
#     else
#       local dst=${path##*/}
#       # append the time if necessary
#       while [ -e ~/.Trash/"$dst" ]; do
#         dst="$dst "$(/bin/date +%H-%M-%S)
#       done
#       /bin/mv "$path" "~/.Trash/$dst"
#     fi
#   done
# }

function rm() {
  if [ -d ~/.trash ]; then
    local DATE=`date "+%y%m%d-%H%M%S"`
    mkdir ~/.trash/$DATE 2> /dev/null
    for j in $@; do
      # skip -
      if [ $j[1,1] != "-" ]; then
        if [ -e $j ]; then
          #echo "mv $j ~/.trash/$DATE/"
          mv $j ~/.trash/$DATE/
        else
          echo "$j : not found"
        fi
      fi
    done
  else
    command rm $@
  fi
}

export TMPPREFIX=${TMPDIR%/}/zsh

# antigen
source ~/.antigen/antigen.zsh || { cd ~ && git clone git@github.com:zsh-users/antigen.git ~/.antigen && source ~/.antigen/antigen.zsh }

# plugins
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh

antigen bundle djui/alias-tips
antigen bundle rimraf/k
antigen bundle b4b4r07/enhancd

antigen use oh-my-zsh
antigen bundle compleat
antigen bundle mvn

antigen bundle ~/git/forward.zsh --no-local-clone
antigen bundle ~/git/ra-git.zsh --no-local-clone

antigen theme gnzh
#antigen theme https://gist.github.com/3750104.git agnoster

antigen apply
## antigen

# djui/alias-tips
export ZSH_PLUGINS_ALIAS_TIPS_TEXT='💡 '
## djui/alias-tips
export DISPLAY=:0

# Directory
# why would you type 'cd dir' if you could just type 'dir'?
setopt AUTO_CD
# this makes cd=pushd
setopt AUTO_PUSHD
# this will use named dirs when possible
setopt AUTO_NAME_DIRS
# this will ignore multiple directories for the stack.  Useful?  I dunno.
setopt PUSHD_IGNORE_DUPS
# blank pushd goes to home
setopt PUSHD_TO_HOME
# now we can pipe to multiple outputs!
setopt MULTIOS
# if we have a glob this will expand it
setopt GLOB_COMPLETE
setopt PUSHD_MINUS
setopt PROMPT_SUBST
setopt INTERACTIVECOMMENTS
setopt NO_BEEP
# no more annoying pushd messages...
setopt PUSHD_SILENT
# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
setopt RM_STAR_WAIT
# use magic (this is default, but it can't hurt!)
setopt ZLE
setopt NO_HUP
# if I could disable Ctrl-s completely I would!
setopt NO_FLOW_CONTROL
# keep echo "station" > station from clobbering station
setopt NO_CLOBBER
# case insensitive globbing
setopt NO_CASE_GLOB
# be reasonable!
setopt NUMERIC_GLOB_SORT
# I don't know why I never set this before.
setopt EXTENDED_GLOB
# hows about arrays be awesome?  (that is, frew${cool}frew has frew surrounding all the variables, not just first and last
setopt RC_EXPAND_PARAM
# Disable autocorrect guesses. Happens when typing a wrongcommand that may look like an existing one.
unsetopt CORRECT

LISTMAX=50

#setopt inc_append_history_time
HISTFILE=${HOME}/.zhistory
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history file.
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
unsetopt HIST_VERIFY               # Do not execute immediately upon history expansion.
export HISTIGNORE="j *:v *:vim:&:ls:ll:la:l.:pwd:exit:clear:clr:[bf]g:* --help"

# Colored grep
export GREP_OPTIONS='--color=auto'
export LESS='-MQRi'
export GREP_COLOR='01;38;5;160'

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /{bin,sbin}
  /usr/local/{bin,sbin}
  $path
)

# Ssh agent
if [ -f ~/.agent.env ] ; then
  . ~/.agent.env > /dev/null
  if ! kill -0 ${SSH_AGENT_PID} > /dev/null 2>&1; then
     echo "Stale agent file found. Spawning new agent… "
     eval `ssh-agent | tee ~/.agent.env`
     ssh-add
  fi
else
  echo "Starting ssh-agent"
  eval `ssh-agent | tee ~/.agent.env`
  ssh-add ~/.ssh/id_rsa
fi

# Term setup
export TERM='screen-256color'

if [ "$__OS__" = "Darwin" ] ; then
  # Add homebrew to the completion path
  fpath=("/usr/local/bin/" $fpath)
fi

autoload -U add-zsh-hook

# global aliases
alias -g  G='|& grep -E -i'
alias -g  L="| less"
alias -g  X='| xargs'
alias -g X0='| xargs -0'
alias -g  C='| wc -l'
alias -g  A='| awk'
alias -g  H='| head -n $(($LINES-5))'
alias -g  T='| tail -n $(($LINES-5))'
alias -g  S='| sed'
alias -g  N='&> /dev/null'
alias -g XC='&> xclip -i -sel c'
# last modified(inode time) file or directory
alias -g NF="./*(oc[1])"

function take() {
  [ $# -eq 1 ]  && mkdir "$1" && cd "$1"
}

if (( $+commands[fasd] )) ; then
  [[ -d ${HOME}/.config/zsh ]] || mkdir -p ${HOME}/.config/zsh
  cache_file="${HOME}/.config/zsh/fasd_cache.zsh"
  if [[ "${commands[fasd]}" -nt "$cache_file" || ! -s "$cache_file" ]]; then
    # Set the base init arguments.
    init_args=(zsh-hook)
    # Set fasd completion init arguments, if applicable.
    init_args+=(zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)
    # Cache init code.
    fasd --init "$init_args[@]" >! "$cache_file" 2> /dev/null
  fi
  source "$cache_file"
  unset cache_file init_args
  fasd_cd() {
    local fasd_ret="$(fasd -d "$@")"
    if [[ -d "$fasd_ret" ]]; then
      cd "$fasd_ret"
    else
      print "$fasd_ret"
    fi
  }
  alias f='fasd -f'
  # interactive file selection
  alias sf='fasd -sif'
  # interactive directory selection
  # alias j='fasd -sid'
  # changes the current working directory interactively.
  alias j='fasd_cd -i'
  # show / search / select
  alias s='fasd -si'
  # quick opening files with vim
  # alias v='sf -e vim'
  # quick opening files with vim
  alias v='f -t -e vim -b viminfo'
fi

# aliases
alias vi='vim'
alias history='fc -l 1'
alias md='mkdir -p'
alias pgrep="pgrep -f"
alias pkill="pkill -9 -f"
alias wshare='python -m SimpleHTTPServer'
# long view, show hidden
alias l='ls -Glah'
# compact view, show hidden
alias la='ls -GAF'
# long view, no hidden
alias ll='ls -GlFh'
alias sl='ls -G'
alias ls='ls -G'
alias less='less -R'
alias diff='colordiff -u'
alias cls="clear"
alias tmx='if [ -z "$TMUX" ]; then; tmux attach || tmux new ; fi'
alias agg='ag -g'
alias top='htop'
# opening ports
alias port='netstat -ntlp'
# show directories size
alias dud='du -s *(/)'
alias x='exit'
alias mvn="mvn-color"
alias mvnc='mvn clean'
alias mvni='mvn clean install'
alias mvnisd='mvn celan install -DskipTests=true'
# reload zsh configuration
alias zreload='exec zsh'
alias of='open .'
alias c='lolcat'
alias h='head'
if [ "$__OS__" = "Darwin" ]; then
  # Show/Hide Hidden Files mac OS X
  alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
  alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
  # BREW
  alias brewc='brew cleanup'
  alias brewC='brew cleanup --force'
  alias brewi='brew install'
  alias brewl='brew list'
  alias brews='brew search'
  alias brewu='brew update && brew upgrade --all'
  alias brewx='brew remove'
  # CASK
  alias cask='brew cask'
  alias caskc='brew cask cleanup --outdated'
  alias caskC='brew cask cleanup'
  alias caski='brew cask install'
  alias caskl='brew cask list'
  alias casks='brew cask search'
  alias caskx='brew cask uninstall'
  # OPEN FILE
  alias -s html=open
  alias -s pdf=open
  # OPEN FOLDER
  alias n='open .'
  alias o='fasd -a -e open'
  alias simulator='open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app'
  function pfd() {
    osascript 2>/dev/null <<EOF
      tell application "Finder"
        return POSIX path of (target of first window as text)
      end tell
EOF
  }
  # changes directory to the current Finder directory.
  alias cdf='cd "$(pfd)"'
  # pushes directory to the current Finder directory.
  alias pushdf='pushd "$(pfd)"'
fi
if [ "$__OS__" = "Linux" ]; then
  # OPEN FILE
  alias -s html=firefox
  alias -s pdf=evince
  # OPEN FOLDER
  alias n='nautilus'
fi

bindkey -e

# Colors
autoload colors; colors;
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

autoload -U edit-command-line
zle -N edit-command-line

# add sudo before command with alt+s, esc+esc
function prepend-sudo() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N prepend-sudo
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" prepend-sudo
# Defined shortcut keys: [Alt-s]
bindkey "^[s" prepend-sudo

zle -N prepend-sudo
bindkey "^[s" prepend-sudo
bindkey "\e\e" prepend-sudo

# change to parent directory matching partial string, eg:
# in directory /home/foo/bar/baz, 'bd f' changes to /home/foo
function bd () {
  local old_dir=`pwd`
  local new_dir=`echo $old_dir | sed 's|\(.*/'$1'[^/]*/\).*|\1|'`
  index=`echo $new_dir | awk '{ print index($1,"/'$1'"); }'`
  if [ $index -eq 0 ] ; then
    echo "No such occurrence."
  else
    echo $new_dir
    cd "$new_dir"
  fi
}

function globalias() {
   if [[ ${LBUFFER} =~ ' [A-Z0-9]+$' ]]; then
     zle _expand_alias
     zle expand-word
   fi
   zle self-insert
}
zle -N globalias
bindkey " " globalias

# ctrl+space to bypass completion
# bindkey "^ " magic-space

# space during searches
bindkey -M isearch " " magic-space


# quick jumping to n-th arguments by pressing alt+number(does not not work in tmux) or esc+number
bindkey '^[1' beginning-of-line
bindkey -s '^[2' '^A^[f'
bindkey -s '^[3' '^A^[f^[f'
bindkey -s '^[4' '^A^[f^[f^[f'
bindkey -s '^[5' '^A^[f^[f^[f^[f'
bindkey -s '^[6' '^A^[f^[f^[f^[f^[f'
bindkey -s '^[7' '^A^[f^[f^[f^[f^[f^[f'
bindkey -s '^[8' '^A^[f^[f^[f^[f^[f^[f^[f'
bindkey -s '^[9' '^A^[f^[f^[f^[f^[f^[f^[f^[f'

# home and end keys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[m"    copy-earlier-word

bindkey '^F' forward-word
bindkey '^B' backward-word

# bindkey '^R'     history-incremental-search-backward
# bindkey '^[r'    history-incremental-search-backward

bindkey '^[[5~'  up-line-or-history
bindkey '^[[6~'  down-line-or-history

bindkey '^[[A'   up-line-or-search
bindkey '^[[B'   down-line-or-search

bindkey '^[[H'   beginning-of-line
bindkey '^[[1~'  beginning-of-line

bindkey '^[[F'   end-of-line
bindkey '^[[4~'  end-of-line

bindkey '^[[Z'   reverse-menu-complete

bindkey '^[[3~'  delete-char
bindkey '^[3;5~' delete-char
bindkey '\e[3~'  delete-char

bindkey '^[^I'   _history-complete-older
bindkey '^[^[^I' _history-complete-newer

bindkey '^U'     backward-kill-line

# Completion
setopt MENU_COMPLETE
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

function fn() {
  find . -name "$1"
}

function up() {
  brew update
  brew upgrade
  brew cleanup
  brew prune
  brew cask cleanup
  ls -l /usr/local/Library/Formula | grep homebrew-cask | awk '{print $9}' | for evil_symlink in $(cat -); do rm -v /usr/local/Library/Formula/$evil_symlink; done
  brew doctor
}

function man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    PAGER=/usr/bin/less \
    _NROFF_U=1 \
    PATH=${HOME}/bin:${PATH} \
      man "$@"
}

function foreground-current-job() {
  fg;
}
zle -N foreground-current-job
bindkey -M emacs '^z' foreground-current-job

# This bunch of code displays red dots when autocompleting a command with the tab key, "Oh-my-zsh"-style.
function expand-or-complete-with-dots() {
  echo -n "\e[31m......\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

source /usr/local/opt/fzf/shell/key-bindings.zsh

# forward plugin
export FWD_HOME="$HOME/git/fwd-lohika"
export FWD_CONFIG="$HOME/git/forward"
export FWD_JSON="$FWD_CONFIG/fwd-config.json"
export FWD_SETTINGS="$HOME/.fwd"

zmodload -i zsh/complist

# Use caching to make completion for commands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.cache/zsh-completion-cache"

# Case-sensitive (all), partial-word, and then substring completion.
# zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# setopt CASE_GLOB

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unsetopt CASE_GLOB

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Media Players
zstyle ':completion:*:*:mpg123:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'

# SSH/SCP/RSYNC
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*)'

autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export CLICOLOR=true

function colours() {
    for i in {0..255} ; do
        printf "\x1b[38;5;${i}mcolour${i}\n"
    done
}

[[ $SHLVL != "2" ]] && tmux new

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
