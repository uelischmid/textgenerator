# *Sham*
## An automatic text generator based on source text probabilities

*Sham* is based on *Travesty*, a computer program published by Hugh Kenner and Joseph O’Rourke in a 1984 article in the magazine BYTE. It is a program written in R that can generate artificial texts based on the language statistics of any input text. It determines the frequency of so-called n-grams, groups of n units, being either characters (letters, punctuation, and spaces) or words, and then builds new texts based on random unit selection following these established probabilities.


Before running the R-script, the user has to specify the input text, decide on the pattern unit (character or word) and length (≥ 2), and the output text length, and set a random seed. When run, *Sham* first transforms line breaks into normal spaces and makes the text a closed loop, as in *Travesty*, by adding the first pattern to the end of the text. If the pattern-units are words, all punctuation is replaced with dummy-words that are re-replaced again before output. The program then extracts all patterns of the chosen length and unit and counts them.


Next, *Sham* initiates the output text with the first n-1 units of the original text. It then filters the table of all extracted patterns and their count and only retains the patterns sharing this beginning. It randomly decides which unit to add to the output text based on the probabilities derived from the pattern counts. This loop is repeated and units added until the specified output length is achieved.


This project was created as the final assignment for the course "Writing Technology: Cyborgs, Cybernetics, and Translating Machines", taught by Philip Gerard in the spring semester 2021 at ETH Zürich.
