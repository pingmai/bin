alias ls='ls -FCs'
alias cp='cp -pri'
alias rm='rm -i'
alias mv='mv -i'
alias sudo='sudo -E'

function ka() {
	if [ -z "$1" ]; then
		return 1
	fi
	pid=`ps -ef|awk '$1 == "'$USER'" && $6 ~ "'$1'"{print $2}'`
	if [ -n "$pid" ]; then
		kill $pid
	else
		echo "no process $1 owned by $USER"
		return 1
	fi
}

function ntap() {
	if [ -z "$1" -o $1 -lt 0 ]; then
		return 1
	fi
	n=`expr $1 + 10000`
	ssh -p $n pingm@localhost
}

alias NF='ssh -oCompression=yes -oCompressionLevel=9 -Lagra:13390:10.192.24.70:3389 -p 64000 pmai@localhost'
alias NF2='ssh -oCompression=yes -oCompressionLevel=9 -Lagra:13390:10.192.24.70:3389 -p 65000 pmai@localhost'
alias blogic10='ssh -oCompression=yes -oCompressionLevel=9 -p 64000 pmai@localhost'
alias PA='ssh -oCompression=yes -oCompressionLevel=9 -p 64000 localhost'
