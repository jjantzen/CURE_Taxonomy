#Taxonomy script to be used with Taxonomy.Rmd

#Remember that lines starting with a "#" are comments and will not be run by the program
#You can run each line of code separately or the entire script at once depending on how much text is selected
#We recommend running each line separately so you can see what each line does. It also makes it easier to resolve errors that may arise.

#load libraries
library(rotl)
library(dplyr)
library(ape)
library(taxize)

##Generate objects containing the species or genus names of interest

#For birds, we'll look at the genus Sitta or nuthatches. We also include one species of 
#wren (Troglodytes) as an outgroup for phylogenetic analysis. 
birds <- c("Sitta", "Troglodytes aedon")
birds

#For insects, we're using a list of ant species from Alberta, Canada. We have an extra step of 
#converting our object into a vector (list) instead of a dataframe.
ants_df <- read.delim("./Data/Ant_names.txt", header = FALSE, stringsAsFactors = FALSE)
str(ants_df)
ants <- as.vector(ants_df$V1)
str(ants)

#For plants, we have two lists: a list of maple species from Canada with horse chestnut as an outgroup, 
#and a list of conifer genera with Ginkgo as an outgroup.
maples <- c("Acer circinatum", "Acer glabrum", "Acer macrophyllum", "Acer negundo", "Acer nigrum", "Acer pensylvanicum", "Acer rubrum", "Acer saccharum", "Acer saccharinum", "Acer spicatum", "Aesculus glabra")
conifers <- c("Abies", "Thuja", "Picea", "Tsuga", "Ginkgo")
maples
conifers

#For amphibians, we have a list of frog species from BC, Canada with a salamander as an outgroup.
frogs <- c("Anaxyrus boreas", "Spea intermontanus", "Pseudacris maculata", "Hyla regilla", "Rana aurora", "Ascaphus truei", "Rana luteiventris", "Rana pretiosa", "Lithobates catesbeiana", "Lithobates clamitans", "Lithobates pipiens", "Lithobates sylvaticus", "Taricha granulosa")

##Next we resolve any issues with the names (eg synonyms) 

#Match names using the taxonomic name resolution service
#These lines of code will not produce any output to the screen
birds_resolved <- tnrs_match_names(birds)
ants_resolved <- tnrs_match_names(ants)
maples_resolved <- tnrs_match_names(maples)
conifers_resolved <- tnrs_match_names(conifers)
frogs_resolved <- tnrs_match_names(frogs)


## We can get information from these objects

#Inspect entire bird object
birds_resolved

#Get the number of rows of the maple object
nrow(maples_resolved)

#Get the first few rows of the ants object
head(ants_resolved)

#Get the first and third rows of the maples object
maples_resolved[c(1,3),]

#Get the first tO third rows and the first to fifth columns of the conifers object
conifers_resolved[1:3, 1:5]

#Get the "unique_name" and "is_synonym" columns of the frogs object
frogs_resolved$unique_name
frogs_resolved$is_synonym

#For those datasets which now include the correct species names, we can make our new species name lists
frog_species_list <- frogs_resolved$unique_name
maple_species_list <- maples_resolved$unique_name
ant_species_list <- ants_resolved$unique_name

#Examples of *downstream()* and *children()* functions
#The first element in the function can either be a taxonomic name in quotes (eg "Sapindaceae") or 
#an R object that contains a list of taxon names (eg 'conifers')

#Here, we have specified to get names down to the species level
sapindaceae_species <- downstream("Sapindaceae", downto = "species", db = "itis")

#The children function only retrieves the level immediately below, so here we are retrieving the genus names
sapindaceae_genera <- children("Sapindaceae", db = "itis")


#Now we will get species names for those datasets without species names (ie birds, conifers)

#Note that for our bird dataset, we don't want to get species name information for the outgroup because 
#it is already a species binomial not a genus name
birds

#Although we could just type the name "Sitta" in as our query, we will edit our list by 
#omitting the last entry (the outgroup) from the list. While it would be easy to do this for
#our very short list of taxa, if we had a longer list it wouldn't be feasible to do manually
#We'll break this down into its component steps
#Note: you do not need to change any of the code for this section
#Don't worry if you do not understand the code; this may be a first introduction for you
#This is a demonstration of how to manipulate objects in R so you can see what code can do

#First, we want to know how long the list is
#length() is a function to get the length of a list
length(birds)

#We want to get rid of the last entry (the Nth entry for a list of length N) for this query so 
#we use the '-' symbol to indicate we want to remove this entry, using the [ ] we had used earlier to 
#subset our data.
birds[-(length(birds))]

#We now have the version of the list we want for the query so we can insert it into our function
species_birds <- downstream(birds[-(length(birds))], downto = "species", db = "itis")
species_birds

#We can compare the other function for getting species names for same bird dataset. Are the results the same?
species_birds2 <- children(birds[-(length(birds))], db = "itis")
species_birds2

#If we want to create our final list of bird species including our ougroup, we can now 
#add our last entry from the original taxon list back (omitting the "-" now becasue we want to 
#include only that entry instead of exlcuding it)
bird_species_list <- c(species_birds$Sitta$taxonname, birds[(length(birds))])
bird_species_list

#We can now get species names for conifers - all the names in the list are genus names so 
#we can query the entire list
species_conifers <- downstream(conifers, downto = "species", db = "itis")
species_conifers

#Now you have a list of dataframes for the conifers with a different dataframe for each genus, but 
#you want the names as a single list

#We will now do some data manipulation that R makes simpler and more reproducible than 
#cutting and pasting in Excel

#We can retrieve the list of species within each genus using the $ symbol which retrieves a specific column
#For example, within the 'species_conifers' list, we can specify the 'Abies' dataframe and 
#the 'taxonname' column which includes the species names
species_conifers$Abies
species_conifers$Abies$taxonname

#We will take these five lists of names and join them into one list using the c() function
conifer_species_list <- c(species_conifers$Abies$taxonname, species_conifers$Thuja$taxonname, 
                          species_conifers$Picea$taxonname, species_conifers$Tsuga$taxonname, 
                          species_conifers$Ginkgo$taxonname)

#We now have five lists of species for our five groups of organisms
conifer_species_list
bird_species_list
frog_species_list
maple_species_list 
ant_species_list 

#write the objects to files - saving these files for future reference

write.table(conifer_species_list, "./Output/conifer_species_names.txt", sep = "\t", col.names = FALSE, row.names = FALSE)
write.table(bird_species_list, "./Output/bird_species_names.txt", sep = "\t", col.names = FALSE, row.names = FALSE)
write.table(frog_species_list, "./Output/frog_species_names.txt", sep = "\t", col.names = FALSE, row.names = FALSE)
write.table(maple_species_list, "./Output/maple_species_names.txt", sep = "\t", col.names = FALSE, row.names = FALSE)
write.table(ant_species_list, "./Output/ant_species_names.txt", sep = "\t", col.names = FALSE, row.names = FALSE)

write.csv(birds_resolved, "./Output/birds_OTT_IDs.csv", row.names = FALSE)
write.csv(conifers_resolved, "./Output/conifers_OTT_IDs.csv", row.names = FALSE)
write.csv(frogs_resolved, "./Output/frogs_OTT_IDs.csv", row.names = FALSE)
write.csv(maples_resolved, "./Output/maples_OTT_IDs.csv", row.names = FALSE)
write.csv(ants_resolved, "./Output/ants_OTT_IDs.csv", row.names = FALSE)
