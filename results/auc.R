library(stringr) # For str_trim 
library(dplyr)
library(AUC)
library(matp)
# Comparison of English and Tagalog:
setwd("./nacoproject/results")

# Repeat this process for the 4 other languages
langs <- list('ar', 'de', 'el', 'en', 'eo', 'fr', 'hi', 'la', 'pl', 'ru', 'sw', 'zh')
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
}

# Repeat this process for the 4 other languages
langs <- list('ar', 'el', 'hi', 'ru', 'zh')
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
}

for(r in 1:5) {
  # Load the score for each English string and label it as 0
  score = readLines(sprintf("snd-unm_normal_%d.txt", r))
  data_e = as.data.frame(score)
  data_e$label <- 0
  # Repeat for the Tagalog strings with label 1
  score = readLines(sprintf("snd-unm_anomaly_%d.txt", r))
  data_t = as.data.frame(score)
  data_t$label <- 1
  # Combine the scores
  data = rbind(data_e, data_t)
  # And calculate the AUC
  auc = auc(roc(data$score, factor(data$label)))
  plot(roc(data$score, factor(data$label)),main=r)
  print(r)
  print(auc)
}

