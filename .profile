# $OpenBSD: dot.profile,v 1.4 2005/02/16 06:56:57 matthieu Exp $
#
# sh/ksh initialization

export JAVA_HOME=/usr/local/jdk-1.7.0
PATH=$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
PATH=${PATH}:/usr/ports/infrastructure/bin
PATH=${PATH}:${JAVA_HOME}/bin
export PATH

export PKG_PATH=scp://mike@jupiter.erdelynet.com/home/software/Systems/OpenBSD/systems/jupiter/packages/amd64/
export PKG_PATH=/home/dist/packages/amd64

export CDR_DEVICE=/dev/rcd0c
set -o vi
export EDITOR=vi

export WEBKIT_IGNORE_SSL_ERRORS=1

WIFI=iwn0
WIRED=em0

netstat -nrfinet | grep ^default > /dev/null
if [ $? != 0 ]; then
  echo 'Start up networking with either:'
  echo "	* wifi_home (sudo dhclient $WIFI)"
  echo "	* wifi  (sudo dhclient $WIFI)"
  echo "	* wired (sudo dhclient $WIRED)"
fi

s() {
	X11=""
	FWD=""
	while [ $# -gt 1 ]; do
		case $1 in
			-Y|-X)
				if [ -z "${X11}" ]; then
					X11=" $1"
				else
					echo "Error: Either -X or -Y can be specified once."
					return 1
				fi
				shift
				;;
			-L)
				FWD="${FWD} -L $2"
				shift
				shift
				;;
		esac
	done
	[ "$1" = "" ] && echo "Usage: s [-X|-Y] [-L <port> ] <host>" && return 1
	title=`echo $1 | cut -d. -f1`
	# screen -t "$title" ssh${X11}${FWD} $1
	tmux neww -n "$title" "ssh${X11}${FWD} $1"
}

if [ -f /etc/.post_update ]; then
  cat /etc/.post_update
fi

