# Dashboard_subsurf_uir
Proyek data science dengan tim teknik perminyakan UIR

Pada proyek ini akan digunakan data-data open source dari lapangan volve equinor untuk membuat contoh dashboard yang sering digunakan untuk monitoring dan surveillance.
```{}
volve <- read.csv("PROD_EQUINOR.csv")

library(lubridate)
volve$date <- dmy(volve$DATEPRD)
volve <- select(volve,date,everything()) 
volve <- select(volve,-DATEPRD)

colnames(volve)[2] <- "well"
#create new table
a <- select(volve,c(date,well,BORE_OIL_VOL,BORE_GAS_VOL,BORE_WAT_VOL))
#filtering
a <- filter(a, BORE_WAT_VOL>=0)
#add year
a$year <- year(a$date)

#summary #mutate
library(magrittr) #pipe

a.yr <- a %>% group_by(year,well) %>% summarise(NPOIL=sum(BORE_OIL_VOL),
                                                NPGAS=sum(BORE_GAS_VOL),
                                                NPWAT=sum(BORE_WAT_VOL))
```


## 1. Scatter Plot
```{r}
library(ggplot2)
ggplot() + geom_point(data = a,aes(date,BORE_OIL_VOL,color=well))+ ggtitle("OIL PROD DAILY") + theme_bw()
```

![image](https://user-images.githubusercontent.com/49467005/140599257-8cedc8c7-c62e-4ed9-80f3-d2990c7b70c5.png)

```{r}
ggplot(data = a.yr, aes(year,NPOIL,fill=well)) + 
  geom_bar(stat = 'identity') + ggtitle("kontribusi tahunan") + theme_bw()
```

## 2. Bar Plot
![image](https://user-images.githubusercontent.com/49467005/140599319-e9b29f5f-9fac-453c-a88d-9884a8749cb8.png)

```{r}
ggplot(data = a.yr, aes(x='', y=NPOIL, fill=well)) + geom_bar(stat = 'identity') +coord_polar('y',start = 0)
```
## 3. Pie Plot
![image](https://user-images.githubusercontent.com/49467005/140599348-56078b6c-2398-4d9c-8a1e-f9cf2cb0269c.png)

## 4. Using Patchwork

```{r}
library(patchwork)
#menggabungkan
p1/(p3|p4)
```
![image](https://user-images.githubusercontent.com/49467005/140599420-22dd326e-6815-4a21-90fb-9b4ac040377a.png)

