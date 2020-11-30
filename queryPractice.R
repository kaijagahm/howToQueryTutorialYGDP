# This is a script that you can use to practice writing queries to access the YGDP database.
# Created by Kaija Gahm on 9 November 2020
# You should open this script from *inside* the "howToQueryTutorial.Rproj" R project file--i.e. first click to open the .Rproj file in RStudio, and then open this script from the "Files" pane inside RStudio. 
# Detailed instructions and explanations for working with the database, as well as links to additional R resources, are available in the 'howToQueryYGDPDatabase.pdf' document in this folder.


# Install packages (libraries) --------------------------------------------
# Note: you only need to install each package once, NOT every time you run the script. 
# Lego analogy: this is where you buy the lego set.
# To install the packages below, 'un-comment' each line (remove the # at the beginning). Run the line of code. Then replace the # to 'comment out' the line so it doesn't run every time you run the script.
# install.packages("RSQLite")
# install.packages("tidyverse")
# install.packages("here")


# Load packages (libraries) -----------------------------------------------
# You have to do this every time you run the script. Don't comment out these lines.
# Lego analogy: this is where you take the lego set out of the box.
library(RSQLite) # R package that interfaces with SQLite 
library(tidyverse) # A suite of packages to make data manipulation easier
library(here) # For specifying file paths

# Note: the lego analogy doesn't carry over to putting the lego set away when you're done with it. So I guess... pretend you're like 3 and don't know how to clean up your toys? Then it makes sense, I think.

# Connect to the database -------------------------------------------------
con <- dbConnect(RSQLite::SQLite(), here("ygdpDB.db")) # here, we create a connection object `con`, basically like a portal to the database file `ygdpDB.db` from this R script.

# Practice example queries ------------------------------------------------
ratings <- dbReadTable(con, "ratings")

# Examine the table
head(ratings, 2) # see the first n rows (6 by default, but we specified 2)
tail(ratings) # see the last n rows (6 by default)
str(ratings) # see the structure of the table: number of rows/cols, data types, first few entries of each column
dim(ratings) # see the dimensions (rows and columns)
nrow(ratings) # number of rows
ncol(ratings) # number of columns


# 1. Get all data from survey 11
# a. Load the ratings table
r <- dbReadTable(con, "ratings")
# OR
r <- tbl(con, "ratings") %>% 
  collect()

# c. Get only the data from survey 11
# Which surveys are included?
unique(ratings$surveyID) # $ means "column"

# Filter down to just get ratings from Survey 11
survey11 <- ratings %>% # "and then..."
  filter(surveyID == "S11") %>% # 'filter()' is for ROWS
  select(responseID, sentenceID, rating) # 'select()' is for COLUMNS

# Filter for everything BUT survey 11
NOTsurvey11 <- ratings %>%
  filter(surveyID != "S11")

# Double check that we just got survey 11
unique(survey11$surveyID)

# Look at the SENTENCES table
sentences <- dbReadTable(con, "sentences")
head(sentences)

## which constructions are represented in the database?
unique(sentences$constructionID)
table(sentences$constructionID)


# Example of a left join ( left_join() ) ----------------------------------
## Below is my very rough definition of a left join. Please see ?left_join for more information, or read a lot more at https://dplyr.tidyverse.org/reference/join.html.
# x and y
# Keep all the rows in x
# Keep columns from y in addition to columns from x for rows that match based on the criteria that you specify

head(ratings)

# two ways to write the same thing:
## we have to remove the updateID column to avoid ending up with updateID.x and updateID.y after the join (since duplicate column names aren't allowed)
expandedSurvey11 <- left_join(x = ratings %>%
                                select(-updateID), 
                              y = sentences %>%
                                select(-updateID), 
                              by = "sentenceID")

expandedSurvey11 <- ratings %>%
  select(-updateID) %>%
  left_join(sentences %>% # add the sentence information
              select(-updateID), 
            by = "sentenceID")

# This is too much data! I just study Fixin' To, so I just want to see those sentences. (Luke cheers)
luke <- expandedSurvey11 %>%
  filter(constructionID == "FT")
dim(luke)

constructions <- dbReadTable(con, "constructions")
head(constructions)

# Plot our FT sentences
head(luke)
luke %>%
  ggplot(aes(x = as.numeric(rating)))+
  geom_histogram(binwidth = 1, col = "white")+
  xlab("rating")+
  ylab("frequency")+
  facet_wrap(~sentenceText)


# Cross-tabulation of 1002 and 1007 ---------------------------------------
# Two different ways to write the same thing
## 1. 
### First, define the vector
targetSentenceNumbers <- c("1002", "1007")

### Second, filter based on that pre-defined vector
jim <- ratings %>%
  filter(sentenceID %in% targetSentenceNumbers)

## 2.
### Do it all in one step: filter based on a vector that I define on the fly
jim <- ratings %>%
  filter(sentenceID %in% c("1002", "1007")) %>% # grab 
  select(responseID, sentenceID, rating) %>% # grab only the columns we want
  mutate(rating = as.numeric(rating)) %>% # convert ratings to numeric
  pivot_wider(id_cols = responseID,  # change data from "long" to "wide" format
              names_from = sentenceID, # the 'sentenceID' column values become the names of the newly-created columns
              names_prefix = "TS_", # prefix the newly-created column names with "TS_" because column names starting with numbers aren't allowed in R
              values_from = rating) %>%
  filter(!is.na(TS_1007), !is.na(TS_1002))

## Jittered scatterplot of ratings for the two sentences
jim %>%
  ggplot(aes(x = jitter(as.numeric(TS_1002)), 
             y = jitter(as.numeric(TS_1007))))+
  geom_point(alpha = 0.5)

## Two-way table of ratings for the two sentences
with(jim, table(TS_1002, TS_1007))


# See the tables in the database ------------------------------------------
## List of all database tables
dbListTables(con)

## List of the column names in one table (SENTENCES)
dbListFields(con, "sentences")
### Note: the above gets the same results as this:
dbReadTable(con, "sentences") %>%
  names()
### but with the important difference that if you use dbReadTable, you're reading the entire table into R's memory--it might be huge!--only to then just ask for the names of the columns. dbListFields is MUCH more efficient: it just grabs the column names without first reading in the entire table.


# Graph average judgments of 1002 by ANAE dialect region ------------------
## pull in the dialect regions table
dr <- dbReadTable(con, "dialect_regions")

## pull in the demo_geo table to get demographic information (i.e. raised city)
demo_geo <- dbReadTable(con, "demo_geo")

## Get ratings just for sentence 1002
sentence1002 <- ratings %>%
  filter(sentenceID == "1002")

## Now we need to do a bunch of joins to connect these tables together
data <- sentence1002 %>% # one row represents one person's rating of one sentence
  select(responseID, rating) %>% # choose only the relevant columns
  # Join to DEMO_GEO
  left_join(demo_geo %>% # one row represents one person
              select(responseID, raisedCityID) %>%
              rename("cityID" = "raisedCityID"), # rename to "cityID" to facilitate the join with DIALECT_REGIONS
            by = "responseID") %>%
  # Join to DIALECT_REGIONS
  left_join(dr %>% # one row represents one city
              select(cityID, regionANAE),
            by = "cityID") %>%
  mutate(rating = as.numeric(rating)) # convert ratings to numeric

## Calculate summary statistics for each region: median/mean rating
summary <- data %>%
  group_by(regionANAE) %>% # group data by region, such that the statistics we calculate are region-specific
  summarize(med = median(rating, na.rm = T),
            mn = mean(rating, na.rm = T))

## Make a simple dot plot
summary %>%
  ggplot(aes(x = regionANAE, y = med))+
  geom_point()


# Disconnect from the database --------------------------------------------
dbDisconnect(con) # don't forget to disconnect `con` when you're finished. (close the portal)




