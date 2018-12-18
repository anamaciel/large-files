library(sqldf)
library(readr)
library(dplyr)
library(gtools)

setwd("C:\\Users\\igorw\\Downloads\\_results")
root = getwd()
#folder <- "C:\\Users\\igorw\\Downloads\\metrics_LargeFiles"      # path to folder that holds multiple .csv files
#file_list <- list.files(path=folder, pattern="*.csv", recursive = TRUE) # create list of all .csv files in folder

directory = dir()
#root2=paste0(root,"/",directory[255]) #rodar o 25
#setwd(root2)

file_list = dir()
df_all = data.frame()
for (i in 1:length(file_list)){
  data_icse = read.csv2(file_list[i], sep=";", row.names = NULL)
  #data_icse = read.csv2(file_list[i], sep=" ")
  #df_all <- rbind(df_all, data_icse)
  df_all <- smartbind(df_all, data_icse)
  
  print(file_list[i])
  
}

#file_name = basename(root2)
#file_name = unlist(strsplit(file_name, split='-parsed', fixed=TRUE))
write.table(df_all, file = "metrics_summary2.csv", sep=" ", col.names = TRUE, row.names = FALSE)

#setwd("C:\\Users\\igorw\\Downloads\\metrics_LargeFiles\\angular-5.2.10-parsed")
data_icse2 = read.csv2("metrics_summary.csv", sep=";")

