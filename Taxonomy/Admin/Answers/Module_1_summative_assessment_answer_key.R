#Answers to Summative Assessment
#Responses may vary to answers here represent a template of one approach
#If scripts run and give the correct output, alternative approaches are valid
#Bonus points may be given for adding or modifying additional arguments within functions,
#such as adding a header, specifying the taxonomic context (context_name in tnrs_match_names function),
#specifying a different taxonomic database, adding column names etc
#The student should provide both the script and the input/output file used as well as a written answer to the question

#####################
#Answer to question 1 (template)

#Student will have made a text file with one name per line with file name ending in .txt or .csv

#They will read the file in using a function like read.delim (or read.csv if they saved it as a .csv file)
list_of_names <- read.delim("./Data/Question1_list.txt", header = FALSE, stringsAsFactors = FALSE)

#They may need to convert dataframe to vector
names <- as.vector(list_of_names$V1)

#They will NEED to run the tnrs_match_names function to resolve names
names_resolved <- tnrs_match_names(names)

#They will NEED to list the input names that were identified as synonyms (TRUE in the is_synonym column)
names_resolved$is_synonym #column with information on synonym or not
names_resolved$search_string #column with input names
names_resolved$unique_name #accepted name

#If they are more comfortable with R, they may do something like:
names_resolved$search_string[which(names_resolved$is_synonym == TRUE)]

#OR

names_resolved %>% 
  filter(is_synonym == TRUE) %>% 
  select(search_string)

#####################
#Answer to question 2 (template)

#The student will select a taxonomic group, ideally at the level of class, order or family, but may also be genus or species

#There are two options for functions to retrieve names at a lower taxonomic level
#The downstream function can retrieve different levels of taxonomic information (here, it is specified to genus)
Cactaceae_genera <- downstream("Cactaceae", downto = "genus", db = "itis")

#The children function only retrieves the level immediately below names
Cactaceae_genera <- children("Cactaceae", db = "itis")

#There are also several ways to count the number of names

#nrow() counts the number of rows, which here equals the number of names
#length() of a vector counts the length of a vector, which could equal the number of names if applied to a single column
#Other approaches are valid given they take into account the structure of the output from the function used above and
#accurately reflect the output

nrow(Cactaceae_genera$Cactaceae)
length(Cactaceae_genera$Cactaceae$taxonname)

#The student NEEDS to save the file using a function (not copy and paste)
#Extra arguments within the function are not necessary (eg row.names or col.names)
write.csv(Cactaceae_genera$Cactaceae, "./Data/output_names.csv", row.names = FALSE)

#OR

write.table(Cactaceae_genera$Cactaceae, "./Data/output_names.txt", sep = "\t", row.names = FALSE)


