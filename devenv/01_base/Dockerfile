FROM nvidia/cudagl:10.0-runtime
LABEL maintainer="bresilla <trim.bresilla@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive 
ENV CUDNN_VERSION 7.4.2.24
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
            libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*

# PRE-INSTALL
RUN apt-get update -y --no-install-recommends && \ 
	apt-get install -y --no-install-recommends software-properties-common && \
	apt-get install -y --no-install-recommends apt-utils && \ 
	apt-get install -y --no-install-recommends pkg-config debconf dpkg && \
	apt-get install -y --no-install-recommends locales

# REGION
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8   

# CORE STAFF
RUN apt-get install -y --no-install-recommends \
	build-essential cmake automake libpq-dev libffi-dev gfortran gdb sudo git wget curl iptables ninja-build \
	python python-pip python3 python3-pip python3-tk libtool libboost-program-options-dev protobuf-compiler patchelf ffmpeg\
	libpython-dev ca-certificates libglib2.0-0 libeigen3-dev xz-utils pciutils && apt-get clean

RUN apt install -y --no-install-recommends fish vim openssh-server openssl tmux ranger net-tools locales bzip2 python3-wheel python3-setuptools 

# PIPing
RUN python3 -m pip install --upgrade && pip3 install cython pylint numpy matplotlib scipy pandas jupyter jupyterthemes && \
	pip3 install seaborn scikit-learn scikit-Image sympy patsy keras statsmodels cloudpickle dill numba bokeh pyopengl pyvirtualdisplay
RUN python -m pip install --upgrade && pip install setuptools wheel && pip install argparse jinja2 empy numpy requests serial toml

# ADDING USER
ARG USER=bresilla
ARG GROUP=bresilla
ARG UID=1000
ARG GID=1000
RUN groupadd --gid ${GID} ${GROUP} && \ 
	useradd --uid ${UID} --gid ${GID} --shell /bin/bash --create-home --home /home/${USER} ${USER}
RUN echo "${USER}:x:${UID}:${GID}:${USER},,,:/home/${USER}:/bin/bash" >> /etc/passwd && \
    echo "${USER}:x:${UID}:" >> /etc/group && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER} && \
    chown $UID:${GID} -R /home/${USER}
RUN mkdir /home/bresilla/.config && chown -R bresilla:bresilla /home/bresilla/.config

#WORKDIR
RUN mkdir /workdir

#CLEAN-UP
RUN apt-mark hold iptables && apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*