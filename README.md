# European Working Condition Analysis
## Overview
This project analyzes working conditions across European countries to determine the best countries to live in based on employment factors. The analysis combines multiple employment-related metrics including median income, work hours, job satisfaction, and unemployment rates to create a comprehensive ranking system.

# Data Sources
The analysis uses the [Euro_Stats](Euro_Stats.csv) dataset containing the following key metrics:
* Median Income
* Average Hours Worked
* Job Satisfaction Rates
* Unemployment Rates

# Technologies Used
* R Programming Language
* Key Libraries:
  * data.table
  * ggplot2
  * tidyverse
  * patchwork
  * reshape2
  * dplyr

# Analysis Methodology 
### Data Processing 
1. Selected relevant columns from the Euro_Stats dataset
2. Created visualizations for individual metrics
3. Performed statistical analysis including central tendency and distribution analysis
4. Generated correlation matrices to understand relationships between variables

### Visualization Types 
* Bar charts for individual metric comparisons
* Correlation heatmap
* Scatter plots for relationship analysis
* Combined visualizations using patchwork

### Scoring System 
The project implements a weighted scoring system with the following weights:
* Job Satisfaction: 50%
* Median Income: 40%
* Unemployment Rate: -30%
* Average Hours Worked: -30%

# Key Features
* Comprehensive statistical summaries
* Multiple visualization approaches
* Correlation analysis
* Weighted scoring system
* Country rankings based on composite scores
* Top 5 country analysis

# Results 
The analysis produces:
* Individual metric rankings
* Composite scores for each country
* Correlation analysis between different metrics
* Final country rankings based on scaled composite scores
* Detailed analysis of top 5 performing countries

# Visualizations 
The project includes various visualization types:
* Individual metric bar charts
* Summary statistics visualizations
* Correlation heatmaps
* Scatter plots showing relationships between variables
* Final ranking visualizations

# Data Scaling 
The project implements: 
* Min-Max scaling for standardization
* Composite score calculations
* Adjusted composite scores
* Total scaled composite scores

# Usage 
1. Ensure all required R packages are installed
2. Load the [Euro_Stats](Euro_Stats.csv) dataset
3. Run the analysis scripts
4. View generated visualizations and rankings

# Dependencies
```
R
library(data.table)
library(ggplot2)
library(tidyverse)
library(patchwork)
library(reshape2)
library(dplyr)
```

# Contributing 
Feel free to fork this repository and submit pull requests for any improvements or additional analyses.
