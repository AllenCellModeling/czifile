# From pytorch compiled from source
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:screencast' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


EXPOSE 22

RUN apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 cmake screen tmux libtiff5-dev \
    git software-properties-common && \
    apt-get clean

RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.1.0-Linux-x86_64.sh -O ~/anaconda.sh \
    && /bin/bash ~/anaconda.sh  -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh 

RUN ["/bin/bash", "-c", "echo \". /opt/conda/etc/profile.d/conda.sh\" >> ~/.bashrc"]

RUN ["/bin/bash", "-c", "/opt/conda/bin/conda update -y -n base conda"] 

RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y ipywidgets"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y nodejs"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y natsort"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y matplotlib"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y scikit-learn"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y scikit-image"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y pandas"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y xlrd"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y tqdm"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y yapf"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y fire"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y jupyter"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y jupyterlab"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda install -c conda-forge -y jupyter_contrib_nbextensions"]
RUN ["/bin/bash", "-c", "/opt/conda/bin/conda clean -tipsy"]


RUN mkdir -p /root/.config/matplotlib/ && echo 'backend : agg' > /root/.config/matplotlib/matplotlibrc


COPY jupyter_notebook_config.py /root/.jupyter/
RUN ["/bin/bash", "-c", "/opt/conda/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager"]

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

# CMD ["/usr/sbin/sshd", "-D"]
# CMD ["/bin/bash", "-c", "/opt/conda/bin/jupyter lab --allow-root --ip=127.0.0.1 --NotebookApp.iopub_data_rate_limit=10000000000"]


WORKDIR "/root"

