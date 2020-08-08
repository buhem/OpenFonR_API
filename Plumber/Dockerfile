FROM rocker/r-base
MAINTAINER Mohamed El Idrissi <mohamed.elidrissi@inalco.fr>

COPY [".", "./"]

RUN apt-get update -qq && apt-get install -y \
  git-core \
  libssl-dev \
  libcurl4-gnutls-dev

RUN R -e 'install.packages(c("devtools","tuneR","renv","reticulate","jsonlite"))'
## RUN R -e 'devtools::install_github("trestletech/plumber")'
RUN install2.r plumber

## EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=as.numeric(Sys.getenv('PORT')))"]
CMD ["/app/openfonr_api.R"]
