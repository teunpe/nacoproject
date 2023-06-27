library(stringr) # For str_trim 
library(dplyr)
library(AUC)
library(rstudioapi)
library(gridExtra)
#library(matp)

#set directory
current_file_path <- path.expand(dirname(rstudioapi::getSourceEditorContext()$path))
current_file_path
getwd()
setwd(paste0(current_file_path, "/results/corr_trainset"))
getwd()

#write into file
#IMPORTANT: change 'run' variable every time the following chunks of code are run
#for each time ALL the code chunks are ran: run = run + 1
run=1

# output file for all results
day<-format(Sys.Date(), "%d")
filename <- sprintf("/res%s_%s.csv", day, run)
filepath <- paste0(current_file_path, filename)
res <- file(filepath, "w")

writeresults <- function(tre, s){
  mean <- mean(unlist(s))
  s <- c(s, mean)
  write(paste(sprintf("testfile %s, ",tre) ,paste(s, collapse= ",") ), res) #score
  return(mean)
}

# output file for overall means for r and language per language set
fname <- sprintf("/res%s_%s_comp.csv", day, run)
fpath <- paste0(current_file_path, fname)
fme <- file(fpath, "w")
writemeans <- function(m){
  write("lan,   r3,     r4,    r5", fme) #language
  i = 1
  for (l in m) {
    print(l)
    write(paste(sprintf("%s, ", plangs[i]), paste(sprintf("  %.2f", l), collapse= ",")), fme) #score
    i = i+1
  }
}

#literal text, global alphabet
langs <- list('ar', 'de', 'el', 'en', 'eo', 'fr', 'hi', 'la', 'pl', 'ru', 'sw')

write("LITERAL GLOBAL ALPHABET", res) 
globalmeans <- list()
for(lang in langs) {
  rmeans <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    for (tre in 0:2) {
      aucs <- list()
      for (re in 0:2) {
        score = readLines(sprintf("eo_%s_t%s-%s.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_t%s-%s.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        print(lang)
        print(auc)
        aucs <- c(aucs, auc)
      }
      mean <- writeresults(tre, aucs)
      means <- c(means, mean)
    }
    rmean <- mean(unlist(means))
    write(sprintf("mean, %s \n", rmean), res)
    rmeans <- c(rmeans, rmean)
  }
  globalmeans <- append(globalmeans, list(rmeans))
}

print(globalmeans)
write("LITERAL GLOBAL ALPHABET", fme) 
writemeans(globalmeans)


write("\n\n---------------------------------------------", res)
write("LITERAL SPECIFIC ALPHABET", res) 
write("---------------------------------------------\n", res)
specmeans <- list()
for(lang in langs) {
  rmeans <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    for (tre in 0:2) {
      aucs <- list()
      for (re in 0:2) {
        score = readLines(sprintf("eo_%s_spec_t%s-%s.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_spec_t%s-%s.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        print(lang)
        print(auc)
        aucs <- c(aucs, auc)
      }
      mean <- writeresults(tre, aucs)
      means <- c(means, mean)
    }
    rmean <- mean(unlist(means))
    write(sprintf("mean, %s \n", rmean), res)
    rmeans <- c(rmeans, rmean)
  }
  specmeans <- append(specmeans, list(rmeans))
}

print(specmeans)
write("\nLITERAL SPECIFIC ALPHABET", fme) 
writemeans(specmeans)




#transliteral text, global alphabet
tlangs <- list('ar', 'el', 'hi', 'ru')
write("\n\n---------------------------------------------", res)
write("TRANSLITERAL GLOBAL ALPHABET", res) 
write("---------------------------------------------\n", res)
globalmeans2 <- list()
for(lang in tlangs) {
  rmeans <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    for (tre in 0:2) {
      aucs <- list()
      for (re in 0:2) {
        score = readLines(sprintf("eo_%s_t%s-%s.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_transl_t%s-%s.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        print(lang)
        print(auc)
        aucs <- c(aucs, auc)
      }
      mean <- writeresults(tre, aucs)
      means <- c(means, mean)
    }
    rmean <- mean(unlist(means))
    write(sprintf("mean, %s \n", rmean), res)
    rmeans <- c(rmeans, rmean)
  }
  globalmeans2 <- append(globalmeans2, list(rmeans))
}

print(globalmeans2)
write("\nTRANSLITERAL GLOBAL ALPHABET", fme) 
writemeans(globalmeans2)

#transliteral text, specific alphabet
write("\n\n---------------------------------------------", res)
write("TRANSLITERAL SPECIFIC ALPHABET", res) 
write("---------------------------------------------\n", res)
specmeans2 <- list()
for(lang in tlangs) {
  rmeans <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    for (tre in 0:2) {
      aucs <- list()
      for (re in 0:2) {
        score = readLines(sprintf("eo_%s_spec_t%s-%s.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_transl_spec_t%s-%s.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        print(lang)
        print(auc)
        aucs <- c(aucs, auc)
      }
      mean <- writeresults(tre, aucs)
      means <- c(means, mean)
    }
    rmean <- mean(unlist(means))
    write(sprintf("mean, %s \n", rmean), res)
    rmeans <- c(rmeans, rmean)
  }
  specmeans2 <- append(specmeans2, list(rmeans))
}

print(specmeans2)
write("\nTRANSLITERAL SPECIFIC ALPHABET", fme) 
writemeans(specmeans2)

#phonetic text, global alphabet for variant 0 ligature false
plangs <- list("ar", "de", "el", "en", "eo", "fr", "hi", "la", "pl", "ru", "sw", "zh")
write("\n\n---------------------------------------------", res)
write("PHONETIC GLOBAL ALPHABET", res) 
write("---------------------------------------------\n", res)
globalmeans3 <- list()
for(lang in plangs) {
  rmeans <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    for (tre in 0:1) {
      aucs <- list()
      for (re in 0:1) {
        score = readLines(sprintf("eo_%s_ipa_t%s-%s.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_ipa_t%s-%s.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        print(lang)
        print(auc)
        aucs <- c(aucs, auc)
      }
      mean <- writeresults(tre, aucs)
      means <- c(means, mean)
    }
    rmean <- mean(unlist(means))
    write(sprintf("mean, %s \n", rmean), res)
    rmeans <- c(rmeans, rmean)
  }
  globalmeans3 <- append(globalmeans3, list(rmeans))
}

print(globalmeans3)
write("\nPHONETIC GLOBAL ALPHABET", fme) 
writemeans(globalmeans3)

#phonetic text, global alphabet for variant 0 ligature false
write("\n\n---------------------------------------------", res)
write("PHONETIC SPECIFIC ALPHABET", res) 
write("---------------------------------------------\n", res)
specmeans3 <- list()
for(lang in plangs) {
  rmeans <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    for (tre in 0:1) {
      aucs <- list()
      for (re in 0:1) {
        score = readLines(sprintf("eo_%s_ipa_spec_t%s-%s.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_ipa_spec_t%s-%s.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        print(lang)
        print(auc)
        aucs <- c(aucs, auc)
      }
      mean <- writeresults(tre, aucs)
      means <- c(means, mean)
    }
    rmean <- mean(unlist(means))
    write(sprintf("mean, %s \n", rmean), res)
    rmeans <- c(rmeans, rmean)
  }
  specmeans3 <- append(specmeans3, list(rmeans))
}

print(specmeans3)
write("\nPHONETIC SPECIFIC ALPHABET", fme) 
writemeans(specmeans3)

