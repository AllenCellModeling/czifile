# From pytorch compiled from source
FROM dockcross/manylinux-x64:latest

RUN yum install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 cmake screen tmux libtiff5-dev \
    git software-properties-common build-essential 

RUN cd ~ && \
    git clone https://github.com/AllenCellModeling/czifile.git && \
    cd czifile && \
    git checkout hotfix && \
    git submodule update --init czifile/libjpeg && \
    git submodule update --init czifile/libjxr 

RUN cd ~/czifile/czifile/libjpeg && \
    export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:${LD_LIBRARY_PATH} && \
    ./configure && \
    make && \
    make install


RUN cd ~/czifile/czifile/libjxr && \
    git checkout master && \
    git pull && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make && \
    make install 

RUN cd ~/czifile && \
    pip install setuptools && \
    pip install tifffile && \
    python ./setup.py build && \
    python ./setup.py install 



WORKDIR "/root"

