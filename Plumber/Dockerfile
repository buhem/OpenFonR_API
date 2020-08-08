FROM trestletech/plumber
MAINTAINER Mohamed El Idrissi <mohamed.elidrissi@inalco.fr>

COPY [".", "./"]

RUN apt-get update && apt-get install -y --no-install-recommends build-essential python3.6 python3-pip python3-setuptools python3-dev python3-audio-metadata

## RUN apt-get update -qq && apt-get install -y \
##  git-core \
##  libssl-dev \
##  libcurl4-gnutls-dev

RUN R -e 'install.packages(c("devtools","tuneR","renv","reticulate","jsonlite","xml2"))'
## RUN R -e 'devtools::install_github("trestletech/plumber")'
## RUN install2.r plumber

## EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
CMD ["openfonr_api.R"]
