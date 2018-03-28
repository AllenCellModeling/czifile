# From pytorch compiled from source
FROM ubuntu:trusty

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 cmake screen tmux libtiff5-dev apt-add-repository \
    git && \
    apt-get clean

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN sudo apt-get install software-properties-common python-software-properties && \
    apt-add-repository "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu trusty main" && \
    apt-add-repository "deb-src http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu trusty main" && \
    apt-add-repository "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-5.0 main" && \
    apt-add-repository "deb-src http://apt.llvm.org/trusty/ llvm-toolchain-trusty-5.0 main" && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    apt-get update && \
    apt-get install -y apt-get install clang-5.0 clang-tools-5.0 clang-5.0-doc && \
    apt-get install -y libclang-common-5.0-dev libclang-5.0-dev libclang1-5.0 && \
    apt-get install -y libclang1-5.0-dbg libllvm-5.0-ocaml-dev libllvm5.0 && \
    apt-get install -y libllvm5.0-dbg lldb-5.0 llvm-5.0 llvm-5.0-dev llvm-5.0-doc && \
    apt-get install -y llvm-5.0-examples llvm-5.0-runtime clang-format-5.0 && \
    apt-get install -y python-clang-5.0 libfuzzer-5.0-dev

RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh  -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN cd ~ && \
    git clone git@github.com:AllenCellModeling/czifile.git && \
    cd czifile && \
    git checkout hotfix && \
    git submodule update --init czifile/libjpeg && \
    git submodule update --init czifile/libjxr && \
    cd czifile/libjpeg && \
    export CC=/usr/bin/clang-5.0 && \
    export CXX=/usr/bin/clang++-5.0 && \
    export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:${LD_LIBRARY_PATH} && \
    ./configure && \
    make && \
    make install && \
    cd ../libjxr && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make && \
    make install && \
    cd ~/czifile && \
    python3 setup.py build && \
    python3 setup.py install 






# pytorch image comes with:
#   ubuntu: build-essential cmake git curl vim ca-certificates libjpeg-dev libpng-dev
#   python: numpy pyyaml scipy ipython mkl

# install more python stuff
RUN conda install -c conda-forge -y \
    jupyter \
    jupyterlab \
    jupyter_contrib_nbextensions \
    ipywidgets \
    nodejs \
    natsort \
    matplotlib \
    scikit-learn \
    scikit-image \
    pandas \
    xlrd \
    tqdm \
    seaborn \
    yapf \
    fire \
    && conda clean -tipsy

# pip install since conda version out of date
#RUN pip install tensorflow tensorboard

# pip install since conda version downgrades numpy which breaks pytorch
#RUN pip install h5py

# add tensorboardx from source
#RUN pip install git+https://github.com/lanpa/tensorboard-pytorch

# add our aicsimage repo
#RUN git clone https://github.com/AllenCellModeling/aicsimage.git /opt/aicsimage && \
#    cd /opt/aicsimage && \
#    pip install -r requirements.txt && \
#    pip install -e .

# install the simd fork of pillow -- aicsimage installs pillow
#RUN pip uninstall -y pillow
#RUN pip install pillow-simd

# add pytorch learning tools
#RUN git clone https://github.com/AllenCellModeling/pytorch_learning_tools.git /opt/pytorch_learning_tools && \
#    cd /opt/pytorch_learning_tools && \
#    git checkout dataframeDP && \
#    pip install -e .


# **************************************************************************************
# Set up notebook config
#COPY jupyter_notebook_config.py /root/.jupyter/
#RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager

# set matplitlib backend
#RUN mkdir -p /root/.config/matplotlib/ && echo 'backend : agg' > /root/.config/matplotlib/matplotlibrc

# expose port for ipython (9999)
#EXPOSE 9999
#EXPOSE 6006

# move to home dir for root
WORKDIR "/root" 
