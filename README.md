# Shiny-Apple-Financial-App
A Shiny App using R to showcase some of the features I've picked up in the R `ggplot2` and `Shiny` packages.
Uses Apple Financial data in the data file specified in the below instructions.

To run the app, download the AAPL.sas7bdat data file, and run the following on R or R-Studio...

First, make sure you have the following libraries installed and called:

```library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)
library(haven)
library(ggthemes)```

Next, run the following command to see the app in action:

`runGitHub( "Shiny-Apple-Financial-App", "jbc-qed", ref = "main")`
