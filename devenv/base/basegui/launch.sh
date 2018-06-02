#!/bin/sh

#x11vnc -create -env FD_PROG=/usr/bin/mate-session -env X11VNC_FINDDISPLAY_ALWAYS_FAILS=1 -env X11VNC_CREATE_GEOM=${1:-1920x1080x16} -gone 'killall Xvfb' -bg -nopw & opt/noVNC/utils/launch.sh --vnc localhost:5900

/opt/websockify/run 5901 --cert=/self.pem --ssl-only --web=/opt/noVNC --wrap-mode=ignore &
vncserver :1 -securitytypes otp -otp -noxstartup &
chmod -f 777 /tmp/.X11-unix
touch ~/.Xauthority && xauth generate :0 . trusted
/opt/TurboVNC/bin/vncserver -SecurityTypes None
/opt/noVNC/utils/launch.sh --vnc localhost:5901 --cert /self.pem --listen 40001