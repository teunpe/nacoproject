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
setwd(paste0(current_file_path, "/results/chunk/corr"))
getwd()

#write into file
#IMPORTANT: change 'run' variable every time the following chunks of code are run
#for each time ALL the code chunks are ran: run = run + 1
run=1

# output file for all results
day<-format(Sys.Date(), "%d")
filename <- sprintf("/res%s_%s_chunk.csv", day, run)
filepath <- paste0(current_file_path, filename)
res <- file(filepath, "w")
write("R-Chunk algorithm results
Results per language and r per language set for all trainfiles
      showing three repeats and the mean and std over the repeats in one row
      at the end showing mean of the mean and std per trainfile \n", res)

writeresults <- function(tre, s){
  mean <- mean(unlist(s))
  sd <- sd(unlist(s))
  s <- c(s, mean)
  s <- c(s, sd)
  write(paste(sprintf("trainfile %s, ",tre) ,paste(s, collapse= ",") ), res) #score
  return(c(mean, sd))
}
  
# output file for overall means for r and language per language set
fname <- sprintf("/res%s_%s_comp_chunk.csv", day, run)
fpath <- paste0(current_file_path, fname)
fme <- file(fpath, "w")
write("R-Chunk algorithm results
      Means and standard deviations per r and language per language set over all runs\n", fme)
writemeans <- function(m, std, langs){
  write("lan,   r3,          r4,          r5", fme) #language
  i = 1
  for (l in m) {
    #print(l)
    result <- tryCatch({
      write(paste(sprintf("%s,", langs[i]), paste(sprintf("  %.2f(%.2f)", l, std[[i]]), collapse= ",")), fme) #score
      i = i+1
    }, error = function(e) {
      print(std)
      print(sprintf("l=%s", l))
      print(sprintf("i=%s", i))
    }, finally = {
      
    })
  }
}

#literal text, global alphabet
langs <- list('ar', 'de', 'el', 'en', 'eo', 'fr', 'hi', 'la', 'pl', 'ru', 'sw')

write("LITERAL GLOBAL ALPHABET", res) 
globalmeans <- list()
globalstds <- list()
for(lang in langs) {
  rmeans <- list()
  rstds <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    stds <- list()
    aucs_per_r <-list()
    for (tre in 0:2) {
      aucs <- list()
      for (re in 0:2) {
        score = readLines(sprintf("eo_%s_t%s-%s_chunk.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_t%s-%s_chunk.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        #print(lang)
        #print(auc)
        aucs <- c(aucs, auc)
      }
      mst <- writeresults(tre, aucs)
      means <- c(means, mst[1])
      stds <- c(stds, mst[2])
      aucs_per_r <- c(aucs_per_r, aucs)
    }
    rmean <- mean(unlist(means))
    rstd <- sd(unlist(aucs_per_r))
    var_of_stds <- mean(unlist(stds))
    write(sprintf("mean, %s.  ,std, %s \n", rmean, var_of_stds), res)
    rmeans <- c(rmeans, rmean)
    rstds <- c(rstds, rstd)
  }
  globalmeans <- append(globalmeans, list(rmeans))
  globalstds <- append(globalstds, list(rstds))
}

#print(globalmeans)
write("LITERAL GLOBAL ALPHABET", fme) 
writemeans(globalmeans, globalstds, langs)


write("\n\n---------------------------------------------", res)
write("LITERAL SPECIFIC ALPHABET", res) 
write("---------------------------------------------\n", res)
globalmeans <- list()
globalstds <- list()
for(lang in langs) {
  rmeans <- list()
  rstds <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    stds <- list()
    aucs_per_r <-list()
    for (tre in 0:2) {
      aucs <- list()
      for (re in 0:2) {
        score = readLines(sprintf("eo_%s_spec_t%s-%s_chunk.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_spec_t%s-%s_chunk.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        #print(lang)
        #print(auc)
        aucs <- c(aucs, auc)
      }
      mst <- writeresults(tre, aucs)
      means <- c(means, mst[1])
      stds <- c(stds, mst[2])
      aucs_per_r <- c(aucs_per_r, aucs)
    }
    rmean <- mean(unlist(means))
    rstd <- sd(unlist(aucs_per_r))
    var_of_stds <- mean(unlist(stds))
    write(sprintf("mean, %s.  ,std, %s \n", rmean, var_of_stds), res)
    rmeans <- c(rmeans, rmean)
    rstds <- c(rstds, rstd)
  }
  globalmeans <- append(globalmeans, list(rmeans))
  globalstds <- append(globalstds, list(rstds))
}

#print(globalmeans)
write("\nLITERAL SPECIFIC ALPHABET", fme) 
writemeans(globalmeans, globalstds, langs)




#transliteral text, global alphabet
tlangs <- list('ar', 'el', 'hi', 'ru')
write("\n\n---------------------------------------------", res)
write("TRANSLITERAL GLOBAL ALPHABET", res) 
write("---------------------------------------------\n", res)
globalmeans <- list()
globalstds <- list()
for(lang in tlangs) {
  rmeans <- list()
  rstds <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    stds <- list()
    aucs_per_r <-list()
    for (tre in 0:2) {
      aucs <- list()
      for (re in 0:2) {
        score = readLines(sprintf("eo_%s_t%s-%s_chunk.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_transl_t%s-%s_chunk.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        #print(lang)
        #print(auc)
        aucs <- c(aucs, auc)
      }
      mst <- writeresults(tre, aucs)
      means <- c(means, mst[1])
      stds <- c(stds, mst[2])
      aucs_per_r <- c(aucs_per_r, aucs)
    }
    rmean <- mean(unlist(means))
    rstd <- sd(unlist(aucs_per_r))
    var_of_stds <- mean(unlist(stds))
    write(sprintf("mean, %s.  ,std, %s \n", rmean, var_of_stds), res)
    rmeans <- c(rmeans, rmean)
    rstds <- c(rstds, rstd)
  }
  globalmeans <- append(globalmeans, list(rmeans))
  globalstds <- append(globalstds, list(rstds))
}

#print(globalmeans)
write("\nTRANSLITERAL GLOBAL ALPHABET", fme) 
writemeans(globalmeans, globalstds, tlangs)

#transliteral text, specific alphabet
write("\n\n---------------------------------------------", res)
write("TRANSLITERAL SPECIFIC ALPHABET", res) 
write("---------------------------------------------\n", res)
globalmeans <- list()
globalstds <- list()
for(lang in tlangs) {
  rmeans <- list()
  rstds <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    stds <- list()
    aucs_per_r <-list()
    for (tre in 0:2) {
      aucs <- list()
      for (re in 0:2) {
        score = readLines(sprintf("eo_%s_spec_t%s-%s_chunk.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_transl_spec_t%s-%s_chunk.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        #print(lang)
        #print(auc)
        aucs <- c(aucs, auc)
      }
      mst <- writeresults(tre, aucs)
      means <- c(means, mst[1])
      stds <- c(stds, mst[2])
      aucs_per_r <- c(aucs_per_r, aucs)
    }
    rmean <- mean(unlist(means))
    rstd <- sd(unlist(aucs_per_r))
    var_of_stds <- mean(unlist(stds))
    write(sprintf("mean, %s.  ,std, %s \n", rmean, var_of_stds), res)
    rmeans <- c(rmeans, rmean)
    rstds <- c(rstds, rstd)
  }
  globalmeans <- append(globalmeans, list(rmeans))
  globalstds <- append(globalstds, list(rstds))
}

#print(globalmeans)
write("\nTRANSLITERAL SPECIFIC ALPHABET", fme) 
writemeans(globalmeans, globalstds, tlangs)

#phonetic text, global alphabet for variant 0 ligature false
plangs <- list("ar", "de", "el", "en", "eo", "fr", "hi", "la", "pl", "ru", "sw", "zh")
write("\n\n---------------------------------------------", res)
write("PHONETIC GLOBAL ALPHABET", res) 
write("---------------------------------------------\n", res)
globalmeans <- list()
globalstds <- list()
for(lang in plangs) {
  rmeans <- list()
  rstds <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    stds <- list()
    aucs_per_r <-list()
    for (tre in 0:1) {
      aucs <- list()
      for (re in 0:1) {
        score = readLines(sprintf("eo_%s_ipa_t%s-%s_chunk.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_ipa_t%s-%s_chunk.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        #print(lang)
        #print(auc)
        aucs <- c(aucs, auc)
      }
      mst <- writeresults(tre, aucs)
      means <- c(means, mst[1])
      stds <- c(stds, mst[2])
      aucs_per_r <- c(aucs_per_r, aucs)
    }
    rmean <- mean(unlist(means))
    rstd <- sd(unlist(aucs_per_r))
    var_of_stds <- mean(unlist(stds))
    write(sprintf("mean, %s.  ,std, %s \n", rmean, var_of_stds), res)
    rmeans <- c(rmeans, rmean)
    rstds <- c(rstds, rstd)
  }
  globalmeans <- append(globalmeans, list(rmeans))
  globalstds <- append(globalstds, list(rstds))
}

#print(globalmeans)
write("\nPHONETIC GLOBAL ALPHABET", fme) 
writemeans(globalmean, globalstds, plangs)

#phonetic text, global alphabet for variant 0 ligature false
write("\n\n---------------------------------------------", res)
write("PHONETIC SPECIFIC ALPHABET", res) 
write("---------------------------------------------\n", res)
globalmeans <- list()
globalstds <- list()
for(lang in plangs) {
  rmeans <- list()
  rstds <- list()
  for(r in 3:5) {
    write(sprintf("lan=%s; r=%s",lang, r), res)
    means <- list()
    stds <- list()
    aucs_per_r <-list()
    for (tre in 0:1) {
      aucs <- list()
      for (re in 0:1) {
        score = readLines(sprintf("eo_%s_ipa_spec_t%s-%s_chunk.txt", r, tre, re))
        data_e = as.data.frame(score)
        data_e$label <- 0
        score = readLines(sprintf("%s_%s_ipa_spec_t%s-%s_chunk.txt", lang, r, tre, re))
        data_t = as.data.frame(score)
        data_t$label <- 1
        data_t = rbind(data_e, data_t)
        auc = auc(roc(data_t$score, factor(data_t$label)))
        #print(lang)
        #print(auc)
        aucs <- c(aucs, auc)
      }
      mst <- writeresults(tre, aucs)
      means <- c(means, mst[1])
      stds <- c(stds, mst[2])
      aucs_per_r <- c(aucs_per_r, aucs)
    }
    rmean <- mean(unlist(means))
    rstd <- sd(unlist(aucs_per_r))
    var_of_stds <- mean(unlist(stds))
    write(sprintf("mean, %s.  ,std, %s \n", rmean, var_of_stds), res)
    rmeans <- c(rmeans, rmean)
    rstds <- c(rstds, rstd)
  }
  globalmeans <- append(globalmeans, list(rmeans))
  globalstds <- append(globalstds, list(rstds))
}

#print(globalmeans)
write("\nPHONETIC SPECIFIC ALPHABET", fme) 
writemeans(globalmeans, globalstds, plangs)

