FROM bresilla/basedev:gl
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

# openssl req -new -x509 -days 365 -nodes -out self.pem -keyout self.pem
# docker build -t turbovnc .
# docker run --init --runtime=nvidia --name=turbovnc --rm -i -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 -p 5901:5901 turbovnc
# docker exec -ti turbovnc vglrun glxspheres64

WORKDIR /

RUN apt-get update -y --no-install-recommends && apt-get install -y \
	libglib2.0-0 libxext6 libsm6 libxrender1 libpython-dev libsuitesparse-dev \
    libeigen3-dev libsdl1.2-dev doxygen graphviz libignition-math2-dev libglu1 libxv1 \
    mesa-utils python python-numpy x11-xkb-utils xauth xfonts-base xkb-data \
    dbus-x11 procps psmisc kmod

# Fetch and install TurboVNC, VirtualGL, LibJPEG and NoVNC
ENV TURBOVNC_VERSION=2.1.2 VIRTUALGL_VERSION=2.5.2 LIBJPEG_VERSION=1.5.2 WEBSOCKIFY_VERSION=0.8.0 NOVNC_VERSION=1.0.0-beta
RUN cd /tmp && curl -fsSL \
    -O https://svwh.dl.sourceforge.net/project/turbovnc/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
    -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i *.deb && rm -f /tmp/*.deb && sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver && \
    curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt && \
    mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify && \
    ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html && cd /opt/websockify && make
ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin
RUN echo 'no-remote-connections\n no-httpd\n no-x11-tcp-connections\n no-pam-sessions\n permitted-security-types = otp' > /etc/turbovncserver-security.conf

# INSTALL WM or DM
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs menu menu-xdg mime-support desktop-file-utils
RUN apt-get install -y --no-install-recommends fortunes mate-applets mate-utils mate-desktop-environment-core mate-terminal
RUN apt-get install -y --no-install-recommends fluxbox wmctrl firefox && apt-get clean && rm -rf /var/lib/apt/lists/*

#Expose VNC and noVNC
EXPOSE 5900 5901 6080 40001

COPY index.html /opt/noVNC/index.html
COPY self.pem /
COPY launch.sh /

ENV DISPLAY :1
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,display
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"