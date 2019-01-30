
# Install the yarrr package
install.packages('yarrr')
# Load the package
library(yarrr)

#----------------------
#-----Explore data
#----------------------
?pirates
str(pirates)
# Look at the first few rows of the data
head(pirates)
# What are the names of the columns?
names(pirates) #get/set names of an object
colnames(pirates) #get/set colnames of a matrix-like object

# View the entire dataset in a new window
View(pirates)
# Createan object
dati<-pirates
# Selecting it from the environment pane call the function View()

#---------------------------
#-----Descriptive statistics
#---------------------------
# What is the mean age?
mean(pirates$age)

# What was the tallest pirate?
max(pirates$height)

# How many pirates are there of each sex?
table(pirates$sex)

# Calculate the mean age, separately for each sex
aggregate(formula = age ~ sex,
          data = pirates,
          FUN = mean)

# library(tidyverse)
# dati%>%group_by(sex)%>%summarize(age=mean(age))

#---------------------
#-----Plotting
#----------------------
# Create scatterplot
plot(x = pirates$height, # X coordinates
     y = pirates$weight) # y-coordinates

# Now let’s make a fancier version of the same plot by adding some customization
plot(x = pirates$height, # X coordinates
     y = pirates$weight, # y-coordinates
     main = 'My first scatterplot of pirate data!',
     xlab = 'Height (in cm)', # x-axis label
     ylab = 'Weight (in kg)', # y-axis label
     pch = 16, # Filled circles
     col = gray(.0, .1)) # Transparent gray

#Now let’s make it even better by adding gridlines and a blue regression line to measure the strength of the relationship.
plot(x = pirates$height, # X coordinates
     y = pirates$weight, # y-coordinates
     main = 'My first scatterplot of pirate data!',
     xlab = 'Height (in cm)', # x-axis label
     ylab = 'Weight (in kg)', # y-axis label
     pch = 16, # Filled circles
     col = gray(.0, .1)) # Transparent gray
grid() # Add gridlines

# Create a linear regression model
model <- lm(formula = weight ~ height,
            data = pirates)
abline(model, col = 'blue') # Add regression to plot

# chron::is.weekend()
# tseries::is.weekend()

#-----------------------
#-----Hypothesis test 
#------------------------
# Age by headband t-test
t.test(formula = age ~ headband,
       data = pirates,
       alternative = 'two.sided')

cor.test(formula = ~ height + weight,
         data = pirates)

#Now, let’s do an ANOVA testing if there is a difference between the number of tattoos pirates have based on their favorite sword
# Create tattoos model
tat.sword.lm <- lm(formula = tattoos ~ sword.type,
                   data = pirates)
# Get ANOVA table
anova(tat.sword.lm)

# Create a linear regression model: DV = tchests, IV = age, weight, tattoos
tchests.model <- lm(formula = tchests ~ age + weight + tattoos,
                    data = pirates)
# Show summary statistics
summary(tchests.model)