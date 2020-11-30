# howToQueryTutorialYGDP
Tutorial and examples for YGDP members on how to query the database.

Complete and detailed instructions for querying the database are contained in "howToQueryYGDPDatabase.pdf".

### How to use this repo
1. Install R. To download R: Go to [this page](http://lib.stat.cmu.edu/R/CRAN/) and click on the link for the Linux, Mac, or Windows version (depending on your computer's OS).

2. Install RStudio. To download RStudio: Go to [this page](https://rstudio.com/products/rstudio/download/) and click the "download" button for the free version of RStudio.

3. Download the contents of this repository using the green download button.

4. Navigate to the folder you just downloaded and double-click to open "howToQueryTutorial.Rproj". This will open a new session of RStudio. 

5. From the "Files" pane in RStudio, open the R script called "queryPractice.R". This script contains code and notes from Kaija's workshop on how to query the database, held on 11/30. 

*Note*: The queryPractice.R script and the recorded workshop both use the `dbReadTable()` function instead of the `dbTable()` wrapper function shown in this repo. The instructional pdf is more up to date and uses `dbTable()`. `dbTable()` does the following that `dbReadTable()` does not:
- Parse dates as dates rather than plain text
- Parse blank cells and "NA" as actual <NA>'s (R's missing values). This is very important because it allows functions to recognize these cells as missing. You can use commands like `is.na()`, `na.omit()`, etc.


#### Acknowledgements
Created by Kaija Gahm. Thanks to Ian Niedel for proofreading and advice.
