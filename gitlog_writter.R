
library(sqldf)

setwd("C:\\Users\\igorw\\Dropbox\\ICSE_LargeFiles")

data_icse = read.csv2("MyData.csv", sep=",")

subset_TOP20_languages <- subset(data_icse, data_icse$Language %in% c("Kotlin","C/C++ Header","JavaScript","C","PHP","Go","C#","Ruby","TypeScript","Java","Scala","C++","Python","Swift","Rust","Haskell","CoffeeScript","Elixir","Objective C","Lua","Clojure"))

projects = sqldf("select distinct Project from subset_TOP20_languages where ncode>=1848")


setwd("C:\\Users\\igorw\\Dropbox\\ICSE_LargeFiles\\gitlog_scripts_loc1848")

size = nrow(projects)

for (i in 1:size) {
  project = as.character(projects$Project[i])

  sqloc1848_files_by_project = sqldf(paste0("select Project,Language,File,nCode from subset_TOP20_languages where ncode>=1848 and Project=","'",project,"'"))

  size_2 = nrow(sqloc1848_files_by_project)
  
  for (j in 1:size_2) {
    file_name_path = as.character(sqloc1848_files_by_project$File[j])
    file_name = basename(file_name_path)
    file_name_withou_ext = file_path_sans_ext(file_name)
    gitlog = (paste0("git log --pretty=oneline --pretty=format:","%H,%an,%ae,%cn,%ce,%cd,%x22%s%x22"," --shortstat -- ",file_name_path," > ",file_name_withou_ext,".txt"))
    write.table(gitlog, file = paste0(project,".txt"), sep="\t", quote = FALSE, col.names = FALSE, row.names = FALSE, append = TRUE)
    
  }
  
}
