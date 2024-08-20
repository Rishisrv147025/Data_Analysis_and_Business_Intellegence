# Load necessary libraries
library(dplyr)
library(ggplot2)
library(caret)
library(tidyr)
library(GGally)

# Load the dataset
data <- read.csv("C:/Users/Admin/Desktop/New folder/ml_pro/FSI-2023-DOWNLOAD.csv")

# Check the structure of the dataset
str(data)

# Summary statistics
summary(data)

# Check for missing values
colSums(is.na(data))

# Histogram of Total Scores
ggplot(data, aes(x = Total)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(title = "Distribution of Total Scores", x = "Total Score", y = "Frequency")

# Scatter plot between Total and one of the features (e.g., Economic Inequality)
ggplot(data, aes(x = `E2..Economic.Inequality`, y = Total)) +
  geom_point() +
  labs(title = "Total vs Economic Inequality", x = "Economic Inequality", y = "Total Score")

# Calculate average Total Score by Country
avg_total_by_country <- data %>%
  group_by(Country) %>%
  summarize(Average_Total = mean(Total, na.rm = TRUE)) %>%
  arrange(desc(Average_Total))

# Bar plot of average Total Scores by Country
ggplot(avg_total_by_country, aes(x = reorder(Country, -Average_Total), y = Average_Total)) +
  geom_bar(stat = "identity", fill = "orange") +
  labs(title = "Average Total Scores by Country", x = "Country", y = "Average Total Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Boxplot of Total Scores by Year
ggplot(data, aes(x = as.factor(Year), y = Total)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Total Scores by Year", x = "Year", y = "Total Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Pairwise plot of selected numeric variables
ggpairs(data %>% select(Total, `E1..Economy`, `E2..Economic.Inequality`, `P1..State.Legitimacy`, `P3..Human.Rights`),
        title = "Pairwise Plot of Selected Variables")

# Convert 'Country' to a factor
data$Country <- as.factor(data$Country)

# Convert 'Rank' to a numeric variable if it's a rank (if applicable)
data$Rank <- as.numeric(as.character(data$Rank))

# Example of feature engineering: create a ratio of Human Rights to Public Services
data <- data %>%
  mutate(HR_to_PS_Ratio = `P3..Human.Rights` / `P2..Public.Services`)

# Set seed for reproducibility
set.seed(123)

# Split the data into training and test sets (70-30 split)
train_index <- createDataPartition(data$Total, p = .7, list = FALSE,times = 1)

train_data <- data[train_index, ]
test_data <- data[-train_index, ]

# Build a linear regression model
model <- lm(Total ~ `S1..Demographic.Pressures` + `S2..Refugees.and.IDPs` + 
              `C3..Group.Grievance` + `E3..Human.Flight.and.Brain.Drain` + 
              `E2..Economic.Inequality` + `E1..Economy` + 
              `P1..State.Legitimacy` + `P2..Public.Services` + 
              `P3..Human.Rights` + `C1..Security.Apparatus` + 
              `C2..Factionalized.Elites` + `X1..External.Intervention`, 
            data = train_data)

# Summary of the model
summary(model)

# Make predictions on the test set
predictions <- predict(model, newdata = test_data)

# Compare predictions with actual values
results <- data.frame(Actual = test_data$Total, Predicted = predictions)

# Calculate RMSE
rmse <- sqrt(mean((results$Actual - results$Predicted)^2))
print(paste("RMSE: ", rmse))

# Plot actual vs predicted values
ggplot(results, aes(x = Actual, y = Predicted)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Actual vs Predicted Total Scores", x = "Actual Total", y = "Predicted Total")
