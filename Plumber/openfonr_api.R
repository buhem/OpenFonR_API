#author: Mohamed El Idrissi
#contact: mohamed.elidrissi-at-inalco.fr
#Licence: MIT
#v.1.0







#* @filter cors
cors <- function(req, res) {
  
  res$setHeader("Access-Control-Allow-Origin", "*")
  
  if (req$REQUEST_METHOD == "OPTIONS") {
    res$setHeader("Access-Control-Allow-Methods","*")
    res$setHeader("Access-Control-Allow-Headers", req$HTTP_ACCESS_CONTROL_REQUEST_HEADERS)
    res$status <- 200 
    return(list())
  } else {
    plumber::forward()
  }
  
}










#* sound
#* @param callType Choose the item
#* @param speaker Choose the informant
#* @json charset=UTF-8
#* @post /wav
#* @get /wav



function(speaker,callType){
  

  library(renv)  
  renv::refresh()
  
  library(tuneR)
  

  
  
  base <- "https://sudoranais.shinyapps.io/Analysis_Processing_Rhotic_Alveolar"
  
  relative <- "_w_907223f2"
  
  
  url <- paste0(base,"/",relative,"/",speaker,"/",callType,".wav")
  
  
  
  tempfile <- tempfile()
  
  destfile <- paste0(tempfile,".wav")
  
  
  if (!file.exists(destfile)==T) {
    
    
    statut <- print(try(download.file(url,destfile,mode="wb"), TRUE))
    
    i=0

    while (is.character(statut) == T) {
      
      
      i++
        
        if (i == 5)  {
          
          break
          
        }

            
      statut <- print(try(download.file(url,destfile,mode="wb"), TRUE))      
      
      
    }
    
    
  }
  
  
  
  item <- tuneR::readWave(destfile)
  
  item2 <- item@left
  
  rm(list = c("destfile","tempfile","item","url","statut"))
  
  item2
  
}












#* annotation
#* @param callType Choose the item
#* @param speaker Choose the informant
#* @json charset=UTF-8
#* @post /label
#* @get /label


function(speaker,callType){
  
  
  library(renv)  
  renv::refresh()
  
  library(dplyr)
  
  library(rlist)
  
  library(stringr)
  
  
  base <- "https://sudoranais.shinyapps.io/Analysis_Processing_Rhotic_Alveolar"
  
  relative <- "_w_907223f2"
  
  
  url2 <- paste0(base,"/",relative,"/",speaker,"/",callType,".TextGrid")
  
  
  tempfile <- tempfile()
  
  
  destfile2 <- paste0(tempfile,".TextGrid")
  
  
  if (!file.exists(destfile2)==T) {
    
    
    
    statut2 <- print(try(download.file(url2,destfile2,mode="wb"), TRUE))
    
    i=0
    
    while (is.character(statut2) == T) {
      
      
      i++
        
        if (i == 5)  {
          
          break
          
        }
      
      statut2 <- print(try(download.file(url2,destfile2,mode="wb"), TRUE))
      
    
    }
    
    
  }
  
  
  
  
  txtgrid <- read.delim(destfile2, sep=c("=","\n"), dec=".", header=FALSE,encoding="UTF-8")
  
  
  #get items
  txtgrid.sub <- txtgrid[-(1:grep("intervals", txtgrid$V1)[1]),]
  

  txtgrid.sub.sub  <- dplyr::filter(txtgrid.sub,grepl(pattern = 'xmin|xmax|text', txtgrid.sub$V1))
  
  
  
  
  grep("xmin",  txtgrid.sub.sub$V1)[-1]
  
  splits <- unlist(mapply(rep, seq_along(grep("xmin", txtgrid.sub.sub$V1)),
                          diff(c(grep("xmin", txtgrid.sub.sub$V1), 
                                 nrow(txtgrid.sub.sub) + 1))))
  
  df.list <- split(txtgrid.sub.sub, list(splits))
  
  
 
  

  i <- 1
  x = length(df.list)
  while (i <= x) {
    
    
    if (is.na(df.list[[i]][3,2]) || as.vector(df.list[[i]][3,2]) == "  "){
      
      
      df.list[i] <- NULL
      
      x <- x - 1
      
      i <- i - 1 
      
    } else {
      
      
      i <- i + 1 
      
    }
    
  }
  
  
    
  
  
  
  
  
  annotation <- vector("list", length = length(df.list))
  
  
  for (i in seq_along(df.list)) {
    
    data.frame.bind <- c()
    
    for (j in seq_along(rownames(df.list[[i]][,]))) {
      
      data<-c()
      
      
      for (k in seq_along(colnames(df.list[[i]][j,]))) {
        
        
        data <- append(data,paste0(stringr::str_replace_all(string=df.list[[i]][j,k], pattern=" ", repl="")))
        
        
        if (k==2){
           
          data <- c(data[1],data[2])  
         
          
          
          data.frame.bind <- rbind(data.frame.bind,data)
          
          
          
        }  
        
      
        
      }
      
      
      
      
      
      if (j==3){
        
      
        list_data_bind <- structure(c(data.frame.bind[1,2],data.frame.bind[2,2],data.frame.bind[3,2]), .Names = c(data.frame.bind[1,1],data.frame.bind[2,1],data.frame.bind[3,1]))
        
        
        tier <- as.list(list_data_bind)
        
        annotation[[i]]  <- tier
        
        
      }
      
      
      
      
    }
    
    
    
   
  }
  
  
  
  annotation_total <- list()
  
 
  
  annotation_total <- list.prepend(annotation_total,annotation[c(1)])
  annotation_total <- list.prepend(annotation_total,annotation[c(2:length(df.list))])
  
 
  rm(list = c("destfile2","tempfile","annotation","url2","txtgrid","statut2","df.list","splits","txtgrid.sub.sub","txtgrid.sub"))
  
  
  annotation_total
  
  

}















#* metadata
#* @param callType Choose the item
#* @param speaker Choose the informant
#* @json charset=UTF-8
#* @post /metadata
#* @get /metadata


function(speaker,callType){
  
  
  library(renv)  
  renv::refresh()
 
  
  library(reticulate)
  


  base <- "https://sudoranais.shinyapps.io/Analysis_Processing_Rhotic_Alveolar"
  
  relative <- "_w_907223f2"
  
  url <-  paste0(base,"/",relative,"/",speaker,"/",callType)

  
  

  
  
  tempfile <- tempfile()
  
  destfile <- paste0(tempfile,".wav")
  
  destfile2 <- paste0(tempfile,".TextGrid")
  
  
  
  if (!file.exists(destfile)==T) {
    
    
    statut <- print(try(download.file(paste0(url,".wav"),destfile,mode="wb"), TRUE))
    
    
    statut2 <- print(try(download.file(paste0(url,".TextGrid"),destfile2,mode="wb"), TRUE))
    
    i=0
    
    while (is.character(statut) == T) {
      
      i++
        
        if (i == 5)  {
          
          break
          
        }
      
      statut <- print(try(download.file(paste0(url,".wav"),destfile,mode="wb"), TRUE))      
     
      
    }
    
    while (is.character(statut2) == T) {
      
      
      i++
        
        if (i == 5)  {
          
          break
          
        }
      
      statut2 <- print(try(download.file(paste0(url,".TextGrid"),destfile2,mode="wb"), TRUE))
      
     
      
    }
    
    
    
    
  }
  
  txtgrid <- read.delim(destfile2, sep=c("=","\n"), dec=".", header=FALSE,encoding="UTF-8")
  
  

  

  meta <- reticulate::import("audio_metadata")
  
  
  metadata <- meta$load(destfile)
  
  

  
  
  metadataJSON <-       list(list('@context'="https://schema.org/",
                             '@type'=c("Dataset","ArchiveComponent"),
                             name=metadata$tags$albumartist,
                             description=metadata$tags$COMM[[1]]$text,
                             variableMeasured=metadata$tags$usertext[[1]]$text,
                             inLanguage=metadata$tags$language,
                             license=metadata$tags$copyright,
                             citation=list(
                               '@type'="Thesis",
                               author="Mohamed El Idrissi",
                               name="Description of endangered Berber varieties of Sud-Oranais (Algeria) - A Dialectological, phonetic and phonological study of the consonantic system",
                               inLanguage="FR",
                               url="https://hal.archives-ouvertes.fr/tel-02079768v2",
                               inSupportOf="Doctoral thesis",
                               sourceOrganization="INALCO"
                             ),
                             isPartOf=list(
                               '@type'="WebApplication",
                               name="\U01B1pnF\U028AnR",
                               abstract=paste("The purpose of this web application, called \U01B1pnF\U028AnR, is to offer an interactive signal processing of a phonetic corpus on the Alveolar Rhotics. I have created this web-app, made with Shiny, in order to share a sample of my data and make my work available to the scientific community.",
                                              url="https://sudoranais.Shinyapps.io/Analysis_Processing_Rhotic_Alveolar"),
                               applicationCategory="signal processing",
                               softwareRequirements="R",
                               citation=metadata$tags$userurl[[1]]$url,
                               dateCreated="2018",
                               license="https://opensource.org/licenses/MIT",
                               maintainer=list(
                                 '@type'="Person",
                                 sameAs="http://orcid.org/0000-0003-2655-686X",
                                 name="Mohamed El Idrissi",
                                 jobTitle="Researcher",
                                 contactPoint=list(
                                   '@type'="ContactPoint",
                                   email=c("mohamed.elidrissi-at-inalco.fr","mohamed.el-idrissi-at-outlook.com")
                                 )
                               ),
                               creator=list(
                                 '@type'="Person",
                                 name="Mohamed El Idrissi",
                                 jobTitle="Researcher",
                                 contactPoint=list(
                                   '@type'="ContactPoint",
                                   email=c("mohamed.elidrissi-at-inalco.fr","mohamed.el-idrissi-at-outlook.com")
                                 )
                               ),
                               potentialAction=list(
                                 '@type'="SearchAction",
                                 target="https://sudoranais.Shinyapps.io/Analysis_Processing_Rhotic_Alveolar/metadata?speaker={query}&callType={query}",
                                 query="required"
                               )
                             ),
                             maintainer=list(
                               '@type'="Person",
                               sameAs="http://orcid.org/0000-0003-2655-686X",
                               name="Mohamed El Idrissi",
                               jobTitle="Researcher",
                               contactPoint=list(
                                 '@type'="ContactPoint",
                                 email=c("mohamed.elidrissi-at-inalco.fr","mohamed.el-idrissi-at-outlook.com")
                               )
                             ),
                             creator=list(
                               '@type'="Person",
                               name="Mohamed El Idrissi",
                               jobTitle="Researcher",
                               contactPoint=list(
                                 '@type'="ContactPoint",
                                 email=c("mohamed.elidrissi-at-inalco.fr","mohamed.el-idrissi-at-outlook.com")
                               )
                             ),
                             includedInDataCatalog=list(
                               '@type'="DataCatalog",
                               name="Sud-Oranais collection"
                             ),
                             identifier=metadata$tags$userurl[[1]]$url,
                             about=list(
                               name=metadata$tags$album,
                               about=list(
                                 name="Linguistics"
                               )
                             ),
                             temporalCoverage=metadata$tags$date,
                             spatialCoverage=list(
                               '@type'="Place",
                               name="Asla",
                               geo=list(
                                 '@type'="GeoCoordinates",
                                 latitude= 33.004394, 
                                 longitude= -0.078009
                               )
                             ),
                             distribution=list(
                               '@type'="DataDownload",
                               name=list(
                                 '@type'="PronounceableText",
                                 inLanguage=metadata$tags$language,
                                 textValue=callType,
                                 speechToTextMarkup="IPA",
                                 phoneticText= paste0("[",txtgrid[17,2],"]")
                               ),
                               actor=list(
                                 '@type'="PerformanceRole",
                                 actor=list(
                                   '@type'="Person",
                                   name=metadata$tags$artist
                                 )
                               ),
                               additionalProperty=list(
                                 '@type'="PropertyValue",
                                 name="Resolution",
                                 additionalProperty=list(
                                   list(
                                     '@type'="PropertyValue",
                                     name="Sample rate",
                                     value=metadata$streaminfo$sample_rate,
                                     unitText="Hz"
                                   ),
                                   list(
                                     '@type'="PropertyValue",
                                     name="Bit depth",
                                     value=metadata$streaminfo$bit_depth,
                                     unitText="Hz"
                                   )
                                 )
                               ),
                               measurementTechnique=metadata$tags$encodersettings,
                               encodingFormat="audio/x-wav",
                               subjectOf=list(
                                 list(
                                   '@type'="CreativeWork",
                                   name="API Metadata",
                                   url="https://openfonrapi-g3q3eh375a-uc.a.run.app/metadata?",
                                   encodingFormat="application/json",
                                   potentialAction=list(
                                     '@type'="SearchAction",
                                     target="https://openfonrapi-g3q3eh375a-uc.a.run.app/metadata?speaker={query}&callType={query}",
                                     query="required"
                                   )
                                 ),
                                 list(
                                   '@type'="CreativeWork",
                                   name="API Sound",
                                   url="https://openfonrapi-g3q3eh375a-uc.a.run.app/wav?",
                                   encodingFormat="application/json",
                                   potentialAction=list(
                                     '@type'="SearchAction",
                                     target="https://openfonrapi-g3q3eh375a-uc.a.run.app/wav?speaker={query}&callType={query}",
                                     query="required"
                                   )
                                 )
                               )
                             )
  )
  )
  
  
  rm(list = c("destfile","destfile2","tempfile","metadata","url","txtgrid","statut","statut2"))
  
  
  metadataJSON
  
}
