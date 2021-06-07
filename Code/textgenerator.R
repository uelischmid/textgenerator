###
# -- SHAM --
# Automatic Text Generator
# Ueli Schmid, May-June 2021
# Assignment for course 'Writing Technology'
# Spring Semester 2021, ETH Zurich
###


# setup -------------------------------------------------------------------
source_text_name <- "example.txt"

pattern_type <- "character" # either 'character' or 'word'
pattern_length <- 4 # pattern length (integer larger than 1)
all_lowercase <- TRUE # should text be reduced to lowercase?

output_length <- 150 # number of characters or words in output
output_name <- "example_output.txt"

random_seed <- 1 # seed for random number generator

suppressMessages(library(tidyverse))
set.seed(random_seed)

# clean text --------------------------------------------------------------
source_text <- read_file(str_c("Data/", source_text_name)) %>% 
  str_replace_all("\\n", " ") %>% # replace linebreak by space
  str_squish() # replace double spaces
  
if(all_lowercase == TRUE) {
  source_text <- tolower(source_text)
}

# split text into patterns and count them ---------------------------------
if(pattern_type == "character") {
  text_length_char <- str_length(source_text)
  
  # add first characters at the end to ensure every combination of characters
  start2end_char <- str_c(" ",
                          str_sub(source_text, 
                                  start = 1, 
                                  end = pattern_length)
  )
  text_char_extended <- str_c(source_text, start2end_char)
  
  # break into all chunks of selected pattern length
  patterns_all <- vector(mode = "character", length = text_length_char + 1)
  for (i in 1:(text_length_char + 1)) {
    patterns_all[i] <- str_sub(text_char_extended,
                               start = i,
                               end = (i + pattern_length - 1))
  }
  
  # count the patterns
  pattern_table <- tibble(pattern = patterns_all) %>% 
    count(pattern) %>% 
    mutate(pattern_start = str_sub(pattern,
                                   start = 1,
                                   end = pattern_length - 1),
           pattern_end = str_sub(pattern,
                                 start = -1,
                                 end = -1))
  
} else if (pattern_type == "word") {
  # substitute punctuation with dummy-words
  text_word_substituted <- source_text %>% 
    str_replace_all("[.]", " punctperiod ") %>% 
    str_replace_all("[,]", " punctcomma ") %>% 
    str_replace_all("[:]", " punctcolon ") %>% 
    str_replace_all("[;]", " punctsemicolon ") %>% 
    str_squish()
  
  # split by words
  text_word <- str_split(text_word_substituted, " ")[[1]]
  text_length_word <- length(text_word)
  
  # add first words at the end to ensure every combination of words
  text_word_extended <- c(text_word,
                          head(text_word,
                               n = pattern_length)
                          )
  
  # break into all chunks of selected pattern length
  patterns_all <- vector(mode = "character", length = text_length_word + 1)
  for (i in 1:(text_length_word + 1)) {
    patterns_all[i] <- str_c(text_word_extended[i:(i + pattern_length - 1)],
                             collapse = " ")
  }
  
  # count the patterns
  pattern_table <- tibble(pattern = patterns_all) %>% 
    count(pattern) %>% 
    mutate(pattern_vec = map(pattern,
                             ~str_split(.x, " ")[[1]]),
           pattern_start = map(pattern_vec,
                               ~.x[1:(pattern_length - 1)]),
           pattern_end = map(pattern_vec,
                             ~.x[pattern_length]))
}


# generate random text ----------------------------------------------------
if (pattern_type == "character") {
  # start like the source text starts
  generated_text <- str_sub(source_text,
                            start = 1,
                            end = pattern_length - 1)
  
  # add characters according to probabilities
  while(str_length(generated_text) < output_length) {
    current_pattern <- str_sub(generated_text,
                               start = -(pattern_length - 1),
                               end = -1)
    
    possible_chars <- pattern_table %>% 
      filter(pattern_start == current_pattern)
    next_char <- sample(possible_chars$pattern_end,
                        size = 1,
                        prob = possible_chars$n)
    
    generated_text <- str_c(generated_text, next_char)
  }
} else if (pattern_type == "word") {
  # start like the source text starts
  generated_text <- text_word[1:(pattern_length - 1)]
  
  # add words according to probabilities
  while(length(generated_text) < output_length) {
    current_pattern <- tail(generated_text,
                            n = pattern_length - 1)
    
    possible_words <- pattern_table %>% 
      filter(map_lgl(pattern_start,
                     ~identical(.x, current_pattern)))
    
    next_word <- sample(possible_words$pattern_end,
                        size = 1,
                        prob = possible_words$n)[[1]]
    
    generated_text <- c(generated_text, next_word)
  }
  
  # re-substitute dummy-words with punctuation 
  generated_text <- str_c(generated_text, collapse = " ") %>% 
    str_replace_all(" punctperiod ", ". ") %>% 
    str_replace_all(" punctperiod", ". ") %>% 
    str_replace_all(" punctcomma ", ", ") %>% 
    str_replace_all(" punctcomma", ", ") %>% 
    str_replace_all(" punctcolon ", ": ") %>%
    str_replace_all(" punctcolon", ": ") %>%
    str_replace_all(" punctsemicolon ", "; ") %>% 
    str_replace_all(" punctsemicolon", "; ")
}


# output ------------------------------------------------------------------
sink(str_c("Output/", output_name))
cat("---INPUT---\n")
cat("Source text: ", source_text_name, "\n")
cat("Pattern type: ", pattern_type, "\n")
cat("Pattern length: ", pattern_length, "\n")
cat("       (corresponds to number of characters if type = character,\n")
cat("       (and to number of words incl. punctuation as a word if type = character)\n")
cat("Only lowercase letters: ", all_lowercase, "\n")
cat("Output length: ", output_length, "\n")
cat("Random seed: ", random_seed, "\n\n")
cat("---RESULT---\n")
cat(generated_text)
sink()
