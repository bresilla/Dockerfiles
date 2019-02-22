FROM bresilla/base
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

RUN apt-get update -y --no-install-recommends && apt-get -y --quiet install dbus-x11 procps psmisc kmod dirmngr && \
    apt-get -y --quiet install xvfb x11vnc xserver-xorg xserver-xorg-video-dummy xinit mesa-utils mesa-utils-extra && \  
    apt-get -y --quiet install libglu1 libxv1 libxv-dev libxrender1 libxext6 libsm6 libxt-dev xfonts-base qt5-default

ARG TURBOVNC_VERSION=2.2
ARG VIRTUALGL_VERSION=2.6
ARG LIBJPEG_VERSION=2.0.0

# Fetch and install TurboVNC, VirtualGL, LibJPEG
RUN cd /tmp && curl -fsSL -O https://svwh.dl.sourceforge.net/project/turbovnc/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i *.deb && rm -f /tmp/*.deb && sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver
ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin
RUN echo 'no-remote-connections\n no-httpd\n no-x11-tcp-connections\n no-pam-sessions\n permitted-security-types = otp,tlsnone,x509none,none' \
    >> /etc/turbovncserver-security.conf

ARG WEBSOCKIFY_VERSION=0.8.0
ARG NOVNC_VERSION=1.0.0

# Fetch and install noVNC
RUN curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt && \
    mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/noVNC/utils/websockify && \
    ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html && cd /opt/noVNC/utils/websockify && make

# INSTALL WM or DM
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs menu menu-xdg mime-support desktop-file-utils feh
RUN apt-get install -y --no-install-recommends xfce4 xfce4-goodies firefox terminator rxvt-unicode-256color
RUN wget -qO- https://raw.githubusercontent.com/gusbemacbe/suru-plus/master/install.sh | sh
RUN add-apt-repository -y ppa:dyatlov-igor/materia-theme && apt-get update && apt-get install -y --no-install-recommends materia-gtk-theme
RUN mkdir -p /root/.vnc/ && echo '#!/bin/sh \nunset SESSION_MANAGER \nunset DBUS_SESSION_BUS_ADDRESS \nstartxfce4 &' \
    >> /root/.vnc/xstartup.turbovnc && chmod a+x /root/.vnc/xstartup.turbovnc

#EXPOSE VNC and noVNC
EXPOSE 5900 5901 6080 40001

#ENV VARIABLES
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"

#MAKE START SCRIPT
RUN echo '#!/bin/bash\n /opt/TurboVNC/bin/vncserver -3dwm -securitytypes tlsnone,x509none,none && /opt/noVNC/utils/launch.sh --vnc localhost:5900' \
    >> /usr/local/sbin/start && chmod a+x /usr/local/sbin/start

#CLEAN-UP
#RUN apt-get autoremove -y && apt-get clean autoclean && rm -rif /var/lib/apt/lists/{apt,dpkg,cache,log}
RUN rm -rf /tmp/* /var/tmp/* /root/.cache/*