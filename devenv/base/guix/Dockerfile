FROM bresilla/base
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

# xhost +si:localuser:root
# openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem
# docker build -t turbovnc .
# docker run --init --runtime=nvidia --name=turbovnc --rm -i -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -p 5901:5901 turbovnc
# docker exec -ti turbovnc vglrun glxspheres64

WORKDIR /

ARG TURBOVNC_VERSION=2.1.2
ARG VIRTUALGL_VERSION=2.5.2
ARG LIBJPEG_VERSION=1.5.2
ARG WEBSOCKIFY_VERSION=0.8.0
ARG NOVNC_VERSION=1.0.0-beta

ENV DEBIAN_FRONTEND noninteractive 

RUN apt-get update -y --no-install-recommends && apt-get -y --quiet install dbus-x11 procps psmisc kmod && \
    apt-get -y --quiet install xvfb x11vnc xserver-xorg xinit module-init-tools mesa-utils mesa-utils-extra && \
    apt-get -y --quiet install libglu1 libxv1 libgl1-mesa-dev libglu1-mesa-dev libxv-dev libxrender1 libxext6 \
    libsm6 libjpeg-turbo8 libjpeg-turbo8-dev libxt-dev x11-xkb-utils xauth libpam0g-dev && \
    apt-get -y --quiet install libxcursor-dev xfonts-base xkb-data firefox terminator 
 
# Fetch and install TurboVNC, VirtualGL, LibJPEG
RUN cd /tmp && curl -fsSL -O https://svwh.dl.sourceforge.net/project/turbovnc/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i *.deb && rm -f /tmp/*.deb && sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver
ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin
RUN echo 'no-remote-connections\n no-httpd\n no-x11-tcp-connections\n no-pam-sessions\n permitted-security-types = otp,tlsnone,x509none,none' \
    >> /etc/turbovncserver-security.conf

# Fetch and install noVNC
RUN curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt && \
    mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html && cd /opt/noVNC/utils/websockify && make

# INSTALL WM or DM
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs menu menu-xdg mime-support desktop-file-utils feh
RUN apt-get install -y --no-install-recommends xfce4 xfce4-goodies
RUN add-apt-repository -y ppa:gusbemacbe/ppa && apt-get update && apt-get install -y --no-install-recommends suru-plus-pack \
    && rm -r "Dark'" "Lubuntu'" "'Suru++" "'Suru++'" "Telinkrin'" "United'" "Walls'"
RUN add-apt-repository -y ppa:dyatlov-igor/materia-theme && apt-get update && apt-get install -y --no-install-recommends materia-gtk-theme
RUN  wget https://1drv.ms/u/s!AqM4RXzOdEqwi58De-1vGZc7q212eQ -O /usr/share/backgrounds/xfce/bresilla
RUN mkdir -p /root/.vnc/ && echo '#!/bin/sh \nunset SESSION_MANAGER \nunset DBUS_SESSION_BUS_ADDRESS \nstartxfce4 &' \
    >> /root/.vnc/xstartup.turbovnc && chmod a+x /root/.vnc/xstartup.turbovnc

#CLEAN-UP
RUN apt-get install -y --no-install-recommends pciutils
RUN apt-mark hold iptables && apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

#MAKE START SCRIPT
RUN echo '#!/bin/bash\n /opt/TurboVNC/bin/vncserver -3dwm -securitytypes tlsnone,x509none,none && /opt/noVNC/utils/launch.sh --vnc localhost:5900' \
    >> /usr/local/sbin/start && chmod a+x /usr/local/sbin/start

RUN echo '#!/bin/bash\n /opt/noVNC/utils/websockify/run 5900 --cert=/self.pem --ssl-only --web=/opt/noVNC && /opt/TurboVNC/bin/vncserver -3dwm -securitytypes tlsnone,x509none,none' \
    >> /usr/local/sbin/launch && chmod a+x /usr/local/sbin/launch

#EXPOSE VNC and noVNC
EXPOSE 5900 5901 6080 40001

#ENV VARIABLES
ENV DEBIAN_FRONTEND newt
ENV DISPLAY :1

ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"