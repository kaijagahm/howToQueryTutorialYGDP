# Wrapper function for dbReadTable that converts "NA" to <NA> and changes some data types.
# Written by Kaija Gahm on 9 November 2020
# GH issue #32

dbTable <- function(con = con, tableName){
  library(RSQLite)
  library(lubridate)
  tab <- dbReadTable(con, tableName) # read in the table. All cols will be character because of the way we encoded them. 
  
  # Change things to NA's ---------------------------------------------------
  tab[tab == "NA"] <- NA_character_ 
  tab[tab == ""] <- NA_character_
  tab[tab == " "] <- NA_character_
  
  # Parse dates -------------------------------------------------------------
  if("dateReleased" %in% names(tab)){
    tab$dateReleased <- lubridate::ymd(tab$dateReleased)
  }
  if("dateClosed" %in% names(tab)){
    tab$dateClosed <- lubridate::ymd(tab$dateClosed)
  }
  if("dateTimeStart" %in% names(tab)){
    tab$dateTimeStart <- lubridate::ymd_hms(tab$dateTimeStart)
  }
  if("dateTimeEnd" %in% names(tab)){
    tab$dateTimeEnd <- lubridate::ymd_hms(tab$dateTimeEnd)
  }
  if("date" %in% names(tab)){
    tab$date <- lubridate::ymd(tab$date)
  }
  
  # Return finished table ---------------------------------------------------
  return(tab)
}
