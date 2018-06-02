#!/bin/sh

x11vnc -create -env FD_PROG=/usr/bin/mate-session -env X11VNC_FINDDISPLAY_ALWAYS_FAILS=1 -env X11VNC_CREATE_GEOM=${1:-1920x1080x16} -gone 'killall Xvfb' -bg -nopw & opt/noVNC/utils/launch.sh --vnc localhost:5900