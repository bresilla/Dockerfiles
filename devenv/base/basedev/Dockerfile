FROM nvidia/cudagl:9.0-devel
#FROM ubuntu:16.04
LABEL maintainer="bresilla <trim.bresilla@gmail.com>"
WORKDIR /

# CUDNN Libraries
ENV NCCL_VERSION 2.2.12
ENV CUDNN_VERSION 7.1.4.18
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-libraries-$CUDA_PKG_VERSION libnccl2=$NCCL_VERSION-1+cuda9.0 \
        libcudnn7=$CUDNN_VERSION-1+cuda9.0 libcudnn7-dev=$CUDNN_VERSION-1+cuda9.0

# CORE STAFF
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends && \ 
	apt-get install -y --no-install-recommends software-properties-common && \
	apt-get install -y --no-install-recommends apt-utils && \ 
	apt-get install -y --no-install-recommends pkg-config debconf dpkg && \
	apt-get install -y --no-install-recommends \ 
	build-essential cmake automake libpq-dev libffi-dev gfortran gdb sudo git wget curl iptables \
	python3 python3-pip python3-tk libtool python python-numpy libboost-program-options-dev protobuf-compiler\
	libpython-dev ca-certificates libglib2.0-0 libeigen3-dev xz-utils pciutils && apt-get clean

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends && \ 
	apt install -y --no-install-recommends fish vim openssh-server openssl \
	tmux ranger net-tools locales bzip2 python3-wheel python3-setuptools 

# PIPing
RUN pip3 install cython pylint numpy matplotlib	scipy pandas jupyter && \
	pip3 install seaborn scikit-learn scikit-Image sympy patsy keras \
	statsmodels cloudpickle dill numba bokeh pyopengl pyvirtualdisplay

#CLEAN-UP
RUN apt-mark hold iptables && apt-get autoremove -y && apt-get clean autoclean && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8    

# ADDING USER
ARG USER=bresilla
ARG GROUP=bresilla
ARG UID=1000
ARG GID=1000

RUN groupadd --gid ${GID} ${GROUP} && \ 
	useradd --uid ${UID} --gid ${GID} --shell /bin/bash --create-home --home /home/${USER} ${USER}
RUN echo "${USER}:x:${UID}:${GID}:${USER},,,:/home/${USER}:/bin/bash" >> /etc/passwd && \
    echo "${USER}:x:${UID}:" >> /etc/group && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER} && \
    chown $UID:${GID} -R /home/${USER}