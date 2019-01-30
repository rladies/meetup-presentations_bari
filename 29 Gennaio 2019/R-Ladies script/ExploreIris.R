#carichiamo il pacchetto dataset
library(datasets)

#per avere una lista completa dei dataset presenti
library(help = "datasets")

#scegliamo il dataset iris come caso da analizzare
iris<-iris

#per visualizzare il dataset
View(iris)

#per vedere la struttura del dataset
str(iris)

#----------------------
#-----Esploriamo il dataset
#----------------------
#info sintetiche di tutte le variabili
summary(iris)

#oppure di una singola variabile
summary(iris$Sepal.Length)

#se vogliamo un sottoinsieme del dataset che risponda a certe caratteristiche:
#es. tutte le osservazioni per cui Species è setosa

setosa<-iris[iris$Species=="setosa",]

#eliminiamo la colonna "Species" perché non rilevante
setosa<-setosa[,-5]

install.packages("dplyr")
library(dplyr)
#specificando i nomi delle colonne da eliminare
setosa<-setosa%>%select(-one_of("Species"))

#oppure specificando le colonne che vogliamo tenere
setosa<-setosa[,1:4]

select_var<-colnames(iris)[1:4]
setosa<-setosa%>%select(select_var)

#selezioniamo la variabile Species per tutte le osservazioni per cui Sepal.Length è maggiore del valore medio
sepalLength_upMean<-iris[iris$Sepal.Length>mean(iris$Sepal.Length),"Species"]
sepalLength_upMean<-iris[iris$Sepal.Length>mean(iris$Sepal.Length),5]
sepalLength_upMean
#sepalLength<-iris[iris$Sepal.Length>mean(iris$Sepal.Length),"Species"]
#rm()

#vediamo se c'è una specie prevalente
table(sepalLength_upMean)

#immaginiamo di agire direttamente sul dataset iris
#aggiungiamo una colonna che assuma valore "SI" se Sepal.Length è > media, NO altrimenti
iris$sepalLength_upMean<-ifelse(iris$Sepal.Length>mean(iris$Sepal.Length),"SI","NO")
table(iris$sepalLength_upMean)

table(iris$sepalLength_upMean,iris$Species)

#----------------------
#-----Visualizziamo i dati
#----------------------
install.packages("ggplot2")
library(ggplot2)

ggplot(iris, aes(x = Petal.Length, y = Sepal.Length)) + 
  geom_point() +
  #geom_point(color="blue") +
  ggtitle('Iris Species by Petal and Sepal Length')

#specifichiamo i colori condizionatamente ad una variabile
ggplot(iris, aes(x = Petal.Length, y = Sepal.Length, colour = Species)) + 
  geom_point() +
  ggtitle('Iris Species by Petal and Sepal Length')

#specifichiamo la trasparenza condizionatamente ad una variabile
ggplot(iris, aes(x = Petal.Length, y = Sepal.Length, colour = Species, alpha=Petal.Width)) + 
  geom_point() +
  ggtitle('Iris Species by Petal and Sepal Length')


#inseriamo altri dettagli
ggplot(iris, aes(x = Petal.Length, y = Sepal.Length, color = Species, alpha=Petal.Width)) + 
  geom_point() +
  ggtitle('Iris Species by Petal and Sepal Length')+
  theme_grey()+
  scale_color_manual(values = c("purple","green","blue"))+
  guides(color=FALSE)

#theme_
?theme

ggplot(iris, aes(x=Species,y=Petal.Length, fill=Species)) + 
  geom_boxplot(outlier.colour="red", outlier.shape=8,
               outlier.size=4)+
  #coord_flip()+
  

pairs(iris[,1:4],col=iris[,5],oma=c(4,4,6,12))
par(xpd=TRUE)
legend(0.85,0.6, as.vector(unique(iris$Species)),fill=c(1,2,3))

#analisi correlazione
install.packages("corrplot")
library(corrplot)

cor(iris[,1:4])
corrplot(cor(iris[,1:4]))
corrplot.mixed(cor(iris[,1:4]))
