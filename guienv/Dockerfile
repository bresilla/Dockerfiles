FROM bresilla/cudann
LABEL maintainer="bresilla <trim.bresilla@gmail.com>"
WORKDIR /

# Install X server staff
RUN apt-get install -y x11vnc xvfb fluxbox wmctrl && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* 

#Expose VNC
EXPOSE 5900