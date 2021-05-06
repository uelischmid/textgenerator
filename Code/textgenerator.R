###
# Automatic Text Generator
# Ueli Schmid, May 2020
# Assignment for course 'Writing Technology'
# Spring Semester 2021, ETH Zurich
###



# setup -------------------------------------------------------------------
pattern_type <- "character" # either 'character' or 'word'
pattern_length <- 4 # pattern length (integer larger than 1)
source_text_name <- "obama_2009_inaugural.txt"
random_seed <- 123 # seed for random number generator

library(tidyverse)


# clean text --------------------------------------------------------------
source_text <- read_file(str_c("Data/", source_text_name))

# replace linebreak by space
source_text <- str_replace_all(source_text, "\\n", " ")

# replace double spaces
source_text <- str_squish(source_text)

# all lower cases
source_text <- tolower(source_text)

sort(unique(str_split(source_text, "")[[1]]))



# split text --------------------------------------------------------------
### pattern_type == "character"
text_length <- str_length(source_text)

# add first characters at the end to ensure every combination of characters
start2end <- str_c(" ", str_sub(source_text, 1, (pattern_length - 2)))
source_text <- str_c(source_text, start2end)

# break into all chunks of selected pattern length
patterns_all <- vector(mode = "character", length = text_length)
for (i in 1:text_length) {
  patterns_all[i] <- str_sub(source_text, i, (i + pattern_length - 1))
}

pattern_table <- tibble(pattern = patterns_all) %>% 
  count(pattern) %>% 
  mutate(pattern_start = str_sub(pattern, start = 1, end = pattern_length - 1),
         pattern_end = str_sub(pattern, start = -1, end = -1))
  
