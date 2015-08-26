# auto tmux
if [ -z $OS ]; then
    if [ -z $EMACS ]; then
	    if which tmux 2>&1 >/dev/null; then
	        test -z "$TMUX" && (tmux attach || tmux new-session)
	    fi
    fi
fi
