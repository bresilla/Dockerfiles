FROM bresilla/deep
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

#ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update && apt-get install -y ros-melodic-desktop-full && rosdep init && rosdep update
RUN apt-get -y --quiet --no-install-recommends install python-catkin-tools ros-melodic-mavlink ros-melodic-mavros ros-melodic-mavros-extras
RUN pip3 install -U rosdep rosinstall_generator wstool rosinstall rospkg catkin_pkg empy px4tools pymavlink

#WEBOTS
ARG WEBOTS_URL="https://github.com/omichel/webots/releases/download/R2019a-rev1/webots-R2019a-rev1-x86-64.tar.bz2"
RUN wget ${WEBOTS_URL} -O /tmp/webots.tar.bz2
RUN tar -xvf /tmp/webots.tar.bz2 -C /usr/share && ln -s /usr/share/webots/webots /usr/local/bin

#CARLA
ARG CARLA_URL="https://d3c33hcgiwev3.cloudfront.net/3dXfty7_EemFOA6Hm29iNA_de05a1c02eff11e9821ed19f5bd73b7b_CarlaUE4Ubuntu.tar.gz?Expires=1550880000&Signature=d-xLPabCmGRpi86ejyAaOSA~cUDrAmowKxh7xj5mYRdUELnkuhgMrDs~Qg9opFN0vAWqpkWTz5na89Dnp0g-Ye8TrzFX-9Z0n9074Smmq1EaMqJsh4iSJQQUtFDJ-J0a3sV0ulCpy8gAwTmaZH0ZjyqpRL5Ul1x7SjQihVZM2rQ_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A"
RUN wget ${CARLA_URL} -O /tmp/carla.tar.gz
RUN tar -xzf /tmp/carla.tar.gz && mv CarlaSimulator /opt && ln -s ​/opt/CarlaSimulator/CarlaUE4.sh /usr/local/sbin && pip3 install pygame

#UNITY3D
ARG UNITY_URL="https://beta.unity3d.com/download/6e9a27477296/UnitySetup-2018.3.0f2"
ARG COMPONENTS=Unity,Windows,Windows-Mono,Mac,Mac-Mono,WebGL
RUN apt-get install -qq -y gconf-service lib32gcc1 lib32stdc++6 libasound2 libarchive13 libc6 libc6-i386 \
    libcairo2 libcap2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libfreetype6 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libgl1-mesa-glx \
    libglib2.0-0 libglu1-mesa libgtk2.0-0 libgtk3.0 libnspr4 libnss3 libpango1.0-0 libsoup2.4-1 libstdc++6 \
    libx11-6 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxtst6 zlib1g
RUN wget -nv ${UNITY_URL} -O /tmp/UnitySetup && chmod +x /tmp/UnitySetup
RUN echo y | /tmp/./UnitySetup --unattended --install-location=/opt/Unity \
    --verbose --download-location=/tmp/unity --components=$COMPONENTS && rm /tmp/UnitySetup

#MAVLINK
RUN git clone --depth 1 https://github.com/mavlink/c_library_v2.git /usr/local/include/mavlink/v2.0 && rm -rf /usr/local/include/mavlink/v2.0/.git
RUN apt-get -y --quiet --no-install-recommends install ant geographiclib-tools libgeographic-dev && geographiclib-get-geoids egm96-5
EXPOSE 14556/udp
EXPOSE 14557/udp
EXPOSE 11345

#ENVIRONMENT
ENV PATH="/usr/lib/ccache:$PATH" 
ENV TERM=xterm
ENV QT_X11_NO_MITSHM 1
RUN echo 'source /opt/ros/melodic/setup.bash \nexport CATKIN_PATH=/workdir' >> /root/.bashrc

#CLEAN-UP
#RUN apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log}
RUN rm -rf /tmp/* /var/tmp/* /root/.cache/*
WORKDIR /home/bresilla