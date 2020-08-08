

#* sound
#* @param callType Choose the item
#* @param speaker Choose the informant
#* @json
#* @post /wav
#* @get /wav



function(speaker,callType){
  

  library(renv)  
  renv::refresh()
  
  library(tuneR)
  

  
  
  url <- paste0("https://sudoranais.shinyapps.io/Analysis_Processing_Rhotic_Alveolar/_w_0f304dee/",speaker,"/",callType,".wav")

  
  tempfile <- tempfile()
  
  destfile <- paste0(tempfile,".wav")
  
  if (!file.exists(destfile)) {
    
    download.file(url,destfile,mode="wb")
    
  }
  
  
  item <- tuneR::readWave(destfile)
  
  item2 <- item@left
  

  
  item2
  
}




#* metadata
#* @param callType Choose the item
#* @param speaker Choose the informant
#* @json
#* @post /metadata
#* @get /metadata


function(speaker,callType){
  
 
  
  library(reticulate)
  
  library(jsonlite)
  
  library(renv)  
  renv::refresh()
  

  
  
  url <- paste0("https://sudoranais.shinyapps.io/Analysis_Processing_Rhotic_Alveolar/_w_0f304dee/",speaker,"/",callType,".wav")

  
  tempfile <- tempfile()
  
  destfile <- paste0(tempfile,".wav")
  
  if (!file.exists(destfile)) {
    
    download.file(url,destfile,mode="wb")
    
  }
  
  

  
  reticulate::py_install('audio-metadata', pip = T)

  
  meta <- reticulate::import("audio_metadata")
  
  
  metadata <- meta$load(destfile)
  
  

  
  metadataJSON <- jsonlite::toJSON(list(signal=list(format=paste(metadata$streaminfo$audio_format),bit=metadata$streaminfo$sample_rate),data=list(author=metadata$tags$TOWN,topic=metadata$tags$album,comment=metadata$tags$COMM[[1]]$text)), asIs = F, pretty=F, .escapeEscapes = T, container = T)

  
  rm(list = c("destfile","tempfile","metadata"))

  
  metadataJSON
  
}
