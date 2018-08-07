#unset HISTFILE
if [ -n "$DOT_BASH_PROFILE" ]; then
	return
fi
DOT_BASH_PROFILE=TRUE; export DOT_BASH_PROFILE
umask 066
set -o emacs
HISTSIZE=2048; export HISTSIZE
IGNOREEOF=10; export IGNOREEOF

test -x /usr/bin/resizewin && /usr/bin/resizewin -z

if [ -n "$DISPLAY" ]; then
	PS1="\[\e]1;\h\a\]\[\e]2;\u@\h:\w\a\]\[\e[32m\]\u@\h [\!]\[\e[33m\]\w\[\e[0m\]\\$ "
else
	PS1="\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\\$ "
fi

LESS='-XIMn'; export LESS
PAGER='less -s'; export PAGER
# for wget
#HTTPPROXY=ftpproxy; export HTTPPROXY
#PROMPT_COMMAND='echo -ne "\033]0;${LOGNAME}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
#export PROMPT_COMMAND
unset TMOUT

function addPath() {
	eval var=\${${1}}
	dir=$2
	if [ ! -d $dir ]; then
		return 1
	fi

	if [ -z "$var" ]; then
		eval export $1=$dir
		return 0
	fi

	echo $var | egrep "(^|:)$dir($|:)" > /dev/null 2>&1
	if [ "$?" -ne 0 ]; then
		if [ "$3" = "head" ]; then
			eval $1=\"${dir}\":\"${var}\"
		else
			eval $1=\"${var}\":\"$dir\"
		fi
	fi
}

read _sys _host _machine << @EOF
`uname -s -n -m`
@EOF

read _revision _version << @EOF
`uname -r -v`
@EOF

# most systems don't need this anymore
#addPath LD_LIBRARY_PATH /usr/local/lib

PATH=/sbin:/bin

while read d p; do
	if [ -d "$d" ]; then
		addPath PATH ${d}/sbin $p
		addPath PATH ${d}/bin $p
		addPath MANPATH ${d}/man $p
	fi
done << @EOF
/usr/local head
$HOME/platform/${_sys}${_version}.${_revision} head
$HOME/platform/${_sys}${_version}.${_revision} head
$HOME/platform/${_sys}.${_machine} head
$HOME/platform/${_sys}${_revision} head
$HOME/platform/${_sys} head
$HOME head
/usr
/usr/X11R6
@EOF

addPath MANPATH /usr/share/man

if [ -z "$DISPLAY" -a "$TERM" = "xterm" -a -n "$SSH_CLIENT" ]; then
	DISPLAY=`echo ${SSH_CLIENT%% *}|cut -f4 -d:`:0
	export DISPLAY
	if which xauth >/dev/null 2>&1 ; then
		[ -z "`xauth list $DISPLAY`" ] && \
			xauth add $DISPLAY . 66cfd78b8a1433f05c848087aa39d2ef
	fi
	PS1="\[\e]1;\h\a\]\[\e]2;\u@\h:\w\a\]\[\e[32m\][\!]\u@\h:\[\e[33m\]\w\[\e[0m\]\\$ "
fi

#set screen color
#printf "\033[=1G\033[=7F"
. $HOME/.bash_aliases

# start ssh-agent and add keys if not already running
#if `/usr/bin/ssh-add -l > /dev/null 2>&1` ; then :; else
if [ -z "$SSH_CLIENT" ]; then 
	_SSH_AGENT=$HOME/.ssh-agent
	found="-1"
	if [ -r "$_SSH_AGENT" ]; then
	        . $_SSH_AGENT > /dev/null
	        found=`ps -p "$SSH_AGENT_PID" | wc -l`
	        if [ "$found" -eq 2 ]; then
	                test -S $SSH_AUTH_SOCK
	                found=$?
	                echo Agent pid $SSH_AGENT_PID;
		else
			found=-1
	        fi
	fi

	if [ "$found" = "0" ]; then :; else
		ssh-agent -s > $_SSH_AGENT
		. $_SSH_AGENT
		ssh-add .ssh/StepnetRSA .ssh/StepnetExt .ssh/StepnetExtRSA
	fi

fi

# gpg-agent
#eval `gpg-agent --daemon --enable-ssh-support \
#	--write-env-file "${HOME}/.gpg-agent-info"`

#if [ -f "${HOME}/.gpg-agent-info" ]; then
#	. "${HOME}/.gpg-agent-info"
#	export GPG_AGENT_INFO
#	export SSH_AUTH_SOCK
#	export SSH_AGENT_PID
#fi

GPG_TTY=$(tty)
export GPG_TTY

RSYNC_RSH="ssh -a -x -q"; export RSYNC_RSH

#P4CLIENT=pmai; export P4CLIENT
#P4USER=pmai; export P4USER

CVS_RSH="ssh"; export CVS_RSH
CVSROOT=":ext:agra:/local/nbsdcvs"; export CVSROOT

PYTHONSTARTUP=~/.pythonrc; export PYTHONSTARTUP
AWS_DEFAULT_PROFILE=myaws; export AWS_DEFAULT_PROFILE
complete -C 'aws_completer' aws

