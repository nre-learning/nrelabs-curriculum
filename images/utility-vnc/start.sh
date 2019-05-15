#!/bin/bash

VNC_PASSWORD=${VNC_PASSWORD:-toto123}
if [ -n "$VNC_PASSWORD" ]; then
    # echo -n "$VNC_PASSWORD" > /.password1
    # x11vnc -storepasswd $(cat /.password1) /.password2
    # chmod 400 /.password*
    # sed -i 's/^command=x11vnc.*/& -rfbauth \/.password2/' /etc/supervisor/conf.d/supervisord.conf
    mkdir -p $HOME/.vnc/
    echo "$VNC_PASSWORD" | /usr/bin/vncpasswd -f > $HOME/.vnc/passwd 
    chmod 664 $HOME/.vnc/passwd

    export VNC_PASSWORD=
fi

exec /bin/tini -- /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
