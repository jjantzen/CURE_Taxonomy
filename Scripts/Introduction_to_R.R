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

