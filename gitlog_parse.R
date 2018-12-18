# data was created via
# git log --pretty=format:"[%H],%an,%ae,%aD,%aI,%x22%s%x22" --numstat  --no-merges > Commits.txt
# https://github.com/lorenzwalthert/gitsum

#"git log --pretty=oneline --pretty=format:"%H,%an,%ae,%cn,%ce,%cd,%x22%s%x22" --shortstat -- LICENSE.txt > Commits.txt"
#gitlog = paste0("git log --pretty=oneline --pretty=format:","%H,%an,%ae,%cn,%ce,%cd,%x22%s%x22"," --shortstat -- ",file_name)
#gitlog = paste0("git log --pretty=oneline --pretty=format:","%H,%an,%ae,%cn,%ce,%cd,%x22%s%x22"," --shortstat -- ",file_name," > ",file_name_withou_ext,".txt")
#print(gitlog)
#gitlog_result = system(gitlog, intern=TRUE)
#gitlog_output = system(gitlog, intern=TRUE, input = "output.txt")
#write.table(gitlog_output, file = paste0(file_name_withou_ext,".txt"))

library(tools) 
library(gsubfn)
library(data.table)
library(stringr)

#lendo dados de todos os arquivos
mydata = read.csv("C:\\Users\\igorw\\Dropbox\\ICSE_LargeFiles\\MyData.csv", sep = ",")

#setando o ambiente de trabalho
setwd("C:\\Users\\igorw\\Dropbox\\ICSE_LargeFiles\\data_example\\akka-2.5.12")
directory = setwd("C:\\Users\\igorw\\Dropbox\\ICSE_LargeFiles\\data_example\\akka-2.5.12")


dirs=getwd()
files <- list.files(path=dirs)
project_name = sub(".*/", "", directory)

for (i in 1:length(files)) { 
  gitallData <- readLines(files[i]);
    
  #commitEntries = grep("^\\[", gitallData)
  commitEntries = grep("[0-9a-f]{5,40}", gitallData)
  metricsEntries = commitEntries + 1
  
  # create table for the commit metadata
  commitTable = read.table(text = gitallData[commitEntries], sep = ",", header = FALSE, fill = TRUE)
  commitTable = cbind(commitTable, addLines = 0)
  commitTable = cbind(commitTable, excLines = 0)
  colnames(commitTable) <- c("Hash","ContributorName","ContributorEmail","CommitterName","Committeremail","DateISO8608","CommitMessage","addLines","excLines")
  #head(commitTable)    
  
  numOfLines <- length(gitallData)
  contCommitTableIndex = 1
  
  for (j in 1:length(metricsEntries)) {
    
    x = c()
    index_metrics=metricsEntries[j]
    changes = gitallData[index_metrics]
    x = strapply(changes, "\\d+", as.numeric, simplify = TRUE) 
    insert = 0
    delete = 0
    if (length(grep("insert",changes)) != 0) { insert = 1 }
    
    if (length(grep("delet",changes)) != 0) {delete = 1 } 
    
    if (insert == 1 & delete == 1) { 
      commitTable[contCommitTableIndex,8] = x[2]
      commitTable[contCommitTableIndex,9] = x[3]
      
      #print(x[2],x[3],commitTable[contCommitTableIndex,1])
      contCommitTableIndex = contCommitTableIndex +1
    }
    
    if (insert == 1 & delete == 0)  {
      commitTable[contCommitTableIndex,8] = x[2]
      #print(x[2],commitTable[contCommitTableIndex,1])
      
      contCommitTableIndex = contCommitTableIndex +1  
    }
    
    if (insert == 0 & delete == 1)  {
      commitTable[contCommitTableIndex,9] = x[2]
      #print(x[2],commitTable[contCommitTableIndex,1])
      
      contCommitTableIndex = contCommitTableIndex +1
    }
    
    if (insert == 0 & delete == 0)  {
      
      contCommitTableIndex = contCommitTableIndex +1
    }
    
  }
  
  file_name= sub('\\..*$', '', basename(files[i]))
  commitTable$Project_Name <- project_name
  commitTable$File_Name <- file_name
  
  metrics_data = subset(mydata, mydata$Project == project_name)
  metrics_data = subset(metrics_data, metrics_data$nCode >= 1848)
  
  metrics_data = metrics_data[grep(file_name, metrics_data$File_basename), ]
  if (length(metrics_data$File_basename) > 1) {
    sizeString = nchar(file_name) + 5 #+5 pq a extensao é .java. Se for outra extensao, mudar.
      metrics_data = metrics_data[nchar(str_sub(metrics_data$File_basename)) == sizeString , ]

  }
    
  
  #metrics_data = subset(metrics_data, metrics_data$File_basename)
  commitTable$Language = metrics_data$Language
  commitTable$path = metrics_data$File_dirname
  
  setwd(paste0(directory," - parsed"))
  write.table(commitTable, file = paste0(file_name,".csv"), col.names = TRUE)
  setwd(directory)
  
}


