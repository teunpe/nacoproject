#TO COMPUTE THE MEANS FOR EACH DISTINCT R VALUE, FOR EACH LANGUAGE SET
d<-read.csv("res27_1_comp.csv", sep=",", header = F)
d<-read.csv("res27_1_comp_chunk.csv", sep=",", header = F)

#literal
for (vari in 1:ncol(d)){
  a<-as.numeric(d[3:13,vari])
  a<-mean(a)
  print(a)
}

for (vari in 1:ncol(d)){
    a<-as.numeric(d[16:26,vari])
  a<-mean(a)
  print(a)
}

#transliteral
for (vari in 1:ncol(d)){
  a<-as.numeric(d[29:32,vari])
  a<-mean(a)
  print(a)
}

for (vari in 1:ncol(d)){
  a<-as.numeric(d[35:38,vari])
  a<-mean(a)
  print(a)
}

#phonetic
for (vari in 1:ncol(d)){
  a<-as.numeric(d[41:52,vari])
  a<-mean(a)
  print(a)
}

for (vari in 1:ncol(d)){
  a<-as.numeric(d[55:66,vari])
  a<-mean(a)
  print(a)
}
