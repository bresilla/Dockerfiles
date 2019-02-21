FROM bresilla/deep
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

# OPENCV
RUN apt-get install -y --no-install-recommends libjpeg-dev libpng-dev libtiff-dev unzip && \
	apt-get install -y --no-install-recommends libavcodec-dev libavformat-dev libswscale-dev libv4l-dev && \
	apt-get install -y --no-install-recommends libxvidcore-dev libx264-dev libgtk-3-dev libatlas-base-dev
RUN git clone https://github.com/Itseez/opencv_contrib.git /tmp/opencv_contrib&& cd /tmp/opencv_contrib && git checkout 4.0.0
RUN git clone https://github.com/Itseez/opencv.git /tmp/opencv && cd /tmp/opencv && git checkout 4.0.0
RUN cd /tmp/opencv && mkdir release && cd release && cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D PYTHON_EXECUTABLE=/usr/bin/python3 \
    -D BUILD_EXAMPLES=ON \
	-D OPENCV_ENABLE_NONFREE=ON \
    -D WITH_OPENGL=ON \
    -D WITH_CUDA=ON \
    -D WITH_V4L=ON \
    -D WITH_XINE=ON \
    -D WITH_TBB=ON ..
RUN cd /tmp/opencv/release && make -j $(nproc) && make install && cd /
RUN ln -s /usr/local/python/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so /usr/lib/python3.6/cv2.so
RUN apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* /root/.cache/*

#ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update && apt-get install -y ros-melodic-desktop-full && rosdep init && rosdep update
RUN apt-get -y --quiet --no-install-recommends install python-catkin-tools ros-melodic-mavlink ros-melodic-mavros ros-melodic-mavros-extras
RUN pip3 install -U rosdep rosinstall_generator wstool rosinstall rospkg catkin_pkg empy px4tools pymavlink

#MAVLINK
RUN git clone --depth 1 https://github.com/mavlink/c_library_v2.git /usr/local/include/mavlink/v2.0 && rm -rf /usr/local/include/mavlink/v2.0/.git
RUN apt-get -y --quiet --no-install-recommends install ant geographiclib-tools libgeographic-dev && geographiclib-get-geoids egm96-5
EXPOSE 14556/udp 
EXPOSE 14557/udp
EXPOSE 11345

#WEBOTS
RUN wget https://github.com/omichel/webots/releases/download/R2019a-rev1/webots-R2019a-rev1-x86-64.tar.bz2 -O /tmp/webots.tar.bz2
RUN tar -xvf /tmp/webots.tar.bz2 -C /usr/share && ln -s /usr/share/webots/webots /usr/local/bin

#CARLA
RUN wget 'https://d3c33hcgiwev3.cloudfront.net/3dXfty7_EemFOA6Hm29iNA_de05a1c02eff11e9821ed19f5bd73b7b_CarlaUE4Ubuntu.tar.gz?Expires=1550880000&Signature=d-xLPabCmGRpi86ejyAaOSA~cUDrAmowKxh7xj5mYRdUELnkuhgMrDs~Qg9opFN0vAWqpkWTz5na89Dnp0g-Ye8TrzFX-9Z0n9074Smmq1EaMqJsh4iSJQQUtFDJ-J0a3sV0ulCpy8gAwTmaZH0ZjyqpRL5Ul1x7SjQihVZM2rQ_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A' -O /tmp/carla.tar.gz
RUN tar -xzf /tmp/carla.tar.gz && mv CarlaSimulator /opt && ln -s ​/opt/CarlaSimulator/CarlaUE4.sh /usr/local/sbin && pip3 install pygame

#ENVIRONMENT
ENV PATH="/usr/lib/ccache:$PATH" 
ENV TERM=xterm
ENV QT_X11_NO_MITSHM 1
RUN echo 'source /opt/ros/melodic/setup.bash \nexport CATKIN_PATH=/workdir' >> /root/.bashrc

#LAST-MINUTE INSTALL
RUN apt-get install -y --no-install-recommends ncdu fzy

#CLEAN-UP
RUN apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/* /root/.cache/*
RUN mkdir /home/bresilla/.config && chown -R bresilla:bresilla /home/bresilla/.config && mkdir /home/bresilla/workplace