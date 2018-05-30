FROM nvidia/cuda:9.0-cudnn7-devel
#FROM ubuntu:latest
LABEL maintainer="bresilla <trim.bresilla@gmail.com>"
WORKDIR /

# CORE STAFF
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y --no-install-recommends && \ 
	apt-get install -y --no-install-recommends software-properties-common && \
	apt-get install -y --no-install-recommends apt-utils && \ 
	apt-get install -y --no-install-recommends \ 
	build-essential \
	cmake \
	pkg-config \
	automake \ 
	libpq-dev \ 
	libffi-dev \ 
	gfortran \ 
	gdb \
	sudo \
	git \ 
	libboost-program-options-dev \ 
	libtool \ 
	libxrender1 \ 
	wget \ 
	ca-certificates \
	python3 \
	python3-pip \
	curl && \
	apt install -y --no-install-recommends \
	fish \
	vim \
	openssh-server \
	tmux \
	ranger \
	net-tools \
	locales \
	bzip2 \
	python3-wheel \ 
	python3-setuptools && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# PIPing
RUN pip3 install \
	cython \
	pylint \
	numpy \
	matplotlib \
	scipy \
	pandas \
	jupyter && pip3 install \
	seaborn \
	scikit-learn \
	scikit-Image \
	sympy \
	patsy \
	keras \
	statsmodels \
	cloudpickle \
	dill \
	numba \
	bokeh \
	pyopengl \
	pyvirtualdisplay

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


# CLEANUP
RUN apt-get clean && \
        rm -rf /var/lib/apt/lists/* 

# IPython
EXPOSE 8888