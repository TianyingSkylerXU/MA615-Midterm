#Anaysis
#Data
library(stringr)
Bskt=read.csv("Celtics.csv",header=T)
Date=str_split(string = Bskt$Date2,",")
Y=c()
M=c()
D=c()
for(i in 1:length(Date)){
  Y=c(Y,Date[[i]][1])
  m=Date[[i]][2]
  if(m=="Jan"){
    mm=1
  }else if(m=="Feb"){
    mm=2
  }else if(m=="Mar"){
    mm=3
  }else if(m=="Apr"){
    mm=4
  }else if(m=="Nov"){
    mm=11
  }else if(m=="Dec"){
    mm=12
  }
  
  M=c(M,mm)
  D=c(D,Date[[i]][3])
}
Bskt$Year=Y
Bskt$Month=M
Bskt$Day=D

#Match
Weather