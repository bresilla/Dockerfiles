#FROM bresilla/basedev
FROM bresilla/basegui
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"
WORKDIR /

# Installig some needed tools
RUN apt-get update -y --no-install-recommends && apt-get -y --no-install-recommends --quiet install openmpi-bin openmpi-doc libopenmpi-dev \
	ffmpeg qtbase5-dev libqt5opengl5-dev libassimp-dev libpython3.5-dev libboost-python-dev libtinyxml-dev libav-tools

# Install DEEP-LEARNING libraries
RUN pip3 install tensorflow-gpu
RUN pip3 install http://download.pytorch.org/whl/cu90/torch-0.4.0-cp35-cp35m-linux_x86_64.whl torchvision
RUN pip3 install chainer cupy-cuda90 && pip3 install chainermn chainerrl chainercv 
RUN pip3 install cntk-gpu
RUN pip3 install mxnet-cu90
RUN pip3 install https://github.com/Lasagne/Lasagne/archive/master.zip
RUN pip3 install theano keras onnx

# Installing OpenAI Gym
RUN pip3 install gym gym[atari] tqdm 

# Installing roboschool and bulletphysics
WORKDIR /gym
ENV ROBOSCHOOL_PATH="/gym/roboschool"
RUN git clone https://github.com/openai/roboschool && git clone https://github.com/olegklimov/bullet3 -b roboschool_self_collision && \
	mkdir bullet3/build && cd bullet3/build && cmake -DBUILD_SHARED_LIBS=ON -DUSE_DOUBLE_PRECISION=1 -DCMAKE_INSTALL_PREFIX:PATH=$ROBOSCHOOL_PATH/roboschool/cpp-household/bullet_local_install -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF -DBUILD_EXTRAS=OFF  -DBUILD_UNIT_TESTS=OFF -DBUILD_CLSOCKET=OFF -DBUILD_ENET=OFF -DBUILD_OPENGL3_DEMOS=OFF .. && \
	make -j4 && make install
WORKDIR /gym/roboschool
RUN	pip3 install -e ./

#DELETE NEXT BUILD
RUN apt-get install -y --no-install-recommends iptables

#CLEAN-UP
RUN apt-mark hold iptables && apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# TensorBoard IPython
EXPOSE 6006 8888

WORKDIR /

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,display
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"