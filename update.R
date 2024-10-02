install.packages("jsonlite")
install.packages("taskscheduleR")

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
# Delete and create task -----
if(nrow(jdwl) == 0){
  ## Check if any error -----
  stop("Internal server error")
} else {
  library(taskscheduleR)

  message(paste("set adzan for", st_date))
  
  ## Imsak -----
  message("delete imsak")
  taskscheduler_delete(taskname = "imsak")
  message("create imsak")
  taskscheduler_create(taskname = "imsak", 
                       rscript = paste0(path, imsak), 
                       schedule = "DAILY", 
                       starttime = jdwl$imsak, 
                       startdate = st_date, 
                       rscript_args = paste0("file.show('", path, "imsak.mp3')"))
  
  ## Subuh ------
  message("delete subuh")
  taskscheduler_delete(taskname = "adzan_subuh")
  message("create subuh")
  taskscheduler_create(taskname = "adzan_subuh", 
                       rscript = paste0(path, subuh), 
                       schedule = "DAILY", 
                       starttime = jdwl$subuh, 
                       startdate = st_date)
  ## Dzuhur -----
  message("delete dzuhur")
  taskscheduler_delete(taskname = "adzan_dhuhur")
  message("create dzuhur")
  taskscheduler_create(taskname = "adzan_dhuhur", 
                       rscript = paste0(path, adzan), 
                       schedule = "DAILY", 
                       starttime = jdwl$dzuhur, 
                       startdate = st_date)
  ## If Jumah -----
  if(weekdays(tomorrow) == "Friday"){
    library(lubridate, warn.conflicts = FALSE)
    message("delete reminder jumat")
    taskscheduler_delete(taskname = "reminder_jumat")
    message("create reminder jumat")
    taskscheduler_create(taskname = "reminder_jumat", 
                         rscript = paste0(path, imsak), 
                         schedule = "WEEKLY", 
                         days = "FRI", 
                         starttime = format(as_datetime(paste0(tomorrow, " ", jdwl$dzuhur, ":00 UTC")) %m-% minutes(30), "%H:%M"), 
                         startdate = st_date)
  }
  ## Ashar -----
  message("delete ashar")
  taskscheduler_delete(taskname = "adzan_ashr")
  message("create ashar")
  taskscheduler_create(taskname = "adzan_ashr", 
                       rscript = paste0(path, adzan), 
                       schedule = "DAILY", 
                       starttime = jdwl$ashar, 
                       startdate = st_date)
  ## Maghrib -----
  message("delete maghrib")
  taskscheduler_delete(taskname = "adzan_maghrib")
  message("create maghrib")
  taskscheduler_create(taskname = "adzan_maghrib", 
                       rscript = paste0(path, adzan), 
                       schedule = "DAILY", 
                       starttime = jdwl$maghrib, 
                       startdate = st_date)
  ## Isya -----
  message("delete isya")
  taskscheduler_delete(taskname = "adzan_isya")
  message("create isya")
  taskscheduler_create(taskname = "adzan_isya", 
                       rscript = paste0(path, adzan), 
                       schedule = "DAILY", 
                       starttime = jdwl$isya, 
                       startdate = st_date)
  
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

