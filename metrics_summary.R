library(sqldf)
library(readr)
library(dplyr)
library(gtools)

setwd("C:\\Users\\igorw\\Dropbox\\ICSE_LargeFiles")

metrics_summary = read.csv2("metrics_summary_fixed.csv", sep=";")
subset_TOP20_languages <- subset(metrics_summary, metrics_summary$Language %in% c("Kotlin","C/C++ Header","JavaScript","C","PHP","Go","C#","Ruby","TypeScript","Java","Scala","C++","Python","Swift","Rust","Haskell","CoffeeScript","Elixir","Objective C","Lua","Clojure"))


length(unique(subset_TOP20_languages$CommitterName))
length(unique(subset_TOP20_languages$ContributorName))
length(unique(subset_TOP20_languages$Project_Name))
length(unique(subset_TOP20_languages$File_Name))

subset_TOP20_languages$addLines <- as.numeric(as.character(subset_TOP20_languages$addLines))
subset_TOP20_languages$excLines <- as.numeric(as.character(subset_TOP20_languages$excLines))

summary(subset_TOP20_languages$addLines)
summary(subset_TOP20_languages$excLines)

boxplot(subset_TOP20_languages$addLines)
boxplot(subset_TOP20_languages$excLines)

plot(subset_TOP20_languages$addLines,subset_TOP20_languages$excLines)

#### Analysis By Language ####

kotlin <- subset(metrics_summary, metrics_summary$Language %in% c("Kotlin"))
C_CPlus_Header <- subset(metrics_summary, metrics_summary$Language %in% c("C/C++ Header"))
Javascript <- subset(metrics_summary, metrics_summary$Language %in% c("JavaScript")) 
C <- subset(metrics_summary, metrics_summary$Language %in% c("C")) 
PHP <- subset(metrics_summary, metrics_summary$Language %in% c("PHP"))
Go <- subset(metrics_summary, metrics_summary$Language %in% c("Go"))
CSharp <- subset(metrics_summary, metrics_summary$Language %in% c("C#"))
Java <- subset(metrics_summary, metrics_summary$Language %in% c("Java"))
Scala <- subset(metrics_summary, metrics_summary$Language %in% c("Scala"))
CPlus <- subset(metrics_summary, metrics_summary$Language %in% c("C++"))
Ruby <- subset(metrics_summary, metrics_summary$Language %in% c("Ruby"))
Python <- subset(metrics_summary, metrics_summary$Language %in% c("Python"))
Swift <- subset(metrics_summary, metrics_summary$Language %in% c("Swift"))
Rust <- subset(metrics_summary, metrics_summary$Language %in% c("Rust"))
Haskell <- subset(metrics_summary, metrics_summary$Language %in% c("Haskell"))
Elixir <- subset(metrics_summary, metrics_summary$Language %in% c("Elixir"))
Objective_C <- subset(metrics_summary, metrics_summary$Language %in% c("Objective C"))
Lua <- subset(metrics_summary, metrics_summary$Language %in% c("Lua"))
Clojure <- subset(metrics_summary, metrics_summary$Language %in% c("Clojure"))
CoffeeScript <- subset(metrics_summary, metrics_summary$Language %in% c("CoffeeScript"))


