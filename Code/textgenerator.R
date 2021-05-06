###
# Automatic Text Generator
# Ueli Schmid, May 2020
# Assignment for course 'Writing Technology'
# Spring Semester 2021, ETH Zurich
###



# setup -------------------------------------------------------------------
pattern_type <- "character" # either 'character' or 'word'
pattern_length <- 3 # integer larger than 1
source_text_name <- "obama_2009_inaugural.txt"

library(tidyverse)


# clean text --------------------------------------------------------------
source_text <- read_file(str_c("Data/", source_text_name))

# replace linebreak by space
source_text <- str_replace_all(source_text, "\\n", " ")

# replace double spaces
source_text <- str_replace_all(source_text, "  ", " ")

# all lower cases
source_text <- tolower(source_text)

sort(unique(str_split(source_text, "")[[1]]))
