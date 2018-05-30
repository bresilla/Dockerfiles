FROM bresilla/basedev
LABEL maintainer="bresilla <trim.bresilla@gmail.com>"
WORKDIR /


# Fetch and install Visual Studio Code
RUN curl https://az764295.vo.msecnd.net/stable/929bacba01ef658b873545e26034d1a8067445e9/code_1.18.1-1510857349_amd64.deb -o code.deb && \ dpkg -i code.deb && \ rm code.deb # Fetch and install Android Studio and dependencies # https://developer.android.com/studio/install.html # https://stackoverflow.com/questions/29112107/how-to-solve-unable-to-run-mksdcard-sdk-tool-when-installing-android-studio-on RUN curl https://dl.google.com/dl/android/studio/ide-zips/3.0.1.0/android-studio-ide-171.4443003-linux.zip -o android.zip && \
    echo 'Unzipping...' && unzip -q android.zip -d /opt && \
    rm android.zip

# Fetch and install VirtualGL
RUN wget https://sourceforge.net/projects/virtualgl/files/2.5.2/virtualgl_2.5.2_amd64.deb/download -O vgl.deb && \ dpkg -i vgl.deb && \ rm vgl.deb # Fetch and install TurboVNC RUN wget https://sourceforge.net/projects/turbovnc/files/2.1.1/turbovnc_2.1.1_amd64.deb/download -O tvnc.deb && \
    dpkg -i tvnc.deb && \
    rm tvnc.deb

# Fetch and install noVNC
RUN git clone https://github.com/novnc/noVNC /opt/noVNC && \ git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify

# Fetch and install NoMachine. See https://www.nomachine.com/DT08M00100
RUN curl http://download.nomachine.com/download/6.0/Linux/nomachine_6.0.78_1_amd64.deb -o nomachine.deb && \ echo "3645673090788ea0b2a3f664bb71a7dd *nomachine.deb" | md5sum -c && \ dpkg -i nomachine.deb && \ rm nomachine.deb # Clean RUN apt-get clean && \ apt-get autoremove && \ rm -r /var/lib/apt/lists/* 

# Install X server staff
RUN apt-get install -y x11vnc xvfb fluxbox wmctrl && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* 

#Expose VNC
EXPOSE 5900