FROM bresilla/guix
LABEL maintainer="bresilla <bresilla.bresilla@gmail.com>"

#UPDATE
RUN apt-get install -y --no-install-recommends python3-dev python-dev python3-distutils python-pyglet python3-opengl

# Install DEEP-LEARNING libraries
RUN pip3 install https://download.pytorch.org/whl/cu100/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl torchvision
RUN pip3 install chainer cupy-cuda100 && pip3 install chainerrl chainercv 
RUN pip3 install keras onnx
RUN pip3 install tf-nightly-gpu

# TensorBoard & IPython
EXPOSE 6006 8888

# OPENAI
RUN apt-get install -y --no-install-recommends libopenmpi-dev zlib1g-dev libjpeg-dev swig  libboost-all-dev libsdl2-dev libosmesa6-dev  

#CLEAN-UP
RUN apt-get install -y --no-install-recommends iptables qt5-default
RUN apt-mark hold iptables && apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*