#### 1.0 INSTALL PACKAGE
# Funzione per installare pacchetti install.packages("") 

install.packages("devtools")
install.packages("tidyverse")
install.packages("textstem")
#install.packages("reshape2")
install.packages("igraph")
install.packages("ggraph")
install.packages("quanteda")
install.packages("NLP")

#### 1.1 IMPORT LIBRARY
#funzione per caricare i pacchetti library() - da caricare in memoria ad ogni accesso in RStudio

library(devtools)  #caricamento pacchetti da repository non ufficiali (es. CRAN) 
library(tidyverse) #manipolazione dei dati
library(tidytext)  #ordinare i testi
library(textstem)  #Strumenti per Stemming e Lemmatizzare il testo
#library(reshape2)
library(igraph)    #grafici network
library(ggraph)    #grafici grafi e network
library(quanteda)  #quantitative analysis for textual data
library(NLP)       #natural language processing

#### 1.2 INSTALL FROM GITHUB HARRY POTTER LIBRARY

devtools::install_github("bradleyboehmke/harrypotter")
library(harrypotter)


#### 2.0 DATA MINING
# diamo uno sguardo a come si presenta il testo: INPUT
philosophers_stone[1]

#### 2.1 CREATING A CORPUS
#il corpus è un oggetto che permette di organizzare il nostro input 
#in una struttura analizzabile
corpus <- corpus(philosophers_stone)

#### 2.2 CREATING TOKENS
#eseguiamo le operazioni di tokenizzazione, 
#rimozione di caratteri speciali e stop words 
tokens <- quanteda::tokens(corpus,"word",  remove_numbers = T, remove_punct = T,
               remove_symbols = T, remove_separators = TRUE,
               remove_twitter = T, remove_hyphens = T, remove_url = T,
               ngrams = 1L, skip = 0L, concatenator = "_",
               verbose = quanteda_options("verbose"), include_docvars = TRUE) %>%
  tokens_remove(stop_words$word)

#### 2.3 LEMMATIZE A VECTOR OF STRINGS
#sovrascrivere vettore tokens
tokens <- lemmatize_strings(tokens, dictionary = lexicon::hash_lemmas)

# visualizzare i primi 30 token del text1: OUTPUT
tokens[1:50]

#### 2.4 CREATE A DOCUMENT-FEATURE MATRIX
dfm <- dfm(tokens)
#vediamo un estratto della tabella per capire come si presentano i dati
dfm[1:10,1:10]

#vettore di colori per la wordcloud
color <- c("darkorchid4","magenta3","darkorchid","magenta4")

#3 WORDCLOUD
textplot_wordcloud(dfm,max.words = 120,rotation = 0.3,min_size = 1.3, max_size = 9,colors=color,labelsize = 8)

# #4 DATA QUALITY
# 
# #4.1 REMOVE WORD 'HARRY' from TOKENS
# tokens <- gsub("Harry","",tokens)
# 
# #4.2 NEW DOCUMENT-FEATURE MATRIX
# 
# dfm2 <- dfm(tokens)
# 
# #5 CLEANED WORDCLOUD
# textplot_wordcloud(dfm2,max.words = 100,rotation = 0.3,min_size =1.3, max_size = 9,colors=color,labelsize = 8)
# 


#5 NETWORK

lemma_translator <- function(MyLemma){
  MyTextList <- as.character(gsub("\n", " ",paste(unlist(as.String(MyLemma)))))
  return(MyTextList)
}

text <- data.frame(text=lemma_translator(tokens))

#creiamo le coppie di termini consecutivi
n_gram <- text %>%
  unnest_tokens(ngram, text, token = "ngrams", n = 2)

bigram <- data.frame(ngram=n_gram[,"ngram"])

bigram_sep <- bigram %>%
  separate(ngram, c("word1", "word2"), sep = " ")

#e cotiamo le volte in cui le coppie di termini compaiono
bigram_counts <- bigram_sep %>% 
  dplyr::count(word1, word2, sort = TRUE)

bigram_counts <- bigram_counts[!is.na(bigram_counts$word1)|!is.na(bigram_counts$word2),]

#diamo uno sguardi al risultato
head(bigram_counts)

#prepariamo i dati per la rappresentazione grafica
bigram_graph <- bigram_counts %>%
  filter(n >= 10) %>% #filtra solo le coppie di termini che compaiono almeno 10 volte
  graph_from_data_frame()

#network dei termini
set.seed(9999)

ggraph(bigram_graph, layout = "igraph",algorithm = "nicely") +
  geom_edge_link(edge_colour="magenta4",aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "magenta3", size = 2) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1) +
  theme_void() +
  theme(plot.margin =margin(t = 20, r =20, b = 20, l = 20, unit = "pt"))
