FROM nvidia/cuda:9.0-cudnn7-devel
LABEL maintainer="bresilla <trim.bresilla@gmail.com>"
WORKDIR /

# CORE STAFF
RUN apt-get update && apt install -y --no-install-recommends \
	build-essential \
	cmake \
	gcc \
	g++ \
	git \
	python3-pip \
	python3 \
	python3-setuptools \
	fish \
	tmux \
	ranger

# PIPing
RUN pip3 install \
	jupyter \
	setuptools \
	cython \
	pandas \
	matplotlib \
	scipy \
	pyvirtualdisplay \
	seaborn \
	scikit-learn \
	scikit-Image \
	sympy \
	cython \
	patsy \
	pylint \
	statsmodels \
	cloudpickle \
	wheel \
	dill \
	numba \
	bokeh

# ADDING USER
RUN useradd -ms /bin/bash bresilla
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/bresilla && \
    echo "bresilla:x:${uid}:${gid}:bresilla,,,:/home/bresilla:/bin/bash" >> /etc/passwd && \
    echo "bresilla:x:${uid}:" >> /etc/group && \
    echo "bresilla ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/bresilla && \
    chmod 0440 /etc/sudoers.d/bresilla && \
    chown ${uid}:${gid} -R /home/bresilla


# CLEANUP
RUN apt-get clean && \
        rm -rf /var/lib/apt/lists/* 

# IPython
EXPOSE 8888