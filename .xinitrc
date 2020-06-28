#!/bin/sh
# $OpenBSD: xinitrc.cpp,v 1.10 2013/05/19 07:22:53 ajacoutot Exp $

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# if we have private ssh key(s), start ssh-agent and add the key(s)
id1=$HOME/.ssh/identity
id2=$HOME/.ssh/id_dsa
id3=$HOME/.ssh/id_rsa
id4=$HOME/.ssh/id_ecdsa
id5=$HOME/.ssh/id_ed25519

if [ -z "$SSH_AGENT_PID" ];
then
 if [ -x /usr/bin/ssh-agent ] && [ -f $id1 -o -f $id2 -o -f $id3 -o -f $id4 -o -f $id5 ];
 then
  eval `ssh-agent -s`
  ssh-add < /dev/null
  ssh-add $HOME/.ssh/id_ms < /dev/null
 fi
fi

# if dbus is installed, start its daemon
if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
 eval `dbus-launch --sh-syntax --exit-with-session`
fi

# start some nice programs
. ${HOME}/.profile > /dev/null
xsetroot -solid steelblue

for dir in /usr/local/share/fonts/*; do
 [ -d $dir ] && xset fp+ $dir 2> /dev/null
done

if [ -d /usr/local/share/fonts/powerline ]; then
 for dir in /usr/local/share/fonts/powerline/*; do
  [ -d $dir ] && xset fp+ $dir 2> /dev/null
 done
fi

if [ -x /usr/local/bin/xscreensaver ]; then
 xscreensaver -nosplash &
 [ -x ~/bin/xscreensaver-sshkey ] && ~/bin/xscreensaver-sshkey
else
 exec xidle -timeout 3600 &
fi

[ -x /usr/local/bin/bgs -a -f ~/Holly.jpg ] && bgs ~/Holly.jpg
[ -x /usr/local/bin/unclutter ] && unclutter &
[ -x /usr/local/bin/autocutsel ] && autocutsel &
[ -x /usr/local/bin/xstatbar ] && xstatbar -w 1600 -f -misc-fixed-medium-r-normal--10-70-100-100-c-60-iso8859-1 &

urxvt -geometry 199x67+0-0 &

cwm || fvwm || xterm

if [ "$SSH_AGENT_PID" ]; then
 ssh-add -D < /dev/null
 eval `ssh-agent -s -k`
fi
