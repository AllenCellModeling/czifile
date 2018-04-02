# From pytorch compiled from source
FROM ubuntu:trusty

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 cmake screen tmux libtiff5-dev \
    git software-properties-common && \
    apt-get clean

# RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
#     echo "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-5.0 main" >> /etc/apt/sources.list && \
#     echo "deb-src http://apt.llvm.org/trusty/ llvm-toolchain-trusty-5.0 main" >> /etc/apt/sources.list && \
#     wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
#     apt-get update && \
#     apt-get install -y apt-get install clang-5.0 clang-tools-5.0 clang-5.0-doc && \
#     apt-get install -y libclang-common-5.0-dev libclang-5.0-dev libclang1-5.0 && \
#     apt-get install -y libclang1-5.0-dbg libllvm-5.0-ocaml-dev libllvm5.0 && \
#     apt-get install -y libllvm5.0-dbg lldb-5.0 llvm-5.0 llvm-5.0-dev llvm-5.0-doc && \
#     apt-get install -y llvm-5.0-examples llvm-5.0-runtime clang-format-5.0 && \
#     apt-get install -y python-clang-5.0 libfuzzer-5.0-dev

RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh  -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc 

RUN conda activate base

COPY jupyter_notebook_config.py /root/.jupyter/

RUN conda install nodejs

RUN pip install npm 

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

RUN mkdir -p /root/.config/matplotlib/ && echo 'backend : agg' > /root/.config/matplotlib/matplotlibrc

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

RUN apt-get install -y build-essential firefox

RUN cd ~/czifile/czifile/libjxr && \
    git checkout master && \
    git pull && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make && \
    make install 

RUN cd ~/czifile && \
    /opt/conda/bin/pip install setuptools && \
    /opt/conda/bin/pip install tifffile && \
    /opt/conda/bin/python ./setup.py build && \
    /opt/conda/bin/python ./setup.py install 


EXPOSE 8888
EXPOSE 9999
EXPOSE 6006

WORKDIR "/root"


