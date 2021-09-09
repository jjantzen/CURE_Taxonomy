#Introduction to R script to be used together with Introduction_to_R.pdf/Rmd

#read example csv file into R as an object
example_file <- read.csv("./Data/Introduction_example/Acer_rubrum.csv", 
                         stringsAsFactors = FALSE, header = TRUE)

#look at first few rows of object
head(example_file)

#get number of rows in object
nrow(example_file)

#get number of columns in object
ncol(example_file)

#assign the first row of the data object to a new object
row1 <- example_file[1,]

#look at new row1 object
row1

#assign the first column of data object to a new object
col1 <- example_file[,1]

#view first few rows of the new col1 object
head(col1)

#view structure of the data object
str(example_file)

#Read in the tab-delimited file using the read.delim function - you need to specify that the character "\t" is used to separate columns (the backslash is used to "excape" the t, which means that you are referring to a tab, not the letter t)
txt_file_example_1 <- read.delim("./Data/Introduction_example/Birthdates.txt", sep = "\t", stringsAsFactors = FALSE, header = TRUE)

head(txt_file_example_1)

#If you specify that the separator is a space (" "), the file is not imported correctly, because the separator is actually a tab
txt_file_example_2 <- read.delim("./Data/Introduction_example/Birthdates.txt", sep = " ", stringsAsFactors = FALSE, header = TRUE)

head(txt_file_example_2)

#Alternatively, if the separator is actually a space and not a tab, the separator needs to be specified as sep = " "
#If you specify that the separator is a space (" "), the file is not imported correctly, because the separator is actually a tab
txt_file_example_3 <- read.delim("./Data/Introduction_example/Birthdates_space.txt", sep = " ", stringsAsFactors = FALSE, header = TRUE)

head(txt_file_example_3)


#To compare, read in the original csv file using the read.delim function, specifying that the separator is a comma
example_file_delim <- read.delim("./Data/Introduction_example/Acer_rubrum.csv", sep = ",", stringsAsFactors = FALSE, header = TRUE)

head(example_file_delim)

