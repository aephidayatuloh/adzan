# Download data -----
message(paste0("\n", Sys.Date()))
setwd("D:/aephidayatuloh/project/R/adzan/")

library(purrr)
library(jsonlite)
library(lubridate)
library(glue)
library(telegram.bot)

# from <- Sys.Date()
# to <- rollback(from %m+% months(1), roll_to_first = FALSE)
# if(from == to){
#   sysdates <- seq.Date(from + 1, to %m+% months(2) %>% rollback(roll_to_first = TRUE) - 1, by = "1 day")
#   api <- sprintf("https://api.banghasan.com/sholat/format/json/jadwal/kota/1203/tanggal/%s", sysdates)
#   jdwl <- map_dfr(1:length(api), function(.x){
#     message(paste("Running", sysdates[.x]))
#     map_dfc(api[.x], function(.y){
#       rs <- fromJSON(.y)
#       rs$jadwal$data$tanggal <- rs$query$tanggal
#       rs$jadwal$data$status <- rs$jadwal$status
#       rs$jadwal$data
#       })
#   })
#   jdwl <- jdwl[, c("tanggal", "status", "imsak", "subuh", "terbit", "dhuha", "dzuhur", "ashar", "maghrib", "isya")]
#   write_json(jdwl, "jadwal.json", pretty = TRUE)
#   message("Done")
# }

# if(from != to) { 
  api <- glue::glue("https://api.myquran.com/v2/sholat/jadwal/1203/{tahun}/{bulan}", 
                    tahun = format(Sys.Date(), "%Y"), 
                    bulan = format(Sys.Date() + 1, "%m"))
  jadwal <- jsonlite::fromJSON(api)
  if(jadwal$status == TRUE){
    jsonlite::write_json(jadwal$data$jadwal, "jadwal.json", pretty = TRUE)
    message("Done")
    
    
    # file.edit(path.expand(file.path("~", ".Renviron")))
    bot <- Bot(token = bot_token("aepsilonBot"))
    # updates <- bot$getUpdates()
    chat_id <- "300826535" #updates$message$chat_id
    
    bot$send_message(chat_id = chat_id, text = "Monthly update done")
  } else {
    
    # file.edit(path.expand(file.path("~", ".Renviron")))
    bot <- Bot(token = bot_token("aepsilonBot"))
    # updates <- bot$getUpdates()
    chat_id <- "300826535" #updates$message$chat_id
    
    bot$send_message(chat_id = chat_id, text = "Monthly update failed")
    }
# }
