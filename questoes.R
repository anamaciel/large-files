library(sqldf)
library(readr)
library(dplyr)
library(gtools)
library(dplyr)
library(ISLR)

setwd("D:\\Pesquisas\\ICSE_LargeFiles\\csvs")

metrics_summary = read.csv2("testingNewCSV_comdataALL.csv", sep=";")
#metrics_summary = read.csv2("partSEMLINHASERRADAS8.csv", sep=";")
subset_TOP20_languages <- subset(metrics_summary, metrics_summary$Language %in% c("Kotlin","C/C++ Header","JavaScript","C","PHP","Go","C#","Ruby","TypeScript","Java","Scala","C++","Python","Swift","Rust","Haskell","CoffeeScript","Elixir","Objective C","Lua","Clojure"))

#===================================================================================================
#GERACAO DO CSV COM A QTDE DE ARQUIVOS POR PROJETO
#data frame com todos os projetos sem repetir
projects <- subset_TOP20_languages %>%distinct(subset_TOP20_languages$Project_Name)

teste <- subset_TOP20_languages[order(subset_TOP20_languages$new_date,decreasing=c(TRUE)),]

length(projects[[1]])
table_result_file_by_projects <- data.frame(Project_Name = "a", qtd_file_by_project=1)

for (i in 1:length(projects[[1]])){ 
#for (i in 2:2) {   
  print(as.character(projects[[1]][[i]]))
  subset_some_projects <- subset(metrics_summary, metrics_summary$Project_Name %in% c(as.character(projects[[1]][[i]])))
  qtde_file_by_project <- subset_some_projects %>%distinct(subset_some_projects$File_Name)
  
  #table_result_file_by_projects <- data.frame(Project_Name = c(as.character(projects[[1]][[i]])), qtd_file_by_project=c(length(qtde_file_by_project[[1]])))
  #table_result_file_by_projects$Project_Name <- as.character(projects[[1]][[i]])
  #table_result_file_by_projects$qtd_file_by_project <- as.numeric(length(qtde_file_by_project[[1]]))
   
   
  linha <- data.frame(Project_Name = c(as.character(projects[[1]][[i]])), qtd_file_by_project=c(length(qtde_file_by_project[[1]])))
   
  table_result_file_by_projects <- bind_rows(table_result_file_by_projects, linha)
}

setwd(paste0("D:\\Pesquisas\\ICSE_LargeFiles\\questoes"))
write.table(table_result_file_by_projects, file = paste0("files_by_project.csv"), na = "",
            row.names = FALSE,
            col.names = FALSE,
            append = TRUE,
            sep = ",")

#==================================================================================================
#GERACAO DO CSV COM A QTDE DE ARQUIVOS POR LINGUAGEM
languages <- subset_TOP20_languages %>%distinct(subset_TOP20_languages$Language)
length(languages[[1]])
table_result_file_by_languages <- data.frame(Language = "a", qtd_file_by_language=1)

sqldf("SELECT COUNT(File_Name) FROM subset_TOP20_languages WHERE Language = 'Python'")
  
for (i in 1:length(languages[[1]])){ 
  #for (i in 2:2) {   
  print(as.character(languages[[1]][[i]]))
  
  select_language <- paste('SELECT COUNT(File_Name) FROM subset_TOP20_languages WHERE Language =\'', as.character(languages[[1]][[i]]),'\'',sep="")
  
  result_sql <- sqldf(select_language)
  
  print(result_sql[[1]])
  
  linha <- data.frame(Language = c(as.character(as.character(languages[[1]][[i]]))), qtd_file_by_language=c(result_sql[[1]]))
  table_result_file_by_languages <- bind_rows(table_result_file_by_languages, linha)
  
  setwd(paste0("D:\\Pesquisas\\ICSE_LargeFiles\\questoes"))
  write.table(table_result_file_by_languages, file = paste0("files_by_language.csv"), na = "",
              row.names = FALSE,
              col.names = FALSE,
              append = TRUE,
              sep = ",")
}
  
#==================================================================================================
#TABELA FINAL
agrupado_file <- sqldf("SELECT File_Name, Language, Project_Name, sum(addLines) as SumAddLines, sum(excLines) as SumExcLines FROM subset_TOP20_languages GROUP BY File_Name")

setwd(paste0("D:\\Pesquisas\\ICSE_LargeFiles\\questoes"))
write.table(agrupado_file, file = paste0("table_result_all.csv"), na = "",
            row.names = FALSE,
            col.names = FALSE,
            append = TRUE,
            sep = ",")

#testeCount <- sqldf("SELECT COUNT(*) FROM subset_TOP20_languages WHERE File_Name ='__init__'")

#=================================================================================================
#Lista de arquivos
files <- subset_TOP20_languages %>%distinct(subset_TOP20_languages$File_Name)

#==================================================================================================
#QTDE DE COMMITS

table_result_qtde_commits <- data.frame(File_Name = "a", qtd_commits=1)

for (i in 1:length(files[[1]])){ 
  
  print(as.character(files[[1]][[i]]))
  
  countCommits <- paste('SELECT COUNT(*) FROM subset_TOP20_languages WHERE File_Name =\'', as.character(files[[1]][[i]]),'\'',sep="")
  
  result_sql <- sqldf(countCommits)
  
  print(result_sql[[1]])
  
  linha <- data.frame(File_Name = c(as.character(as.character(files[[1]][[i]]))), qtd_commits=c(result_sql[[1]]))
  table_result_qtde_commits <- bind_rows(table_result_qtde_commits, linha)
  print(i)
  
}
setwd(paste0("D:\\Pesquisas\\ICSE_LargeFiles\\questoes"))
write.table(table_result_qtde_commits, file = paste0("table_result_qtde_commits.csv"), na = "",
            row.names = FALSE,
            col.names = FALSE,
            append = TRUE,
            sep = ",")
#====================================================================================================
#Descobrir número de contributors
#sqldf("SELECT COUNT(distinct ContributorName) FROM subset_TOP20_languages WHERE File_Name ='__init__'")

table_result_qtde_contributors <- data.frame(File_Name = "a", qtd_contributors=1)

for (i in 1:length(files[[1]])){ 
  
  print(as.character(files[[1]][[i]]))
  
  countContributors <- paste('SELECT COUNT(distinct ContributorName) FROM subset_TOP20_languages WHERE File_Name =\'', as.character(files[[1]][[i]]),'\'',sep="")
  
  result_sql <- sqldf(countContributors)
  
  print(result_sql[[1]])
  
  linha <- data.frame(File_Name = c(as.character(as.character(files[[1]][[i]]))), qtd_contributors=c(result_sql[[1]]))
  table_result_qtde_contributors <- bind_rows(table_result_qtde_contributors, linha)
  
  print(i)
  
}
setwd(paste0("D:\\Pesquisas\\ICSE_LargeFiles\\questoes"))
write.table(table_result_qtde_contributors, file = paste0("table_result_qtde_contributors.csv"), na = "",
            row.names = FALSE,
            col.names = FALSE,
            append = TRUE,
            sep = ",")


#====================================================================================================
#Descobrir número de Committers
sqldf("SELECT COUNT(distinct CommitterName) FROM subset_TOP20_languages WHERE File_Name ='__init__'")
table_result_qtde_committers <- data.frame(File_Name = "a", qtd_committers=1)

for (i in 1:length(files[[1]])){ 
  
  print(as.character(files[[1]][[i]]))
  
  countCommiters <- paste('SELECT COUNT(distinct CommitterName) FROM subset_TOP20_languages WHERE File_Name =\'', as.character(files[[1]][[i]]),'\'',sep="")
  
  result_sql <- sqldf(countCommiters)
  
  print(result_sql[[1]])
  
  linha <- data.frame(File_Name = c(as.character(as.character(files[[1]][[i]]))), qtd_committers=c(result_sql[[1]]))
  table_result_qtde_committers <- bind_rows(table_result_qtde_committers, linha)
  
  print(i)
  
}
setwd(paste0("D:\\Pesquisas\\ICSE_LargeFiles\\questoes"))
write.table(table_result_qtde_committers, file = paste0("table_result_qtde_committers.csv"), na = "",
            row.names = FALSE,
            col.names = FALSE,
            append = TRUE,
            sep = ",")


#====================================================================================================
#Fazer o range de datas
#datas <- sqldf("SELECT MAX(new_date) AS max_date, MIN(new_date) AS min_date, MAX(new_date) - MIN(new_date) FROM subset_TOP20_languages WHERE File_Name ='__init__'")

#range <- difftime(as.Date(datas$max_date, format = "%Y-%m-%d"), as.Date(datas$min_date, format = "%Y-%m-%d"), units = "days")

#print(as.numeric(range))

table_result_range_dates <- data.frame(File_Name = "a", range_days=1)

for (i in 1:length(files[[1]])){ 
  
  print(as.character(files[[1]][[i]]))
  
  datas <- paste('SELECT MAX(new_date) AS max_date, MIN(new_date) AS min_date, MAX(new_date) - MIN(new_date) FROM subset_TOP20_languages WHERE File_Name =\'', as.character(files[[1]][[i]]),'\'',sep="")
  
  result_sql <- sqldf(datas)
  
  print(result_sql[[1]])
  
  range <- difftime(as.Date(result_sql$max_date, format = "%Y-%m-%d"), as.Date(result_sql$min_date, format = "%Y-%m-%d"), units = "days")
  
  linha <- data.frame(File_Name = c(as.character(as.character(files[[1]][[i]]))), range_days=c(as.numeric(range)))
  table_result_range_dates <- bind_rows(table_result_range_dates, linha)
  
  print(i)
  
}
setwd(paste0("D:\\Pesquisas\\ICSE_LargeFiles\\questoes"))
write.table(table_result_range_dates, file = paste0("table_result_range_dates.csv"), na = "",
            row.names = FALSE,
            col.names = FALSE,
            append = TRUE,
            sep = ",")


  


