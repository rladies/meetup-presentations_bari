#install.packages("readr")
#install.packages("dplyr")
#install.packages("tidyverse")

#1. IMPORT LIBRARY
library(readr)
library(tidyverse)
#library(dplyr)

Employee_Diversity_in_Tech <- 
  read_delim("~/GitHub/RLadies/meetup-presentations_bari/201903 - Marzo/dataset/Employee Diversity in Tech.csv", 
                                         ";", escape_double = FALSE, trim_ws = TRUE)


#2. DATASET EXPLORATION
summary(Employee_Diversity_in_Tech)
glimpse(Employee_Diversity_in_Tech)

head(Employee_Diversity_in_Tech)
head(Employee_Diversity_in_Tech, n = 10)
tail(Employee_Diversity_in_Tech)
str(Employee_Diversity_in_Tech)

names(Employee_Diversity_in_Tech)
nrow(Employee_Diversity_in_Tech)
ncol(Employee_Diversity_in_Tech)

# random rows dal dataset
sample_n(Employee_Diversity_in_Tech, 5)
sample_frac(Employee_Diversity_in_Tech, 0.1)

#3. DYPLR FUNCTIONS

# Function        Description

# select() =      Select columns
# filter() =      Filter rows
# group_by() =    Allows for group operations in the "split-apply-combine" concept
# arrange() =     Re-order or arrange rows
# mutate() =      Create new columns
# summarize() =   Summarize values

##### SELECT 

?select

# Select Columns With Select()

selezione <- select(Employee_Diversity_in_Tech, Data = Date, Tipo = Type, Azienda = Company)

# To select all the columns except a specific column, use the "-" (subtraction) operator.

head(select(Employee_Diversity_in_Tech,  -"% Undeclared"))

# To select a range of columns by name, use the ":" (colon), operator
head(select(Employee_Diversity_in_Tech, Date:Company))

# To select all columns that start with the character string "%", use the function starts_with()
head(select(Employee_Diversity_in_Tech, starts_with("%")))

# You can also select columns based on specific criteria with:
# ends_with() = Select columns that end with a character string
# contains() = Select columns that contain a character string
# matches() = Select columns that match a regular expression
# one_of() = Select columns names that are from a group of names


###### EXTRA

#remove % from colnames
?gsub
colnames(Employee_Diversity_in_Tech) <- gsub( "[\t\n\r\v\f %]", "", colnames(Employee_Diversity_in_Tech))
colnames(Employee_Diversity_in_Tech)

####### FILTER

?filter

# Select Rows With Filter()
# To filter the rows for you can use:
  filter(Employee_Diversity_in_Tech, Female > 50)

# To filter the rows for , you can use:
  filter(Employee_Diversity_in_Tech, Female >= 50, Male >= 50)

###### Pipe Operator: %>%
   
#   Now we are going to talk about the pipe operator: %>%. 
#   This operator allows you to pipe the output from one function to the input of another function.
# 
#   Let's pipe the Employee_Diversity_in_Tech data frame to the function that will select two columns 
#   Then it will pipe the new data frame to the function head(), which will return the head of the new data frame.

  
#####
  Employee_Diversity_in_Tech %>%
  select(Date, Type, Company) %>%
  head
#####

  
####### GROUP BY

?group_by
  
# Group Operations Using Group_by()

# The group_by() verb is an important function in dplyr. 
# We want to split the data frame by some variable (e.g. Type), 
# apply a function to the individual data frames, and then combine the output.
# We split the iris data frame by the Company, then ask for the same summary statistics as above.
Employee_Diversity_in_Tech %>%
    group_by(Type) %>%
    summarise(avg_Female = mean(Female),
              avg_Male = mean(Male),
              total = n())

Employee_Diversity_in_Tech %>%
    group_by(Company) %>%
    summarise(avg_Female = mean(Female),
              avg_Male = mean(Male),
              total = n()) 
  
   Employee_Diversity_in_Tech %>%
     group_by(Type, Company) %>%
     summarise(avg_Female = mean(Female),
               avg_Male = mean(Male),
               total = n())

#######  ARRANGE
?arrange
  
# Arrange Rows With Arrange()
# 
# To arrange rows by a particular column, such as the 'Female', 
# list the name of the column you want to arrange the rows by.


   Employee_Diversity_in_Tech %>%
     group_by(Type, Company) %>%
     arrange(desc(Female))

# Now, we will select four columns from the dataset
# arrange the rows by Female, then arrange the rows by Asian
# Finally, we will show the head of the final data frame.

  Employee_Diversity_in_Tech %>%
  select(Date, Type, Company, Female, Asian) %>%
  arrange(Female, Asian) %>%
  head()
  
#######  MUTATE
?mutate
# Create New Columns With Mutate()
# The mutate() function will add new columns to the data frame. 
# Create a new column called proportion, which is the ratio of Female to Male.
  Employee_Diversity_in_Tech %>%
  mutate(tot = Female + Male) %>%
  head
######## SUMMARISE
?summarise
# Create Summaries of the Data Frame With Summarize()

# The summarise() function will create summary statistics for a given column in the data frame. 

  
  Employee_Diversity_in_Tech %>%
    group_by(Company) %>%
    summarise(avg_Female = mean(Female),
              avg_Male = mean(Male),
              total = n()) %>%
    arrange(desc(avg_Female))  %>%
  head()

### EXTRA
# utilizzare il campo 'Date' per altre operazioni 
  
#ESEMPIO
  
  Employee_Diversity_in_Tech %>%
    group_by(Date) %>%
    summarise(avg_Female = mean(Female),
              avg_Male = mean(Male),
              total = n()) %>%
    arrange(desc(Date))
  
