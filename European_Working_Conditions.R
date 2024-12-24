# I am going to analyze 3 data sets: Unemployment, Work_Hours, and 
# Job_Satisfaction. 

library(data.table)
library(ggplot2)
library(tidyverse)
library(patchwork)
library(reshape2)
library(dplyr)

# Take data set Euro_Stats, and pick columns country, median income, 
# average hours worked, job satisfaction, unemployment rate to decide which 
# European country is the best to live in based on working conditions

Merged_Data <- Euro_Stats[, c("country", "median_income", "avg_hrs_worked", 
                              "prct_job_satis_high", "unemp_rate")]

# Visualize each column separately 
# Bar Chart fo Median Income 
ggplot(Merged_Data, aes(x = country, y = median_income, fill = country)) +
  geom_bar(stat = "identity") +
  labs(title = "Median Income Across Countries",
       x = "Country", 
       y = "Median Income") + 
  theme_minimal()

# Bar chart for Average Hours Worked 
ggplot(Merged_Data, aes(x = country, y = avg_hrs_worked, 
                        fill = country)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Hourse Worked Across Countries", 
       x = "Country", 
       y = "Average Hours Worked") +
  theme_minimal()

# Bar Chart for Percentage of High Job Satisfaction
ggplot(Merged_Data, aes(x = country, y = prct_job_satis_high, fill = country)) +
  geom_bar(stat = "identity") +
  labs(title = "Percentage of High Job Satisfaction Across Countries",
       x = "Country",
       y = "Percentage") +
  theme_minimal()

# Bar Chart for Unemployment Rate 
ggplot(Merged_Data, aes(x = country, y = unemp_rate, fill = country)) +
  geom_bar(stat = "identity") +
  labs(title = "Unemployment Rate Across Countries",
       x = "Country",
       y = "Unemployment Rate") +
  theme_minimal()

# Understand the central tendency, spread, and distribution of each variable.
summary(Merged_Data)

# Visualizing the summary data 
summary_values <- data.frame(
  variable = c("median_income", "avg_hrs_worked", "prct_job_satis_high", 
               "unemp_rate"),
  mean_value = c(15972, 38.03, 28.01, 8.338),
  max_value = c(28663, 46.80, 44.40, 23.600),
  min_value = c(4724, 30.30, 14.00, 3.000)
)


summary_values_long <- gather(summary_values, key = "stat_type", 
                              value = "value", -variable)

median_income_summary <- subset(summary_values_long, 
                                variable == "median_income")
avg_hrs_worked_summary <- subset(summary_values_long, 
                                 variable == "avg_hrs_worked")
prct_job_satis_high_summary <- subset(summary_values_long, 
                                      variable == "prct_job_satis_high")
unemp_rate_summary <- subset(summary_values_long,
                             variable == "unemp_rate")

# Create a bar chart for median income
median_income_summary_geom_bar <- 
  ggplot(median_income_summary, aes(x = stat_type, y = value, 
                                    fill = stat_type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7, 
           color = "black") +
  labs(title = "Median Income",
       x = "Statistic Type", y = "Value") +
  scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) + 
  theme_minimal()

# Create a bar chart for average hours worked 
avg_hrs_worked_summary_geom_bar <- 
ggplot(avg_hrs_worked_summary, aes(x = stat_type, y = value, 
                                   fill = stat_type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7, 
           color = "black") +
  labs(title = "Average Hours Worked",
       x = "Statistic Type", y = "Value") +
  scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) + 
  theme_minimal()

# Create a bar chart for job satisfaction 
prct_job_satis_high_summary_geom_bar <- 
  ggplot(prct_job_satis_high_summary, aes(x = stat_type, y = value, 
                                          fill = stat_type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7, 
           color = "black") +
  labs(title = "Percentage of High Job Satisfaction Across",
       x = "Statistic Type", y = "Value") +
  scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) + 
  theme_minimal()

# Create a bar chart for unemployment rate  
unemp_rate_summary_geom_bar <- 
  ggplot(unemp_rate_summary, aes(x = stat_type, y = value, fill = stat_type)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.7, color = "black") +
  labs(title = "Unemployment Rate",
       x = "Statistic Type", y = "Value") +
  scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) + 
  theme_minimal()

# Create a grouped bar chart using patchwork 

(median_income_summary_geom_bar + prct_job_satis_high_summary_geom_bar) / 
  (avg_hrs_worked_summary_geom_bar + unemp_rate_summary_geom_bar)


# Check the correlation matrix to identify relationships between variables.

cor(Merged_Data[, c("median_income", "avg_hrs_worked", "prct_job_satis_high", 
                    "unemp_rate")])

# Create a Scatter Plot to show relationship between median income and job 
# satisfaction

ggplot(Merged_Data, aes(x = median_income, y = prct_job_satis_high)) +
  geom_point() +
  labs(title = "Scatter Plot: Median Income vs. Job Satisfaction")


# Create a Heatmap to show the correlation matrix between all 4 variables

cor_matrix <- cor(Merged_Data[, c("median_income", "avg_hrs_worked", 
                                  "prct_job_satis_high", "unemp_rate")])
melt_corr <- melt(cor_matrix)

ggplot(melt_corr, aes(Var1, Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, 
                       limit = c(-1,1), space = "Lab", name="Correlation") +
  theme_minimal() +
  labs(title = "Correlation Heatmap")


# Weighted Scoring:
# If you have specific priorities for each variable, apply weights and calculate 
# a composite score for each country.
Merged_Data$composite_score <- with(Merged_Data, 0.5 * prct_job_satis_high + 
                                    0.4 * median_income - 
                                    0.3 * unemp_rate - 
                                    0.3 * avg_hrs_worked)

# Ranking 
# Rank countries based on composite scores or specific variables.
Data_Ranked <- Merged_Data[order(Merged_Data$composite_score, 
                                 decreasing = TRUE), ]

# Relationship between median income and composite scores.
p1 <- ggplot(Data_Ranked, aes(x = median_income, y = composite_score)) +
  geom_point(color = "blue") +
  labs(title = "Scatter Plot: Median Income vs. Composite Scores",
       x = "Median Income", y = "Composite Score") +
  theme_minimal()

# Relationship between average hours worked and composite scores.
p2 <- ggplot(Data_Ranked, aes(x = avg_hrs_worked, y = composite_score)) +
  geom_point(color = "green") +
  labs(title = "Scatter Plot: Average Hours Worked vs. Composite Scores",
       x = "Average Hours Worked", y = "Composite Score") +
  theme_minimal()
# Relationship between job satisfaction and composite scores.
p3 <- ggplot(Data_Ranked, aes(x = prct_job_satis_high, y = composite_score)) +
  geom_point(color = "orange") +
  labs(title = "Scatter Plot: Job Satisfaction vs. Composite Scores",
       x = "Job Satisfaction", y = "Composite Score") +
  theme_minimal()

# Arrange plots using patchwork 
p1 + p2 + p3

# Visualizing final, ranked data, -composite_score

ggplot(Data_Ranked, aes(x = reorder(country, -composite_score), 
                        y = composite_score)) + 
  geom_bar(stat = "identity", fill = "skyblue", color = "black") + 
  labs(title = "Composite Scores - Ranked",
       x = "Country", y = "Composite Score") + 
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Subset the top 5 countries
top5_countries <- head(Data_Ranked, 5)

# Create a bar chart for the top 5 countries
ggplot(top5_countries, aes(x = reorder(country, -composite_score), 
                           y = composite_score)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Top 5 Countries - Composite Scores",
       x = "Country", y = "Composite Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Final Ranking ----

# Merge datasets
merged_data <- merge(merge(comp_scores1, comp_scores2, 
                           by.x = "Country", by.y = "country"), 
                     comp_scores3, by.x = "Country", by.y = "country")

# Subtract "composite_scores" from "Composite Score"
merged_data$Adjusted_Composite_Score <- merged_data$`Composite Score` - 
  merged_data$composite_scores

# Calculate the total adjusted composite score as the sum of the adjusted 
# scores and "composite score" from comp_scores3
merged_data$Total_Adjusted_Composite_Score <- 
  rowSums(merged_data[, c("Adjusted_Composite_Score", "composite score")])


# Min-Max scaling function
min_max_scale <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}

# Apply Min-Max scaling to each relevant column
scaled_data <- merged_data %>%
  mutate(
    Scaled_Composite_Score = min_max_scale(`Composite Score`),
    Scaled_composite_scores = min_max_scale(composite_scores),
    Scaled_composite_score = min_max_scale(`composite score`)
  )

# Calculate the total scaled composite score as the sum of the scaled values
scaled_data$Total_Scaled_Composite_Score <- 
  rowSums(scaled_data[, c("Scaled_Composite_Score", 
                          "Scaled_composite_scores", "Scaled_composite_score")])

# Arrange the data in descending order of the total scaled composite score
sorted_data <- scaled_data[order(-scaled_data$Total_Scaled_Composite_Score), ]

result <- top_n(select(sorted_data, Country, Adjusted_Composite_Score, 
                       Total_Adjusted_Composite_Score, 
                       Total_Scaled_Composite_Score), 5)

# Select the top 5 countries
top_5_countries <- head(sorted_data, 5)

# Print the result
print(top_5_countries)




