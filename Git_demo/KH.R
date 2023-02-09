#####################################
## Some code to learn GitHub on
# 
# Create a new branch: all your work should be on your own branch!!
# Open a new R script and copy this script over. Give your new script a new
# name and then run through this simple exercise.
# 
# Since you are working in your own script, you can make as many changes as
# you want to. At the end, you will commit these changes and push them to the 
# remote repository (GitHub). You can go to your GitHub to check the changes 
# online. From GitHub, you can also try to merge your branch by opening a 
# pull request. 
# 
# CASES GitHub
# Karen Hotopp
# 9Feb2023
# 
# Written on R Server 3.6.1
#####################################

## Packages
library(dplyr)
library(magrittr)
library(ggplot2)

## Whoo hoo!!
## Look into R's pre-loaded datasets
data()

## We'll use the "Loblolly" data set about the growth of Loblolly pines
data("Loblolly")

##
names(Loblolly)

table(Loblolly$age)
table(Loblolly$height)
table(Loblolly$Seed)


## Add area variable (for fun)
lob <- Loblolly %>% 
  mutate(area = case_when(Seed %in% (300:310) ~ "group 1",
                          Seed %in% (311:320) ~ "group 2",
                          Seed %in% (321:331) ~ "group 3"))

table(lob$area)


## Create height groupings
lob  %<>% 
  mutate(height_group = case_when(height < 10.00 ~ "group 1",
                                  height < 20.00 ~ "group 2",
                                  height < 30.00 ~ "group 3",
                                  height < 40.00 ~ "group 4",
                                  height < 50.00 ~ "group 5",
                                  height < 60.00 ~ "group 6",
                                  height >= 60.00 ~ "group 7"))

table(lob$height_group)


#####
## Are those useful groupings? Are those useful names??
## Task: Change the area and height_group variable level names 
## to something more useful
####


## Make a simple graph
ggplot(data=Loblolly, aes(x=age, y=height, group=Seed, color=Seed)) +
  geom_line() +
  geom_point()


#####
## It's a bit hard to see what's going... 
## Task: Change the group aesthetic in your plot to be area instead of seed
#### 


#####
## Now that you have made your changes on your branch, do a commit!
## Click on "Git" in the window that has your Environment (typically the 
## upper right corner, unless you have moved your windows around!).
## 
## You should see all the files that you have changed sitting in the window;
## check the boxes (you will see a change to the statust) and hit the "Commit" 
## button just above them.
## 
## In the new window, make sure that each file that has been changed is checked.
## You can review the changes that you are committing: anything added wil be 
## highlighted in green and anything removed will be in red. Add a consice 
## message to the Commit message box--it should convey what changes have been
## made, but be brief. No novellas!! Click the Commit button.
## 
## Once you have committed your changes, they need to be pushed to the remote
## repository (GitHub). Click push. The pop-up box will tell you what changes 
## have been pushed.
## 
## It's good practice to commit and push changes relatively frequently.
