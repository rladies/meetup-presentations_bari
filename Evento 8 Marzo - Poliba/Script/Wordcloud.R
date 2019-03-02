



library(devtools)
library(tidyverse)      
library(tidytext)
library(textstem)
#library(reshape2)
library(igraph)
library(ggraph)
library(quanteda)
library(NLP)

devtools::install_github("bradleyboehmke/harrypotter")
library(harrypotter)

corpus<-corpus(philosophers_stone)
tokens<-quanteda::tokens(corpus,"word",  remove_numbers = T, remove_punct = T,
               remove_symbols = T, remove_separators = TRUE,
               remove_twitter = T, remove_hyphens = T, remove_url = T,
               ngrams = 1L, skip = 0L, concatenator = "_",
               verbose = quanteda_options("verbose"), include_docvars = TRUE)%>%
  tokens_remove(stop_words$word)

tokens$text1[1:30]

tokens<-lemmatize_strings(tokens, dictionary = lexicon::hash_lemmas)

dfm<-dfm(tokens)

color<-c("darkorchid4","magenta3","darkorchid","magenta4")
textplot_wordcloud(dfm,max.words = 120,rotation = 0.3,min_size = 1.3, max_size = 9,colors=color,labelsize = 8)

tokens<-gsub("Harry","",tokens)
dfm2<-dfm(tokens)

textplot_wordcloud(dfm2,max.words = 100,rotation = 0.3,min_size =1.3, max_size = 9,colors=color,labelsize = 8)

lemma_translator <- function(MyLemma){
  MyTextList <- as.character(gsub("\n", " ",paste(unlist(as.String(MyLemma)))))
  return(MyTextList)
}

text<-data.frame(text=lemma_translator(tokens))


n_gram<-text %>%
  unnest_tokens(ngram, text, token = "ngrams", n = 2)
bigram<-data.frame(ngram=n_gram[,"ngram"])
bigram_sep<-bigram %>%
  separate(ngram, c("word1", "word2"), sep = " ")
bigram_counts<-bigram_sep %>% 
  dplyr::count(word1, word2, sort = TRUE)
bigram_counts<-bigram_counts[!is.na(bigram_counts$word1)|!is.na(bigram_counts$word2),]


bigram_graph <- bigram_counts %>%
  filter(n >= 10) %>%
  graph_from_data_frame()
bigram_graph
set.seed(9999)
ggraph(bigram_graph, layout = "igraph",algorithm = "nicely") +
  geom_edge_link(edge_colour="magenta4",aes(edge_alpha = n, edge_width = n)) +
  geom_node_point(color = "magenta3", size = 2) +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)+
  theme_void()+
  theme(plot.margin =margin(t = 20, r =20, b = 20, l = 20, unit = "pt"))
