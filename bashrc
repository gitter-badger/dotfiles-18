# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# sudo pip install virtualenv virtualenvwrapper
# mkdir $HOME/.virtualenvs
export VIRTUALENV_DISTRIBUTE=true
export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

export PYTHONSTARTUP=~/.pythonstartup
# see http://www.shallowsky.com/linux/noaltscreen.html
export LESS='-X'
export GREP_OPTIONS='--exclude-dir=.svn --exclude-dir=.git --color=auto -nrI'

# alias
alias -- svndi='svn di $@|view --noplugin -'

# see http://superuser.com/questions/249293/rename-tmux-window-name-to-prompt-command-ps1-or-remote-ssh-hostname
ssh() {
    if [ $# == 1 -a "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
		# run 'ssh user@host' in tmux, rename window name to 'ssh@ip'
		tmux rename-window "${1:0:6}@`command ssh \"$@\" printenv SSH_CONNECTION|cut -d\  -f3`"
		command ssh "$@"
		tmux set-window-option automatic-rename "on" 1>/dev/null
    else
		# run 'ssh xxx' out of tmux or 'ssh user@host xxx' in tmux
		command ssh "$@"
    fi
}

# see http://hoelz.ro/blog/making-ssh_auth_sock-work-between-detaches-in-tmux
SSH_SOCK=/tmp/ssh-agent-$USER
if [ ! -z "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$SSH_SOCK" ] ; then
	rm -f $SSH_SOCK
    ln -sf $SSH_AUTH_SOCK $SSH_SOCK
    export SSH_AUTH_SOCK=$SSH_SOCK
fi

# auto open tmux
if which tmux 2>&1 >/dev/null; then
    tm () {
        # -2: Force tmux to assume the terminal supports 256 colours.
        [ -z "$TMUX"  ] && (tmux -2 attach "$@" || tmux -2 new "$@")
    }
    #export DISABLE_AUTO_TITLE=true
    export tm
	tm
fi

