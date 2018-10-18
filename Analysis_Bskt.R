#Anaysis
#Data
library(stringr)
library(dplyr)
library(ggplot2)

Bskt=read.csv("Celtics/Celtics.csv",header=T)
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
  }else if(m=="Oct"){
    mm=10
  }else if(m=="Nov"){
    mm=11
  }else if(m=="Dec"){
    mm=12
  }
  
  M=c(M,mm)
  D=c(D,Date[[i]][3])
}
Date=str_c(Y,M,D,sep="-")
Bskt_f=Bskt[,-c(1,2)]
Bskt_f$Date=Date


Wth=read.csv("Weather/weather_Data.csv",header=T)
DD=str_split(string = Wth$DATE," ")
W_Dt=c()
for(i in 1:length(DD)){
  A=str_split(DD[[i]][1],"/")
  d=str_c(A[[1]][1],"-",A[[1]][2],"-",A[[1]][3])
  W_Dt=c(W_Dt,d)
}
Wth$Date_f=W_Dt


#Match, clean data

df=left_join(Bskt_f,Wth,by=c("Date"="Date_f"))
ddd=as.Date(df$Date)
df$Date=ddd

df$feel_like_temp=df$DAILYDeptFromNormalAverageTemp*df$DAILYAverageDryBulbTemp
for(i in 1:dim(df)[1]){
  if(is.na(df$DAILYSnowfall[i])){
    
  }else if(df$DAILYSnowfall[i]=="T"){
    df$DAILYSnowfall[i]=0
  }
}
for(i in 1:dim(df)[1]){
  if(is.na(df$DAILYPrecip[i])){
    
  }else if(df$DAILYPrecip[i]=="T"){
    df$DAILYPrecip[i]=0
  }
}

df$P<-df$ATTD/df$CAP


#This is to plot the temperature versus attendance

par(mfrow=c(2,2))
ggplot(data = df,aes(x = df$DAILYAverageDryBulbTemp, y = df$P)) +
  geom_point()+
  geom_smooth(method="lm")
ggplot(data = df) +
  geom_point(aes(x = df$DAILYAverageWindSpeed, y = df$P))
ggplot(data = df) +
  geom_point(aes(x = df$DAILYSnowfall, y = df$P))
ggplot(data = df) +
  geom_point(aes(x = df$feel_like_temp, y = df$P))
ggplot(data = df) +
  geom_point(aes(x = df$DAILYAverageStationPressure, y = df$P))

ggplot(data = df) +
  geom_point(aes(x = df$DAILYAverageDryBulbTemp, y = df$DAILYAverageWindSpeed),size=2*df$P)


write.csv(file = "basketdata", x = df)
