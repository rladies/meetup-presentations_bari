#Data Cleaning with R
#R-Ladies Bari
#July 23, 2019

# TIME?

#HINT -> use help() or ?function to get help 


# 1. set the working directory
?setwd()

# 2. load required packages#### HINT: dplyr; stringr; reshape


# 3. import dataset####
#may need to give path if .csv is not in current working directory


# 4. inspect your data####

# 4.1 first six rows of dataset
# 4.2 variable names
# 4.3 dimensions of data frame
# 4.4 how many NAs do we have per variable
# 4.5 data-viewer
# 4.6 display internal structure

# 5. dealing with missing values####

#replace blanks/spaces with NAs
your_dataset[your_dataset==""| your_dataset==" "] = NA

#Question: this command only works for character variables, not factor variables. why?

#for factor variables:
your_dataset <- your_dataset %>%
  mutate_if(is.factor, funs(factor(replace(., .=="" | .==" ", NA))))

#Question: What do you do when there are text NAs where actual NAs should be?


#we can solve all of the problems above by changing the arguments when importing data:



# 6. variable types ####

# 6.1 find out what class each variable in the dataset is

#Question: why don't we have any character variables?

# 6.2 to change this, and reimport the dataset with strings as characters we could run:



# 7. change class of variable ####

class(your_dataset$NEIGHBORHOOD)

#Question: what if we want to consider a character variable as a factor?
#in this dataset, "NEIGHBORHOOD" is the most likely factor variable since it has discernable levels

# 7.1 factor variables have levels. 


# notice that some of these levels are redundant


# 8. dealing with inconsistent values, e.g. in free text fields (Question)####
#white space in variable values
#https://bookdown.org/lyzhang10/lzhang_r_tips_book/how-to-deal-with-empty-spaces.html

help(str_trim)


# 9. capitalization in variable values using grep (Question)

unique(your_dataset$NEIGHBORHOOD)

# 9.1 CITY cITY cItY -> NEIGHBORHOOD variable 
#NB: str_trim and grepl operate on character vectors so they likely coerce NEIGHBORHOOD to character

# 9.2 let's check our work
unique(your_dataset$NEIGHBORHOOD)
levels(your_dataset$NEIGHBORHOOD)
class(your_dataset$NEIGHBORHOOD)

your_dataset$NEIGHBORHOOD <- as.factor(your_dataset$NEIGHBORHOOD) #now we are back to meaningful levels

# 10. reshaping / pivoting data####

# 10.1 right now our data is in 'long' format, if we wanted to organize by NEIGHBORHOOD and put the data in 'wide' format, we could use reshape() in Base R:
markets_wide <- reshape(your_dataset, idvar = "NEIGHBORHOOD", timevar = "OBJECTID", direction = "wide")
View(markets_wide)
#to pivot data, we can use the reshape package and the melt and cast functions

#11 saving out your cleaned dataset####
#this is useful so you don't need to repeat each of these steps for future analysis!
#save the script you clean your data in, and save a copy of the raw data for reference

