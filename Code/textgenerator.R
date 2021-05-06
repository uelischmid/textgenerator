###
# Automatic Text Generator
# Ueli Schmid, May 2020
# Assignment for course 'Writing Technology'
# Spring Semester 2021, ETH Zurich
###



# setup -------------------------------------------------------------------
pattern_type <- "character" # either 'character' or 'word'
pattern_length <- 4 # pattern length (integer larger than 1)
output_length <- 200 # number of characters in output
source_text_name <- "obama_2009_inaugural.txt"
random_seed <- 123 # seed for random number generator

library(tidyverse)


# clean text --------------------------------------------------------------
source_text <- read_file(str_c("Data/", source_text_name)) %>% 
  str_replace_all("\\n", " ") %>% # replace linebreak by space
  str_squish() %>% # replace double spaces
  tolower() # all lower cases

sort(unique(str_split(source_text, "")[[1]]))



# split text --------------------------------------------------------------
if(pattern_type == "character") {
  text_length_char <- str_length(source_text)
  
  # add first characters at the end to ensure every combination of characters
  start2end_char <- str_c(" ", str_sub(source_text, 1, (pattern_length - 2)))
  text_char_extended <- str_c(source_text, start2end_char)
  
  # break into all chunks of selected pattern length
  patterns_all <- vector(mode = "character", length = text_length_char)
  for (i in 1:text_length_char) {
    patterns_all[i] <- str_sub(text_char_extended, i, (i + pattern_length - 1))
  }
  
  # count the patterns
  pattern_table <- tibble(pattern = patterns_all) %>% 
    count(pattern) %>% 
    mutate(pattern_start = str_sub(pattern, start = 1, end = pattern_length - 1),
           pattern_end = str_sub(pattern, start = -1, end = -1))
  
} else if (pattern_type == "word") {
  # substitute punctuation with dummy-words
  # sort(unique(str_split(source_text, "")[[1]]))
  
  text_word_substituted <- source_text %>% 
    str_replace_all("[.]", " punctperiod ") %>% 
    str_replace_all("[,]", " punctcomma ") %>% 
    str_replace_all("[:]", " punctcolon ") %>% 
    str_replace_all("[;]", " punctsemicolon ") %>% 
    str_squish()
  
  # sort(unique(str_split(text_word_substituted, "")[[1]]))
  
  # split by words
  text_word <- str_split(text_word_substituted, " ")[[1]]
  text_length_word <- length(text_word)
  
  # add first words at the end to ensure every combination of words
  text_word_extended <- c(text_word, head(text_word, pattern_length - 1))
  
  # break into all chunks of selected pattern length
  patterns_all <- vector(mode = "character", length = text_length_word)
  for (i in 1:text_length_word) {
    patterns_all[i] <- str_c(text_word_extended[i:(i + pattern_length - 1)],
                             collapse = " ")
  }
  
  # count the patterns
  pattern_table <- tibble(pattern = patterns_all) %>% 
    count(pattern) %>% 
    mutate(pattern_vec = map(pattern, ~str_split(.x, " ")[[1]]),
           pattern_start = map(pattern_vec, ~.x[1:(pattern_length - 1)]),
           pattern_end = map(pattern_vec, ~.x[pattern_length]))
}


