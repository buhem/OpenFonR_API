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


## install R libraries
## https://cran.r-project.org/bin/windows/base/old/2.15.3/NEWS.R-2.15.3.html
## RUN R -e 'options(devtools.install.args = c("--no-multiarch", "--no-test-load"))'
## INSTALL_opts=c("--install-args","--no-html,"--no-multiarch","--no-data","--no-test-load")
RUN R --install-args --no-html --no-multiarch --no-data --no-test-load -e 'install.packages(c("tuneR","renv","reticulate","dplyr"),repo="http://cran.rstudio.com/",dependencies=c("Depends", "Imports", "LinkingTo"))'


## install xml2
## https://hub.docker.com/r/jeroenooms/xml2
## RUN git clone https://github.com/hadley/xml2 \
##	&& R CMD build xml2 --no-build-vignettes \
##	&& R CMD INSTALL xml2_*.tar.gz --install-tests

## RUN R -e 'testthat::test_package("xml2"); q("no");' || true

## RUN R CMD check xml2_*.tar.gz

## RUN R -e 'install.packages("XML", configure.vars="XML_CONFIG=/usr/local/opt/libxml2/bin/xml2-config")'

## RUN R -e 'install.packages("xml2", configure.vars="XML_CONFIG=/usr/local/opt/libxml2/bin/xml2-config")'


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


##

RUN /opt/conda/bin/conda create -p /usr/lib/R/site-library -y -c r r-xml 
#RUN /opt/conda/bin/conda create -p /usr/lib/R/site-library -y -c r r-xml2
RUN /opt/conda/bin/conda create -p /usr/lib/R/site-library -y -c r r-curl


## install R libraries
RUN R --install-args --no-html --no-multiarch --no-data --no-test-load -e 'install.packages("rlist", repo="http://cran.rstudio.com/",dependencies=c("Depends", "Imports", "LinkingTo"))'

## RUN R -e 'install.packages("https://github.com/hadley/xml2/archive/master.tar.gz", type = "source", repos = NULL)'
## RUN R -e 'devtools::install_github("trestletech/plumber")'



## install audio-metadata using pip from conda
RUN /opt/conda/bin/pip install audio-metadata




## indicate the version of python to use
ENV RETICULATE_PYTHON /opt/conda/bin/python




## EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
CMD ["openfonr_api.R"]
