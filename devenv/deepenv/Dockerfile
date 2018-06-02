#FROM bresilla/basedev
FROM bresilla/basegui
LABEL maintainer="bresilla <trim.bresilla@gmail.com>"
WORKDIR /

# Install DEEP-LEARNING libraries
RUN pip3 install tensorflow-gpu
RUN pip3 install http://download.pytorch.org/whl/cu90/torch-0.4.0-cp35-cp35m-linux_x86_64.whl torchvision
RUN pip3 install chainer cupy-cuda90 
RUN pip3 install keras

# Installig some needed tools
RUN sudo apt-get update && \
	apt-get install -y --no-install-recommends ffmpeg qtbase5-dev libqt5opengl5-dev libassimp-dev libpython3.5-dev libboost-python-dev libtinyxml-dev \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* 

# Installing OpenAI Gym
RUN pip3 install gym gym[atari]  

# Installing roboschool
WORKDIR /gym
ENV ROBOSCHOOL_PATH="/gym/roboschool"
# Installing bullet (the physics engine of roboschool)
RUN git clone https://github.com/openai/roboschool && \
	git clone https://github.com/olegklimov/bullet3 -b roboschool_self_collision && \
	mkdir bullet3/build && \
	cd    bullet3/build && \
	cmake -DBUILD_SHARED_LIBS=ON -DUSE_DOUBLE_PRECISION=1 -DCMAKE_INSTALL_PREFIX:PATH=$ROBOSCHOOL_PATH/roboschool/cpp-household/bullet_local_install -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF -DBUILD_EXTRAS=OFF  -DBUILD_UNIT_TESTS=OFF -DBUILD_CLSOCKET=OFF -DBUILD_ENET=OFF -DBUILD_OPENGL3_DEMOS=OFF .. && \
	make -j4 && \
	make install
WORKDIR /gym/roboschool
RUN	pip3 install -e ./

RUN sudo apt-get update && \
	apt-get install --no-install-recommends -y firefox mate-terminal \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN pip3 install tqdm

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888

WORKDIR /

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,compat32
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"