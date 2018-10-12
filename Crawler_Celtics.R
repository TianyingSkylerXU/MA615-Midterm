library(xml2)
library(rvest)
library(stringr)

Date_all=c()
ATTD=c()
CAP=c()
Pr=c()
n1=2013:2018
sites1=paste0("http://www.espn.com/nba/team/schedule/_/name/bos/season/",n1,"/seasontype/2")
for (i in 1:length(sites1)){
  web=read_html(sites1[i])
  
  Dates=web %>%
    html_nodes('td[class=\"Table2__td\"] span') %>%
    html_text()
  
  for(m in 1:length(Dates)){
    if(grepl(",",Dates[m])==TRUE){
      MD=str_split(str_split(Dates[m],",")[[1]][2]," ")
      if(MD[[1]][2]=="Oct"|MD[[1]][2]=="Nov"|MD[[1]][2]=="Dec"){
        Date_all=c(Date_all,paste0(n1[i]-1,",",MD[[1]][2],",",MD[[1]][3]))
      }else{
        Date_all=c(Date_all,paste0(n1[i],",",MD[[1]][2],",",MD[[1]][3]))
      }
    }  
  }
  
  hrefs=web %>%
    html_nodes('div span[class=\"ml4\"] a') %>%
    html_attr("href")
  
  for(j in 1:length(hrefs)){
    web1=read_html(hrefs[j])
    
    Ns=web1 %>%
      html_nodes('div[class=\"game-info-note capacity\"]') %>%
      html_text()
    
    Attd=str_split(Ns[1],":")
    Attd_n=as.numeric(str_c(str_split(Attd[[1]][2],",")[[1]][1],str_split(Attd[[1]][2],",")[[1]][2]))
    ATTD=c(ATTD,Attd_n)
    
    Cap=str_split(Ns[2],":")
    Cap_n=as.numeric(str_c(str_split(Cap[[1]][2],",")[[1]][1],str_split(Cap[[1]][2],",")[[1]][2]))
    CAP=c(CAP,Cap_n)
    
    p=min(Attd_n/Cap_n,1)
    Pr=c(Pr,paste0(round(p*100,3),"%"))
    print(paste0(n1[i],"-",j))
  }
}

Date1=Date_all[-which(Date_all=="2013,Apr,16")]
Date2=Date1[-which(Date1=="2016,Jan,23")]
#setwd()
BD=as.data.frame(t(rbind(Date2,ATTD,CAP,Pr)))

library(dplyr)
BD_F=BD %>%
  filter(CAP==18624)
write.csv(BD_F,"Celtics.csv")
