FROM bresilla/deep
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

#UPDATE
RUN apt-get update -y --no-install-recommends && apt-get install fzy

# OPENCV
RUN apt-get install -y --no-install-recommends libjpeg-dev libpng-dev libtiff-dev unzip && \
	apt-get install -y --no-install-recommends libavcodec-dev libavformat-dev libswscale-dev libv4l-dev && \
	apt-get install -y --no-install-recommends libxvidcore-dev libx264-dev && \
	apt-get install -y --no-install-recommends libgtk-3-dev && \
	apt-get install -y --no-install-recommends libatlas-base-dev gfortran
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
RUN cd /tmp/opencv/release && make -j $(nproc) && make install 
RUN cd /usr/lib/python3.6/ && ln -s /usr/local/python/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so cv2.so

#ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update && apt-get install -y ros-melodic-desktop-full && rosdep init && rosdep update
RUN apt-get -y --quiet --no-install-recommends install python-catkin-tools ros-melodic-mavlink ros-melodic-mavros ros-melodic-mavros-extras
RUN pip3 install -U rosdep rosinstall_generator wstool rosinstall rospkg catkin_pkg empy px4tools pymavlink

#MAVLINK
RUN git clone --depth 1 https://github.com/mavlink/c_library_v2.git /usr/local/include/mavlink/v2.0 && rm -rf /usr/local/include/mavlink/v2.0/.git
RUN apt-get -y --quiet --no-install-recommends install ant geographiclib-tools libgeographic-dev &&  geographiclib-get-geoids egm96-5

# SITL UDP PORTS 
EXPOSE 14556/udp 
EXPOSE 14557/udp
EXPOSE 11345

#ENVIRONMENT
ENV PATH="/usr/lib/ccache:$PATH" 
ENV TERM=xterm
ENV QT_X11_NO_MITSHM 1
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
RUN echo 'source /opt/ros/melodic/setup.bash \nexport CATKIN_PATH=/workdir' >> /root/.bashrc

#LAST-MINUTE INSTALL
RUN apt-get -y --no-install-recommends fzy

#CLEAN-UP
RUN cd /tmp/ && sudo rm -ri * && mkdir /workdir
WORKDIR /workdir
RUN apt-mark hold iptables && apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*