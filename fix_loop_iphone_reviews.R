#Alteração nas linhas 49 e 50

#installing packages
install.packages("tidytext")
install.packages("tidyverse")
install.packages("rvest")
install.packages("dplyr")
install.packages("readr")
install.packages("stringr")
install.packages("forcats")

#Loading libraries
library(tidytext)
library(tidyverse)
library(rvest)
library(readr)
library(forcats)

#start with an empty data frame
iphone_reviews <- data.frame() 
#colocar nomes para as colunas (text e rate) e a primeira linha vazia

# base url has everything by the last number, which indicates page number
base_url <- "https://www.amazon.com/Apple-iPhone-XR-Fully-Unlocked/product-reviews/B07P6Y8L3F/ref=cm_cr_dp_d_show_all_btm?ie=UTF8&reviewerType=all_reviews&pageNumber="

# create a for loop for page number
for (i in 1:5){
  # add base url to page number
  url <- paste0(base_url, i)
  
  # read in html file
  amazon_reviews <- read_html(url)
  
  # get nodes
  review_text <- amazon_reviews %>%
    html_nodes(".review-text-content") %>%
    html_text()
  
  review_rate <- amazon_reviews %>%
    html_nodes(".a-icon-alt") %>%
    html_text() %>%
    tail(10)
 
  # bind rows of this page data frame with the rest of the data
  iphone_reviews = bind_rows(iphone_reviews, #rbind()
                              data.frame(text = review_text,
                                         rate = review_rate))%>%
    #mutate(across(where(is.character), str_trim))%>%
    mutate(across(where(is.character), str_replace, pattern = "\\.", replacement = "\\. "))%>%
    mutate(across(where(is.character), str_squish))
}
