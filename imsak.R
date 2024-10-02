library(taskscheduleR)

taskscheduler_runnow("imsak_player")
Sys.sleep(6*60)
taskscheduler_stop("imsak_player")
