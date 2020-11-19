# This is a script that you can use to practice writing queries to access the YGDP database.
# Created by Kaija Gahm on 9 November 2020
# You should open this script from *inside* the "howToQueryTutorial.Rproj" R project file--i.e. first click to open the .Rproj file in RStudio, and then open this script from the "Files" pane inside RStudio. 
# Detailed instructions and explanations for working with the database, as well as links to additional R resources, are available in the 'howToQueryYGDPDatabase.pdf' document in this folder.

# Load packages (libraries) -----------------------------------------------
library(RSQLite) # R package that interfaces with SQLite 
library(tidyverse) # A suite of packages to make data manipulation easier
library(here) # For specifying file paths



# Connect to the database -------------------------------------------------
con <- dbConnect(RSQLite::SQLite(), here("ygdpDB.db")) # here, we create a connection object `con`, basically like a portal to the database file `ygdpDB.db` from this R script.



# Practice example queries ------------------------------------------------
## Do any practicing here



# Disconnect from the database --------------------------------------------
dbDisconnect(con) # don't forget to disconnect `con` when you're finished.




