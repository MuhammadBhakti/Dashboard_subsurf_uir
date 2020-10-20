#==================WD======================
#Setting working directory (folder kerja)
getwd() #menampilkan working directory saat ini
setwd("D:/3. Datascience/1. R Studio/3. Project R/dashboard_subsurf_uir")

#------------------Input-------------------
#Memasukkan dataset kedalam R
##Pastikan tipe file nya apa?

volve <- read.csv("PROD_EQUINOR.csv")

#------------------Manipulation------------
library(lubridate)
volve$date <- dmy(volve$DATEPRD)

#A little bit data manipulations
library(magrittr)
volve$WC <- volve$BORE_WAT_VOL / (volve$BORE_OIL_VOL + volve$BORE_WAT_VOL) # watercut
volve$GOR <- volve$BORE_GAS_VOL/volve$BORE_OIL_VOL # GOR

#---------------Plotting-------------------
#Plotting
library(ggplot2)

ggplot() + geom_point(data = volve, aes(date,BORE_OIL_VOL,color=WELL_BORE_CODE)) + theme_bw()
ggplot() + geom_point(data = volve, aes(date,AVG_DOWNHOLE_PRESSURE,color=WELL_BORE_CODE)) + theme_bw()
ggplot() + geom_line(data = volve, aes(date,WC,color=WELL_BORE_CODE)) + theme_bw() + coord_cartesian(ylim = c(0,1)) + facet_wrap(~WELL_BORE_CODE)
ggplot() + geom_line(data = volve, aes(date,GOR,color=WELL_BORE_CODE)) + theme_bw()

#Tambahan untuk data welltesting


#drilling
