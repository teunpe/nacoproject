library(stringr) # For str_trim 
library(dplyr)
library(AUC)
#library(matp)

#set directory
getwd()
setwd("./results")
setwd("Desktop/natural_computing/project/nacoproject/results/")


#write into file
#IMPORTANT: change 'run' variable every time the following chunks of code are run
#for each time ALL the code chunks are ran: run = run + 1
run=1

day<-format(Sys.Date(), "%d")

res<-file(sprintf("res%s_%s.txt", day, run), "w")

writeresults <- function(l, s, run1=run){
  write(l, res) #language
  write(s, res) #score
}

#literal text, global alphabet
langs <- list('ar', 'de', 'el', 'en', 'eo', 'fr', 'hi', 'la', 'pl', 'ru', 'sw')

write("LITERAL GLOBAL ALPHABET", res) 
for(lang in langs) {
  for(r in 0:2) {
    score = readLines(sprintf("eo_%s.txt", r))
    data_e = as.data.frame(score)
    data_e$label <- 0
    score = readLines(sprintf("%s_%s.txt", lang, r))
    data_t = as.data.frame(score)
    data_t$label <- 1
    data_t = rbind(data_e, data_t)
    auc = auc(roc(data_t$score, factor(data_t$label)))
    print(lang)
    print(auc)
  }
  writeresults(lang, auc)
}

#literal text, specific alphabet
write("\nLITERAL SPECIFIC ALPHABET", res) 
for(lang in langs) {
  for(r in 0:2) {
    score = readLines(sprintf("eo_spec_%s.txt", r))
    data_e = as.data.frame(score)
    data_e$label <- 0
    score = readLines(sprintf("%s_spec_%s.txt", lang, r))
    data_t = as.data.frame(score)
    data_t$label <- 1
    data_t = rbind(data_e, data_t)
    auc = auc(roc(data_t$score, factor(data_t$label)))
    print(lang)
    print(auc)
  }
  writeresults(lang, auc)
}

#transliteral text, global alphabet
write("\nTRANSLITERAL GLOBAL ALPHABET", res) 
langs <- list('ar', 'el', 'hi', 'ru')
for(lang in langs) {
  for(r in 0:2) {
    score = readLines(sprintf("eo_%s.txt", r))
    data_e = as.data.frame(score)
    data_e$label <- 0
    score = readLines(sprintf("%s_transl_%s.txt", lang, r))
    data_t = as.data.frame(score)
    data_t$label <- 1
    data_t = rbind(data_e, data_t)
    auc = auc(roc(data_t$score, factor(data_t$label)))
    print(lang)
    print(auc)
  }
  writeresults(lang, auc)
}

#transliteral text, specific alphabet
write("\nTRANSLITERAL SPECIFIC ALPHABET", res) 
for(lang in langs) {
  for(r in 0:2) {
    score = readLines(sprintf("eo_spec_%s.txt", r))
    data_e = as.data.frame(score)
    data_e$label <- 0
    score = readLines(sprintf("%s_transl_spec_%s.txt", lang, r))
    data_t = as.data.frame(score)
    data_t$label <- 1
    data_t = rbind(data_e, data_t)
    auc = auc(roc(data_t$score, factor(data_t$label)))
    print(lang)
    print(auc)
  }
  writeresults(lang, auc)
}

