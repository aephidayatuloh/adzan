install.packages("jsonlite")
install.packages("telegram.bot")

# Download data -----
message(paste0("\n", Sys.Date()))
tomorrow <- Sys.Date() + 1
st_date <- format(tomorrow, "%m/%d/%Y")
# path <- "D:/aephidayatuloh/project/R/adzan/"
path <- ""
# setwd(path)
adzan <- "adzan.R"
subuh <- "subuh.R"
imsak <- "imsak.R"

library(jsonlite)
jdwl <- fromJSON(paste0(path, "jadwal.json"))
jdwl$date <- as.Date(jdwl$date)
jdwl <- subset(jdwl, date == tomorrow)
# message(jdwl$date)

library(telegram.bot)
  
  # file.edit(path.expand(file.path("~", ".Renviron")))
  bot <- Bot(token = bot_token("aepsilonBot"))
  # updates <- bot$getUpdates()
  chat_id <- "300826535" #updates$message$chat_id
  
  notes <- paste0(
    "Jadwal Sholat ", format(jdwl$date, "%A, %d %b %Y"), "\n", 
    "Imsak  : ", jdwl$imsak, "\n", 
    "Subuh  : ", jdwl$subuh, "\n", 
    "Dzuhur  : ", jdwl$dzuhur, "\n", 
    "Ashar  : ", jdwl$ashar, "\n", 
    "Maghrib  : ", jdwl$maghrib, "\n", 
    "Isya  : ", jdwl$isya
    )
  if(!is.null(notes)){
    bot$send_message(chat_id = chat_id, text = notes)
  }
  
}

