FROM trestletech/plumber
LABEL org.label-schema.name="OpenFonR_API" \
      org.label-schema.vcs-url="https://github.com/buhem/OpenFonR_API" \
      org.label-schema.version="1.0" \
      org.label-schema.build-date="2020" \
      org.label-schema.schema-version="1.0" \
      
      org.opencontainers.image.title="OpenFonR_API" \
      org.opencontainers.image.licenses="LicenseRef-MIT-Style-1" \
      org.opencontainers.image.source="https://github.com/buhem/OpenFonR_API" \
      org.opencontainers.image.version="1.0" \
      org.opencontainers.image.created="2020" \
      org.opencontainers.image.authors="Mohamed El Idrissi <mohamed.elidrissi-at-inalco.fr>" \
      org.opencontainers.image.description="OpenFonR_API is a microservice used to share open research data. The user can get recordings, annotations and metadata on Sud-Oranais Berber varieties to study the sound system of this language"
      



COPY [".", "./"]



RUN R -e 'install.packages(c("tuneR","renv","reticulate","dplyr","stringr"),repo="http://cran.rstudio.com/",dependencies=c("Depends","Imports","LinkingTo"),INSTALL_opts=c("--no-html","--no-multiarch","--no-data","--no-test-load"))'



## install miniconda
## install Python 3.7 from miniconda
## indicate the path variables.
## https://github.com/tmobile/r-tensorflow-api
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
##    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
ENV PATH /opt/conda/bin:$PATH




## install rlist library / doesn't work with r / it cannot find XML library
RUN set -e mkdir /usr/local/lib/R/new-library
RUN /opt/conda/bin/conda create -p /usr/local/lib/R/new-library -y -c r r-rlist
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate /usr/local/lib/R/new-library/lib/R/library" >> ~/.bashrc



## install audio-metadata using pip from conda
RUN /opt/conda/bin/pip install audio-metadata




## indicate the version of python to use
ENV RETICULATE_PYTHON /opt/conda/bin/python



## set the path for rlist
RUN echo 'R_LIBS_USER="/usr/local/lib/R/new-library/lib/R/library"' >> /usr/lib/R/etc/Renviron
RUN echo 'R_LIBS=\${R_LIBS-"/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library"}' >> /usr/lib/R/etc/Renviron


## EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
CMD ["openfonr_api.R"]
