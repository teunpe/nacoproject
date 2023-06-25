library(stringr) # For str_trim 
library(dplyr)
library(AUC)
library(rstudioapi)
#library(matp)

#set directory
current_file_path <- path.expand(dirname(rstudioapi::getSourceEditorContext()$path))
current_file_path
getwd()
setwd(paste0(current_file_path, "/results"))
getwd()

#write into file
#IMPORTANT: change 'run' variable every time the following chunks of code are run
#for each time ALL the code chunks are ran: run = run + 1
run=1

day<-format(Sys.Date(), "%d")
filename <- sprintf("/res%s_%s.txt", day, run)
filepath <- paste0(current_file_path, filename)
res <- file(filepath, "w")

writeresults <- function(l, s){
  write(l, res) #language
  mean <- mean(unlist(s))
  s <- c(s, mean)
  write(paste(s, collapse= ","), res) #score
}

#literal text, global alphabet
langs <- list('ar', 'de', 'el', 'en', 'eo', 'fr', 'hi', 'la', 'pl', 'ru', 'sw')

write("LITERAL GLOBAL ALPHABET", res) 
for(lang in langs) {
  for(r in 3:5) {
    aucs <- list()
    write(sprintf("r=%s",r), res)
    for (re in 0:2) {
      score = readLines(sprintf("eo_%s_%s.txt", r, re))
      data_e = as.data.frame(score)
      data_e$label <- 0
      score = readLines(sprintf("%s_%s_%s.txt", lang, r, re))
      data_t = as.data.frame(score)
      data_t$label <- 1
      data_t = rbind(data_e, data_t)
      auc = auc(roc(data_t$score, factor(data_t$label)))
      print(lang)
      print(auc)
      aucs <- c(aucs, auc)
    }
    writeresults(lang, aucs)
  }
}

#literal text, specific alphabet
write("\nLITERAL SPECIFIC ALPHABET", res) 
for(lang in langs) {
  for(r in 3:5) {
    aucs <- list()
    write(sprintf("r=%s",r), res)
    for(re in 0:2) {
      score = readLines(sprintf("eo_%s_spec_%s.txt", r, re))
      data_e = as.data.frame(score)
      data_e$label <- 0
      score = readLines(sprintf("%s_%s_spec_%s.txt", lang, r, re))
      data_t = as.data.frame(score)
      data_t$label <- 1
      data_t = rbind(data_e, data_t)
      auc = auc(roc(data_t$score, factor(data_t$label)))
      print(lang)
      print(auc)
      aucs <- c(aucs, auc)
    }
    writeresults(lang, aucs)
  }
}

#transliteral text, global alphabet
write("\nTRANSLITERAL GLOBAL ALPHABET", res) 
langs <- list('ar', 'el', 'hi', 'ru')
for(lang in langs) {
  for(r in 3:5) {
    aucs <- list()
    write(sprintf("r=%s",r), res)
    for(re in 0:2) {
      score = readLines(sprintf("eo_%s_%s.txt", r, re))
      data_e = as.data.frame(score)
      data_e$label <- 0
      score = readLines(sprintf("%s_%s_transl_%s.txt", lang, r, re))
      data_t = as.data.frame(score)
      data_t$label <- 1
      data_t = rbind(data_e, data_t)
      auc = auc(roc(data_t$score, factor(data_t$label)))
      print(lang)
      print(auc)
      aucs <- c(aucs, auc)
    }
    writeresults(lang, aucs)
  }
}

#transliteral text, specific alphabet
write("\nTRANSLITERAL SPECIFIC ALPHABET", res) 
for(lang in langs) {
  for(r in 3:5) {
    aucs <- list()
    write(sprintf("r=%s",r), res)
    for(re in 0:2) {
      score = readLines(sprintf("eo_%s_spec_%s.txt", r, re))
      data_e = as.data.frame(score)
      data_e$label <- 0
      score = readLines(sprintf("%s_%s_transl_spec_%s.txt", lang, r, re))
      data_t = as.data.frame(score)
      data_t$label <- 1
      data_t = rbind(data_e, data_t)
      auc = auc(roc(data_t$score, factor(data_t$label)))
      print(lang)
      print(auc)
      aucs <- c(aucs, auc)
    }
    writeresults(lang, aucs)
  }
}

