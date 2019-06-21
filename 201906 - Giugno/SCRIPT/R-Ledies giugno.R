#----------------------------------------------------------#
#                    R-Ladies:25/06/2019                   #
#              Data Visualization with ggplot2             #
#----------------------------------------------------------#

#Load packages
library(ggplot2)
library(dplyr)

#consider dataset "mpg"
mpg
summary(mpg)

#-------------
# THE BASICS
#------------
#In order to create a plot, you:
  
# 1.  Call the ggplot() function which creates a blank canvas
ggplot(mpg)

# 2.  Specify aesthetic mappings, which specifies how you want to map variables to visual aspects. In this case we are simply mapping the displ and hwy variables to the x- and y-axes.
ggplot(mpg, aes(x = displ, y = hwy))

# 3. You then add new layers that are geometric objects which will show up on the plot. In this case we add geom_point to add a layer with points (dot) elements as the geometric shapes to represent the data.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

#-------------
# ASTHEICS MAPPING
#------------
# The aesthetic mappings take properties of the data and use them to influence visual characteristics, 
# such as position, color, size, shape, or transparency. 
# Each visual characteristic can thus encode an aspect of the data and be used to convey information.
# 
# All aesthetics for a plot are specified in the aes() function call 
# (later in this tutorial you will see that each geom layer can have its own aes specification). 
# For example, we can add a mapping from the class of the cars to a color characteristic:

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# o equivalentemente
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))

#mapping vs assignment
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue")

#-------------------------
# GEOMETRY SHAPES
#-------------------------

# Left column: x and y mapping needed!
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

# Right column: no y mapping needed!
ggplot(data = mpg, aes(x = class)) +
  geom_bar()  

ggplot(data = mpg, aes(x = hwy)) +
  geom_histogram() 

# What makes this really powerful is that you can add multiple geometries to a plot, 
# thus allowing you to create complex graphics showing multiple aspects of your data.

# plot with both points and smoothed line
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

# Of course the aesthetics for each geom can be different, 
# so you could show multiple lines on the same plot (or with different colors, styles, etc). 
# It’s also possible to give each geom a different data argument, 
# so that you can show multiple data sets in the same plot.
# 
# For example, we can plot both points and a smoothed line for the same x and y variable 
# but specify unique colors within each geom:
  
  ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue") +
  geom_smooth(color = "red")

# So as you can see if we specify an aesthetic within ggplot it will be passed on 
# to each geom that follows. 
# Or we can specify certain aes within each geom, which allows us to only show 
# certain characteristics for that specificy layer (i.e. geom_point).
  
  # color aesthetic passed to each geom layer
  ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
    geom_point() +
    geom_smooth(se = FALSE) #se parameter: Display confidence interval around smooth?
  
  # color aesthetic specified for only the geom_point layer
  ggplot(mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(color = class)) +
    geom_smooth(se = FALSE)
#-------------------
#Statistical Transformations
#--------------------
# If you look at the below bar chart, you’ll notice that
# the y axis was defined for us as the count of elements that have the particular type. 
# This count isn’t part of the data set (it’s not a column in mpg), 
# but is instead a statistical transformation that the geom_bar automatically applies to the data. 
# In particular, it applies the stat_count transformation.

ggplot(mpg, aes(x = class)) +
  geom_bar()

# ggplot2 supports many different statistical transformations. 
# For example, the “identity” transformation will leave the data “as is”. 
# You can specify which statistical transformation a geom uses by passing it as the stat argument.
# For example, consider our data already had the count as a variable,
# We can use stat = "identity" within geom_bar to plot our bar height values to this variable.
# Also, note that we now include y variable in ggplot function:
  
  class_count <- dplyr::count(mpg, class)
  class_count
  
  ggplot(class_count, aes(x = class, y = n)) +
    geom_bar(stat = "identity")
  
# We can also call stat_ functions directly to add additional layers. 
# For example, here we create a scatter plot of highway miles for each displacement 
# value and then use stat_summary to plot the mean highway miles at each displacement value.
  
  ggplot(mpg, aes(displ, hwy)) + 
    geom_point(color = "yellowgreen") + 
    stat_summary(fun.y = "mean", geom = "line", size = 1, linetype = "dashed")

#---------------------
# Position Adjustement
#-------------------
# In addition to a default statistical transformation,
# each geom also has a default position adjustment which specifies a set of “rules”
# as to how different components should be positioned relative to each other. 
# This position is noticeable in a geom_bar if you map a different variable to the color 
# visual characteristic:
    
# bar chart of class, colored by drive (front, rear, 4-wheel)
ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar()
  
# The geom_bar by default uses a position adjustment of "stack", 
# which makes each rectangle’s height proprotional to its value 
# and stacks them on top of each other. 
# We can use the position argument to specify what position adjustment rules to follow:
    
# position = "dodge": values next to each other
ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar(position = "dodge")
  
# position = "fill": percentage chart
ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar(position = "fill")

#-----------------
# Managing Scales
#-----------------
# Whenever you specify an aesthetic mapping, ggplot uses a particular scale to determine 
# the range of values that the data should map to. 

# color the data by engine type
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# same as above, with explicit scales
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_colour_discrete()


# Each scale can be represented by a function with the following name: 
# scale_, followed by the name of the aesthetic property, 
# followed by an _ and the name of the scale. 
# A continuous scale will handle things like numeric data (where there is a continuous set of numbers),
# whereas a discrete scale will handle things like colors (since there is a small list of distinct colors).
# 
# While the default scales will work fine, it is possible to explicitly add different scales 
# to replace the defaults. For example, you can use a scale to change the direction of an axis:
  
  # milage relationship, ordered in reverse
  ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point() +
  scale_x_reverse() +
  scale_y_reverse() 
  
#Similarly, you can use scale_x_log10() and scale_x_sqrt() to transform your scale. 

  ggplot(mpg, aes(x = cty, y = hwy)) +
    geom_point() +
    scale_x_sqrt()
  
#You can also use scales to format your axes:
  ggplot(mpg, aes(x = class, fill = drv)) + 
    geom_bar(position = "fill") +
    scale_y_continuous(breaks = seq(0, 1, by = .2), labels = scales::percent)

# A common parameter to change is which set of colors to use in a plot. 
# While you can use the default coloring, a more common option is 
# to leverage the pre-defined palettes from colorbrewer.org. 
# These color sets have been carefully designed to look good and to be viewable to people 
# with certain forms of color blindness. 
# We can leverage color brewer palletes by specifying the scale_color_brewer() function, 
# passing the pallete as an argument.
  
# default color brewer
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
    geom_point() +
    scale_color_brewer()
  
# specifying color palette
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
    geom_point() +
    scale_color_brewer(palette = "Set3")

# https://observablehq.com/@d3/color-schemes

#You can also specify continuous color values by using a gradient scale, 
#or manually specify the colors you want to use as a named vector.
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_manual(values = c("yellowgreen", "orange","red","blue","gray","purple","violet"))

#analogous for fill aes
ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar(position = "dodge")+
  scale_fill_brewer(palette = "Set1")

#------------------
#Coordinate System
#-----------------
ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar(position = "dodge")+
  scale_fill_brewer(palette = "Set1")+
  coord_flip()

ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar(position = "dodge")+
  scale_fill_brewer(palette = "Set1")+
  coord_polar()

ggplot(mpg, aes(x = class, fill = drv)) + 
  geom_bar(position = "dodge")+
  scale_fill_brewer(palette = "Set1")+
  coord_polar()

ggplot(mpg, aes(x = "", fill = drv)) + 
  geom_bar()+
  scale_fill_brewer(palette = "Set1")+
  coord_polar("y")

#------------------
# Theme
#-----------------

ggplot(mpg, aes(x = "", fill = drv)) + 
  geom_bar()+
  scale_fill_brewer(palette = "Set1")+
  coord_polar("y")+
  theme_minimal()

ggplot(mpg, aes(x = "", fill = drv)) + 
  geom_bar()+
  scale_fill_brewer(palette = "Set1")+
  coord_polar("y")+
  theme_void()

ggplot(mpg, aes(x = "", fill = drv)) + 
  geom_bar()+
  scale_fill_brewer(palette = "Set1")+
  coord_polar("y")+
  theme_dark()

#---------------
#Facets
#---------------
ggplot(mpg, aes(x = displ, y = hwy, color=class)) +
  geom_point() 

ggplot(mpg, aes(x = displ, y = hwy, color=class)) +
  geom_point() +
  facet_grid(~ class)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(year ~ cyl)

#----------------
# Labels and Annotation
#----------------
# You can add titles and axis labels to a chart using the labs() function

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  labs(title = "Fuel Efficiency by Engine Power",
       subtitle = "Fuel economy data from 1999 and 2008 for 38 popular models of cars",
       x = "Engine power (litres displacement)",
       y = "Fuel Efficiency (miles per gallon)",
       color = "Car Type")
 
# It is also possible to add labels into the plot itself (e.g., to label each point or line) 
# by adding a new geom_text or geom_label to the plot; effectively, you’re plotting an extra set 
# of data which happen to be the variable names:

# a data table of each car that has best efficiency of its type
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) +
  geom_label(data = best_in_class, aes(label = model), alpha = 0.5)
