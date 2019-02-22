FROM bresilla/guix
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

#UPDATE
RUN apt-get install -y --no-install-recommends python3-dev python-dev python3-distutils python-pyglet python3-opengl

# Install DEEP-LEARNING libraries
RUN pip3 install https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl torchvision
RUN pip3 install chainer cupy-cuda100 && pip3 install chainerrl chainercv 
RUN pip3 install keras onnx fastai
RUN pip3 install tf-nightly-gpu

# TensorBoard & IPython
EXPOSE 6006 8888

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

# OPENAI
RUN apt-get install -y --no-install-recommends libopenmpi-dev zlib1g-dev libjpeg-dev swig  libboost-all-dev libsdl2-dev libosmesa6-dev  

#CLEAN-UP
#RUN apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} 
RUN rm -rf /tmp/* /var/tmp/* /root/.cache/*