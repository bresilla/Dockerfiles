FROM bresilla/deep
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

#USEFUL LIBRARIES
RUN apt-get update -y --no-install-recommends && apt-get -y --quiet --no-install-recommends install ccache default-jre-headless doxygen gosu lcov \
    ninja-build rsync libconsole-bridge-dev libtinyxml-dev liblz4-dev libbz2-dev liburdfdom-dev libpoco-dev libtinyxml2-dev libxml2-utils \
    libtbb2 libtbb-dev libdc1394-22-dev libeigen3-dev python3-sip python3-sip-dev libyaml-cpp-dev libboost-python-dev unzip python-pip libjpeg8-dev \
    libtiff5-dev libjasper-dev libpng12-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libatlas-base-dev libavresample-dev \
    libgphoto2-dev libgstreamer-plugins-base1.0-dev libdc1394-22-dev yasm libprotobuf-dev libgoogle-glog-dev

RUN python -m pip install --upgrade pip==9.0.3 && pip install setuptools wheel && pip install argparse jinja2 empy numpy requests serial toml

# astyle v2.06 
RUN wget -q https://downloads.sourceforge.net/project/astyle/astyle/astyle%202.06/astyle_2.06_linux.tar.gz -O /tmp/astyle.tar.gz \
	&& cd /tmp && tar zxf astyle.tar.gz && cd astyle/src && make -f ../build/gcc/Makefile && cp bin/astyle /usr/local/bin && rm -rf /tmp/*

# Fast-RTPS (real-time Pub-Sub)
RUN wget -q "http://www.eprosima.com/index.php/component/ars/repository/eprosima-fast-rtps/eprosima-fast-rtps-1-5-0/eprosima_fastrtps-1-5-0-linux-tar-gz?format=raw" -O /tmp/eprosima_fastrtps.tar.gz \
	&& cd /tmp && tar zxf eprosima_fastrtps.tar.gz && mkdir -p /usr/local/share/fastrtps && cp eProsima_FastRTPS-1.5.0-Linux/share/fastrtps/fastrtpsgen.jar /usr/local/share/fastrtps/fastrtpsgen.jar \
	&& cp eProsima_FastRTPS-1.5.0-Linux/bin/fastrtpsgen /usr/local/bin/fastrtpsgen && rm -rf /tmp/*

#GAZEBO
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable xenial main" > /etc/apt/sources.list.d/gazebo-stable.list
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get install -y gazebo8 && apt-get install -y libgazebo8-dev

#ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list
RUN echo "deb http://packages.ros.org/ros-shadow-fixed/ubuntu/ xenial main" > /etc/apt/sources.list.d/ros-shadow.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
RUN apt-get update && apt-get install -y ros-kinetic-ros-base && rosdep init && rosdep update

#MAVLINK
RUN git clone --depth 1 https://github.com/mavlink/c_library_v2.git /usr/local/include/mavlink/v2.0 && rm -rf /usr/local/include/mavlink/v2.0/.git

#ROS-TOOLS
RUN apt-get -y --quiet --no-install-recommends install python-catkin-tools ros-kinetic-mavlink ros-kinetic-mavros ros-kinetic-mavros-extras
RUN pip3 install -U rosdep rosinstall_generator wstool rosinstall rospkg catkin_pkg empy px4tools pymavlink

#OPENCV
RUN git clone https://github.com/Itseez/opencv_contrib.git /tmp/opencv_contrib&& cd /tmp/opencv_contrib && git checkout 3.4.0
RUN git clone https://github.com/Itseez/opencv.git /tmp/opencv && cd /tmp/opencv && git checkout 3.4.0

RUN cd /tmp/opencv && mkdir release && cd release && cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D INSTALL_C_EXAMPLES=OFF \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D PYTHON_EXECUTABLE=/usr/bin/python3 \
    -D WITH_OPENGL=ON \
    -D WITH_CUDA=OFF \
    -D WITH_V4L=ON \
    -D WITH_XINE=ON \
    -D WITH_TBB=ON ..
 RUN cd /tmp/opencv/release && make -j $(nproc) && make install

#SOPHUS
RUN git clone https://github.com/strasdat/sophus /tmp/sophus && cd tmp/sophus/ && mkdir build && cd build && cmake .. && make
RUN cd tmp/sophus/build && make install

#GEOLOCATION TOOLS
RUN apt-get -y --quiet --no-install-recommends install ant geographiclib-tools libgeographic-dev &&  geographiclib-get-geoids egm96-5

RUN  wget https://wallpapers.wallhaven.cc/wallpapers/full/wallhaven-662047.jpg -O /usr/share/backgrounds/xfce/wall

#CLEAN-UP
RUN apt-mark hold iptables && apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

ENV PATH="/usr/lib/ccache:$PATH" 
ENV TERM=xterm
ENV QT_X11_NO_MITSHM 1
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

# SITL UDP PORTS 
EXPOSE 14556/udp 
EXPOSE 14557/udp
EXPOSE 11345

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,display
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"