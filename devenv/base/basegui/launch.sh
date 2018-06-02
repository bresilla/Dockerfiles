#!/bin/sh

#x11vnc -create -env FD_PROG=/usr/bin/mate-session -env X11VNC_FINDDISPLAY_ALWAYS_FAILS=1 -env X11VNC_CREATE_GEOM=${1:-1920x1080x16} -gone 'killall Xvfb' -bg -nopw & opt/noVNC/utils/launch.sh --vnc localhost:5900

if [ "$(ls -A /root/.vnc/)" ]; then
lse
fi


if [ ! -f /root/.vnc/xstartup.turbovnc ]; then
    mkdir -p /root/.vnc/ && echo '#!/bin/sh\n xsetroot -solid grey\n /usr/bin/mate-session &' >> /root/.vnc/xstartup.turbovnc && chmod a+x /root/.vnc/xstartup.turbovnc
else
    chmod -f 777 /tmp/.X11-unix
    touch ~/.Xauthority && xauth generate :0 . trusted
    /opt/TurboVNC/bin/vncserver -SecurityTypes None
    /opt/noVNC/utils/launch.sh --vnc localhost:5901 --cert /self.pem --listen 40001
fi
