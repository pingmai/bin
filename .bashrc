# are we interactive?
if [ `tty > /dev/null 2>&1` ] ; then :; else
	#PS1="\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[32m\]\\$\[\e[0m\] "
	PS1="\[\e]1;\h\a\]\[\e]2;\u@\h:\w\a\]\[\e[32m\]\u@\h [\!]\[\e[33m\]\w\[\e[0m\]\\$ "
	. $HOME/.bash_aliases
	. $HOME/.bash_profile
fi
