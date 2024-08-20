# Load the libraries
install.packages("caret")

library(caret)
library(Amelia)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(corrplot)
library(randomForest)

# Load the dataset
data <- read.csv("C:/Users/Admin/Desktop/New folder/googleplaystore.csv")

#check for the data type.
str(data)

#Checking for the missing values.
missing_values <- sapply(data, function(x) sum(is.na(x)))
print(missing_values)

# Convert Reviews to numeric
data$Reviews <- as.numeric(data$Reviews)

# Clean and Convert Installs to numeric by removing commas and plus signs
data$Installs <- as.numeric(gsub("[+,]", "", data$Installs))

# Convert Price by removing the dollar sign and converting to numeric
data$Price <- as.numeric(gsub("[$]", "", data$Price))

# Convert Rating to numeric (already done)
data$Rating <- as.numeric(data$Rating)

#Checking wheter the datas has been properly changed or not.
str(data)

#Now, lets fill the missing values.
data$Rating <- ifelse(is.na(data$Rating), mean(data$Rating, na.rm = TRUE), data$Rating)

#Let's check for the missing values again with missing_value_1
missing_values_1 <- sapply(data, function(x) sum(is.na(x)))
print(missing_values_1)

data$Reviews <- ifelse(is.na(data$Reviews),mean(data$Reviews,na.rm=TRUE),data$Reviews)
data$Installs <- ifelse(is.na(data$Installs),mean(data$Installs,na.rm=TRUE),data$Installs)
data$Price <-ifelse(is.na(data$Price),mean(data$Price,na.rm=TRUE),data$Price)

sum(is.na(data$Rating))

missing_value_2 <- sapply(data, function(x) sum(is.na(x)))
print(missing_value_2)

# Convert Last Updated to Date format
data$Last.Updated <- as.Date(data$Last.Updated, format="%B %d, %Y")

missmap(data, main = "Missing values vs Observed")

## 1. Distribution of Ratings
ggplot(data, aes(x = Rating)) +
  geom_histogram(binwidth = 0.5, fill = "blue", color = "black") +
  labs(title = "Distribution of Ratings", x = "Rating", y = "Frequency") +
  theme_minimal()

# Average rating by category
avg_rating_by_category <- data %>%
  group_by(Category) %>%
  summarise(Average_Rating = mean(Rating, na.rm = TRUE)) %>%
  arrange(desc(Average_Rating))

print(avg_rating_by_category)

# Total installs by category
total_installs_by_category <- data %>%
  group_by(Category) %>%
  summarise(Total_Installs = sum(Installs, na.rm = TRUE)) %>%
  arrange(desc(Total_Installs))

print(total_installs_by_category)

# Scatter plot of Rating vs Reviews
ggplot(data, aes(x = Reviews, y = Rating)) +
  geom_point(alpha = 0.5) +
  labs(title = "Rating vs Reviews", x = "Number of Reviews", y = "Rating")

ggplot(avg_rating_by_category, aes(x = reorder(Category, Average_Rating), y = Average_Rating)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Average Rating by Category", x = "Category", y = "Average Rating")

ggplot(total_installs_by_category, aes(x = reorder(Category, Total_Installs), y = Total_Installs)) +
  geom_bar(stat = "identity", fill = "darkgreen") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Total Installs by Category", x = "Category", y = "Total Installs")


# Filter numeric columns for correlation analysis
numeric_data <- data %>% select_if(is.numeric)
print(numeric_data)

# Calculate the correlation matrix
correlation_matrix <- cor(numeric_data, use = "complete.obs")
print(correlation_matrix)

# Create a heatmap using the corrplot package
corrplot(correlation_matrix, method = "color", type = "lower",
         tl.col = "black", tl.srt = 45, # Text label color and rotation
         addCoef.col = "black", # Add correlation coefficients
         col = colorRampPalette(c("blue", "white", "red"))(200))

# Create a feature for age of the app
data$App_Age <- as.numeric(difftime(Sys.Date(), data$Last.Updated, units = "days"))
sum(is.na(data$App_Age))
data$App_Age <-ifelse(is.na(data$App_Age),mean(data$App_Age,na.rm=TRUE),data$App_Age)
# Convert 'Content Rating' to factor
data$Content.Rating <- as.factor(data$Content.Rating)

# Create dummy variables for categorical variables (e.g., Category, Type)
data <- data %>%
  mutate(Type = as.factor(Type), 
         Category = as.factor(Category)) %>%
  select(-App, -Last.Updated) 

# Boxplot to identify outliers in Ratings
ggplot(data, aes(y = Rating)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Boxplot of Ratings", y = "Rating")

# Boxplot to identify outliers in Reviews
ggplot(data, aes(y = Reviews)) +
  geom_boxplot(fill = "purple") +
  labs(title = "Boxplot of Reviews", y = "Number of Reviews")

# Identify outliers using IQR method for Ratings
Q1 <- quantile(data$Rating, 0.25, na.rm = TRUE)
Q3 <- quantile(data$Rating, 0.75, na.rm = TRUE)
IQR <- Q3 - Q1

outliers_ratings <- data %>%
  filter(Rating < (Q1 - 1.5 * IQR) | Rating > (Q3 + 1.5 * IQR))

# Identify outliers using IQR method for Reviews
Q1_reviews <- quantile(data$Reviews, 0.25, na.rm = TRUE)
Q3_reviews <- quantile(data$Reviews, 0.75, na.rm = TRUE)
IQR_reviews <- Q3_reviews - Q1_reviews

outliers_reviews <- data %>%
  filter(Reviews < (Q1_reviews - 1.5 * IQR_reviews) | Reviews > (Q3_reviews + 1.5 * IQR_reviews))

# Display outliers
print("Outliers in Ratings:")
print(outliers_ratings)

print("Outliers in Reviews:")
print(outliers_reviews)



# Set seed for reproducibility
set.seed(123)

# Split the data
trainIndex <- createDataPartition(data$Rating, p = .8, 
                                  list = FALSE, 
                                  times = 1)
dataTrain <- data[trainIndex, ]
dataTest <- data[-trainIndex, ]

# Check for missing values in the dataset
colSums(is.na(dataTrain))

# Train a Random Forest model
rf_model <- randomForest(Rating ~ ., data = dataTrain, importance = TRUE, ntree = 100)

# Print model summary
print(rf_model)

# Variable importance
importance(rf_model)
varImpPlot(rf_model)

# Predict on test data
predictions <- predict(rf_model, newdata = dataTest)

# Calculate RMSE
rmse <- sqrt(mean((predictions - dataTest$Rating)^2))
print(paste("RMSE:", rmse))

# Compare actual vs predicted
comparison <- data.frame(Actual = dataTest$Rating, Predicted = predictions)
ggplot(comparison, aes(x = Actual, y = Predicted)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1, color = "red") +
  labs(title = "Actual vs Predicted Ratings", x = "Actual Ratings", y = "Predicted Ratings")
