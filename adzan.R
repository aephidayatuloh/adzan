library(taskscheduleR)
message(Sys.time())
taskscheduler_runnow("adzan")
print("Adzan")
Sys.sleep(4*60)
taskscheduler_stop("adzan")
