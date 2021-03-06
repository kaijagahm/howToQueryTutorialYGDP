
# README: How to query the YGDP database

### Kaija Gahm

### 1/28/2021

**Last updated: 2021-01-28**

Tutorial and examples for YGDP members on how to query the database.

Complete and detailed instructions for querying the database are
contained in “howToQueryYGDPDatabase.pdf”.

### Files in this repo

This is a “tree” representation of the files in this folder. The `.` at
the top represents the top level directory (folder), called
“howToQueryTutorialYGDP”.

``` r
fs::dir_tree()
```

    ## .
    ## ├── README.Rmd
    ## ├── README.html
    ## ├── README.md
    ## ├── dbTable.R
    ## ├── howToQueryTutorial.Rproj
    ## ├── howToQueryYGDPDatabase.Rmd
    ## ├── howToQueryYGDPDatabase.pdf
    ## ├── queryPractice.R
    ## ├── ygdpDB.db
    ## └── ygdpdbed_all.pdf

-   **dbTable.R**: wrapper function for the `dbReadTable()` function in
    `RSQLite` .

-   **howToQueryTutorial.Rproj**: the R project file, aka portal, for
    this folder. Always open this first, and use the RStudio files pane
    to open R scripts! For more details, see the overall README for the
    kaijaFiles folder.

-   **howToQueryYGDPDatabase.Rmd**: used to generate
    howToQueryYGDPDatabase.pdf.

-   **howToQueryYGDPDatabase.pdf**: detailed explanatory guide for how
    to use the database and how to write queries, including a bunch of
    sample database queries that you can copy and modify for your own
    use.

-   **queryPractice.R**: an R script you can use to practice querying
    the database. It draws from the locally-saved copy of the database,
    ygdpDB.db.

-   **ygdpDB.db**: locally-saved copy of the YGDP database. This may not
    be the most up-to-date version. If you want to query from the most
    recent database version, make sure you query the “.db” file in
    “ygdpDB/database/currentDB”.

### How to use this repo

1.  Install R. To download R: Go to [this
    page](http://lib.stat.cmu.edu/R/CRAN/) and click on the link for the
    Linux, Mac, or Windows version (depending on your computer’s OS).

2.  Install RStudio. To download RStudio: Go to [this
    page](https://rstudio.com/products/rstudio/download/) and click the
    “download” button for the free version of RStudio.

3.  Download the contents of this repository using the green download
    button.

4.  Navigate to the folder you just downloaded and double-click to open
    “howToQueryTutorial.Rproj”. This will open a new session of RStudio.

5.  From the “Files” pane in RStudio, open the R script called
    “queryPractice.R”. This script contains code and notes from Kaija’s
    workshop on how to query the database, held on 11/30.

*Note*: The recorded workshop uses the `dbReadTable()` function instead
of the `dbTable()` wrapper function shown in this repo. Since the
workshop, I have updated queryPractice.R to change `dbReadTable()` to
`dbTable()`. The instructional pdf uses `dbTable()`. `dbTable()` does
the following that `dbReadTable()` does not:

\- Parse dates as dates rather than plain text

\- Parse blank cells and “NA” as actual <NA>’s (R’s missing values).
This is very important because it allows functions to recognize these
cells as missing. You can use commands like `is.na()`, `na.omit()`, etc.

#### Acknowledgements

Created by Kaija Gahm in 2020. Thanks to Ian Neidel for proofreading and
advice.
