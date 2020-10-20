#====Setting folder location====
getwd() #get working directory
setwd("D:/3. Datascience/1. R Studio/3. Project R/dashboard_subsurf_uir")

#Membaca data CSV equinor
#Manual
#Otomatis

volve <- read.csv("D:/3. Datascience/1. R Studio/3. Project R/dashboard_subsurf_uir/PROD_EQUINOR.csv")

#==============Melihat data gimana============
str(volve)
summary(volve)
head(volve)
tail(volve)
names(volve)

#==========indexing===============
a <- volve[1:5,1:5]

#==========merubah date============
library(lubridate)
a$date <- dmy(a$DATEPRD)
a <- select(a,date,everything()) 
a <- select(a,-DATEPRD)

colnames(a)[2] <- "well"
  
#============Data processing=============
library(dplyr)
#select
a <- select(volve,c(DATEPRD,BORE_OIL_VOL,BORE_GAS_VOL,BORE_WAT_VOL))
a <- volve[,c(1,4,16:24)]

#filtering
a <- filter(a, BORE_WAT_VOL>=0)

#Arange
a <- arrange(a,NPD_WELL_BORE_NAME,DATEPRD)
a$year <- year(a$date)

#summary #mutate
library(magrittr) #pipe

a.yr <- a %>% group_by(year,well) %>% summarise(NPOIL=sum(BORE_OIL_VOL),
                                                NPGAS=sum(BORE_GAS_VOL),
                                                NPWAT=sum(BORE_WAT_VOL))

#==========Plotting===================
library(ggplot2)
library(patchwork)

p1<-ggplot() + geom_point(data = a,aes(date,BORE_OIL_VOL,color=well))+
  ggtitle("OIL PROD DAILY") + theme_bw()

p2<-ggplot() + geom_line(data = a.yr, aes(year,NPOIL))

p3 <- ggplot(data = a.yr, aes(year,NPOIL,fill=well)) + geom_bar(stat = 'identity') + ggtitle("kontribusi tahunan")

p4<-ggplot(data = a.yr, aes(x='', y=NPOIL, fill=well)) + geom_bar(stat = 'identity') +coord_polar('y',start = 0)

#menggabungkan
p1|p2/(p3|p4)
