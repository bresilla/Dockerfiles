FROM bresilla/basedev
LABEL maintainer="bresilla <trim.bresilla@gmail.com>"
WORKDIR /

RUN apt-get update -y --no-install-recommends && apt-get install -y \
    xorg-dev x11vnc xvfb x11-apps xfonts-base libav-tools\
    libgl1-mesa-dev libglu1-mesa-dev mesa-utils mesa-utils-extra

#Fetch andn install OpenGL and GLVND
#WORKDIR /opt
#RUN git clone https://github.com/KhronosGroup/OpenGL-Registry.git && cd OpenGL-Registry && git checkout 681c365c012ac9d3bcadd67de10af4730eb460e0 && \
#    cp -r api/GL /usr/local/include
#RUN git clone https://github.com/KhronosGroup/EGL-Registry.git && cd EGL-Registry && git checkout 0fa0d37da846998aa838ed2b784a340c28dadff3 && \
#    cp -r api/EGL api/KHR /usr/local/include
#RUN git clone --branch=mesa-17.3.3 --depth=1 https://anongit.freedesktop.org/git/mesa/mesa.git && cd mesa && \
#    cp include/GL/gl.h include/GL/gl_mangle.h /usr/local/include/GL/
#WORKDIR /opt/libglvnd
#RUN git clone --branch=v1.0.0 https://github.com/NVIDIA/libglvnd.git . && \
#    ./autogen.sh && ./configure --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu && \
#    make -j"$(nproc)" install-strip && find /usr/local/lib/x86_64-linux-gnu -type f -name 'lib*.la' -delete
#RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
#    echo '/usr/local/lib/i386-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && ldconfig
#RUN apt-get update && apt-get install -y --no-install-recommends libxau-dev libxdmcp-dev libxcb1-dev libxext-dev libx11-dev
#ENV LD_LIBRARY_PATH /usr/local/lib/x86_64-linux-gnu

# Fetch and install Libjpeg, VirtualGL and TurboVNC and noVNC
WORKDIR /opt
RUN wget https://sourceforge.net/projects/libjpeg-turbo/files/1.5.3/libjpeg-turbo-official_1.5.3_amd64.deb && dpkg -i libj*.deb && rm libj*.deb  
RUN wget https://sourceforge.net/projects/virtualgl/files/2.5.2/virtualgl_2.5.2_amd64.deb && dpkg -i virt*.deb && rm virt*.deb 
RUN wget https://sourceforge.net/projects/turbovnc/files/2.1.1/turbovnc_2.1.1_amd64.deb && dpkg -i turb*.deb && rm turb*.deb
RUN sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver && /opt/VirtualGL/bin/vglserver_config -config +s +f -t
RUN git clone https://github.com/novnc/noVNC /opt/noVNC && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify
ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin:/opt/libjpeg-turbo/bin

# INSTALL WM or DM
RUN apt-get install -y dbus-x11 procps psmisc kmod
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs menu menu-xdg mime-support desktop-file-utils
RUN apt-get install -y --no-install-recommends fortunes mate-applets mate-utils mate-desktop-environment-core
RUN apt-get install -y --no-install-recommends fluxbox wmctrl && apt-get clean && rm -rf /var/lib/apt/lists/*

#Expose VNC and noVNC
EXPOSE 5900 5901 6080

WORKDIR /
COPY index.html /opt/noVNC/index.html
COPY launch.sh /

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,compat32
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"