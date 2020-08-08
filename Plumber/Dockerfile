FROM trestletech/plumber
MAINTAINER Mohamed El Idrissi <mohamed.elidrissi@inalco.fr>


RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    file \
    libcurl4-openssl-dev \
    libedit2 \
    libssl-dev \
    lsb-release \
    psmisc \
    procps \
    wget \
    libxml2-dev \
    libpq-dev \
    libssh2-1-dev \
    ca-certificates \
    libglib2.0-0 \
	libxext6 \
	libsm6  \
	libxrender1 \
	bzip2 \
    apache2 \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/


RUN R -e 'install.packages(c("devtools","tuneR","renv","reticulate","jsonlite","xml2"))'
## RUN R -e 'devtools::install_github("trestletech/plumber")'
## RUN install2.r plumber

#RUN apt-get update && apt-get install -y --no-install-recommends build-essential python3.6 python3-pip python3-setuptools python3-dev

## RUN apt-get update -qq && apt-get install -y \
##  git-core \
##  libssl-dev \
##  libcurl4-gnutls-dev

## install miniconda, and set the appropriate path variables.
## install Python 3.7 (Miniconda) and Tensorflow Python packages then set path variables.
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
##    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
ENV PATH /opt/conda/bin:$PATH

## install tensorflow and h5py using the pip that links to miniconda (the default pip is for python 2.7)
RUN /opt/conda/bin/conda install pip 
##    /opt/conda/bin/conda clean -tipsy

# let R know the right version of python to use
ENV RETICULATE_PYTHON /opt/conda/bin/python



## RUN pip3 install

COPY [".", "./"]

## EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
CMD ["openfonr_api.R"]
