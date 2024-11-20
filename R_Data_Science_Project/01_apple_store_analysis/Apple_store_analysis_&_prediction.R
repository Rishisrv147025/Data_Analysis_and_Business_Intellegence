# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(caret)
library(randomForest)
library(corrplot)
library(Amelia)

# Load data
data <- read.csv("C:/Users/Admin/Downloads/appleStore_1.csv")

#Cleaning the dataset.
# Structure and missing values analysis
str(data)
sum(is.na(data))
colSums(is.na(data))
# Visualize missing data
missmap(data, main = "Missing values vs Observed")

# Data cleaning - Remove '+' from the 'cont_rating' and convert it to numeric
data$cont_rating <- as.numeric(gsub("\\+", "", data$cont_rating))


#EDA
#Univariate analysis: Distribution of app prices
ggplot(data, aes(x = price)) + 
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of App Prices", x = "Price", y = "Count")

ggplot(data, aes(x = price)) + 
  geom_boxplot(fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of App Prices", x = "Price", y = "Count")

# Univariate analysis: Distribution of user ratings
ggplot(data, aes(x = user_rating)) + 
  geom_histogram(bindwidth=1,fill = "green", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of User Ratings", x = "User Rating", y = "Count")

ggplot(data, aes(x = user_rating)) + 
  geom_boxplot(fill = "green", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of User Ratings", x = "User Rating", y = "Count")

# Univariate analysis: Count of Apps by Currency
ggplot(data, aes(x = currency)) +
  geom_bar(fill = "purple") +
  labs(title = "Count of Apps by Currency", x = "Currency", y = "Count")

# Univariate analysis: Count of Apps by Content Rating
ggplot(data, aes(x = cont_rating)) +
  geom_bar(fill = "cyan") +
  labs(title = "Count of Apps by Content Rating", x = "Content Rating", y = "Count")

# Univariate analysis: Count of Apps by Prime Genre
ggplot(data, aes(x = prime_genre)) +
  geom_bar(fill = "lightgreen") +
  coord_flip() +
  labs(title = "Count of Apps by Prime Genre", x = "Prime Genre", y = "Count")

# Univariate analysis: Boxplot for detecting outliers in User Rating
ggplot(data, aes(y = user_rating)) +
  geom_boxplot(fill = "lightcoral") +
  labs(title = "Boxplot of User Rating", y = "User Rating")

# Bivariate analysis for the dataset:
#Bi-variate analysis for rating_count_tot and rating_count_ver
ggplot(data, aes(x = rating_count_tot, y = rating_count_ver)) +
  geom_line(color='yellow')+
  labs(title = "Rating Count", x = "Total", y = "Version")

#Scatter plot analysis for Rating_count_tot and rating_count_ver
ggplot(data, aes(x = rating_count_tot, y = rating_count_ver)) +
  geom_point(color='black')+
  labs(title = "Rating Count", x = "Total", y = "Version")

#Area plot ananlysis
ggplot(data, aes(x = user_rating, y = user_rating_ver)) +
  geom_area(color='red')+
  labs(title = "User Rating", x = "Total", y = "Version")

#Scatter plot analysis for user rating and user rating ver.
ggplot(data, aes(x = user_rating, y = user_rating_ver)) +
  geom_point(color='purple')+
  labs(title = "User Rating", x = "Total", y = "Version")

# Barplot analysis for prime_genre and sup_device_num
ggplot(data, aes(x = prime_genre, y = sup_devices.num)) +
  geom_col(color='green', fill='lightgreen') +
  labs(title = "Genre vs Devices", x = "Genre", y = "Number of Supported Devices") +
  theme_minimal() +
  coord_flip()

# Grouping and aggregation
#Grouping and Aggregation for prime_genre and rating_count_tot
total_ratings_by_genre <- data %>%
  group_by(prime_genre) %>%
  summarise(total_ratings = sum(rating_count_tot))
print(total_ratings_by_genre)

# Grouping and aggregation: Top 10 most expensive apps
top_10_expensive_apps <- data %>%
  arrange(desc(price)) %>%
  head(10)
print(top_10_expensive_apps)

# Grouping and aggregation: Average rating and price by genre
genre_summary <- data %>%
  group_by(prime_genre) %>%
  summarise(avg_rating = mean(user_rating, na.rm = TRUE),
            avg_price = mean(price, na.rm = TRUE),
            app_count = n()) %>%
  arrange(desc(avg_rating))

# Aggregating sum of rating_count_tot by prime_genre
genre_rating_sum <- data %>%
  group_by(prime_genre) %>%
  summarise(total_ratings = sum(rating_count_tot, na.rm = TRUE)) %>%
  arrange(desc(total_ratings))

# Bar plot for sum of rating_count_tot by prime_genre
ggplot(genre_rating_sum, aes(x = reorder(prime_genre, total_ratings), y = total_ratings)) +
  geom_bar(stat = "identity", fill = "blue", color = "black") +
  labs(title = "Total Ratings by Genre", x = "Prime Genre", y = "Total Ratings") +
  coord_flip() +  # Flip for readability
  theme_minimal()

# Aggregating average user_rating by prime_genre
genre_rating_avg <- data %>%
  group_by(prime_genre) %>%
  summarise(avg_user_rating = mean(user_rating, na.rm = TRUE)) %>%
  arrange(desc(avg_user_rating))

# Bar plot for average user rating by prime_genre
ggplot(genre_rating_avg, aes(x = reorder(prime_genre, avg_user_rating), y = avg_user_rating)) +
  geom_bar(stat = "identity", fill = "green", color = "black") +
  labs(title = "Average User Rating by Genre", x = "Prime Genre", y = "Average User Rating") +
  coord_flip() +  # Flip for readability
  theme_minimal()

# Box plot for user_rating by prime_genre
ggplot(data, aes(x = prime_genre, y = user_rating)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "User Rating Distribution by Genre", x = "Prime Genre", y = "User Rating")
  theme_minimal()
  
# Correlation matrix of numeric variables
numeric_vars <- data %>% select_if(is.numeric)
corr_matrix <- cor(numeric_vars)
corrplot(corr_matrix, method = "color")

# Create a new feature - log of price to handle skewness
data$log_price <- log1p(data$price)


# Identifying outliers using the IQR method for User Rating
Q1 <- quantile(data$user_rating, 0.25)
Q3 <- quantile(data$user_rating, 0.75)
IQR <- Q3 - Q1
user_rating_outliers <- data[data$user_rating < (Q1 - 1.5 * IQR) | data$user_rating > (Q3 + 1.5 * IQR), ]

# Display outliers
print(nrow(user_rating_outliers))
head(user_rating_outliers)

# Univariate analysis: Boxplot for detecting outliers in Price
ggplot(data, aes(y = price)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Boxplot of Price", y = "Price")

# Identifying outliers using the IQR method for Price
Q1_price <- quantile(data$price, 0.25)
Q3_price <- quantile(data$price, 0.75)
IQR_price <- Q3_price - Q1_price
price_outliers <- data[data$price < (Q1_price - 1.5 * IQR_price) | data$price > (Q3_price + 1.5 * IQR_price), ]

# Display outliers
print(nrow(price_outliers))
head(price_outliers)

# Machine Learning: Preprocessing for RandomForest Model
# Remove irrelevant columns for prediction (like 'Unnamed: 0', 'id', 'track_name', 'ver', etc.)
data_ml <- data %>%
  select(-c(id, track_name, ver))

# Convert categorical variables to factors
data_ml$cont_rating <- as.factor(data_ml$cont_rating)
data_ml$currency <- as.factor(data_ml$currency)
data_ml$prime_genre <- as.factor(data_ml$prime_genre)

# Split data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(data_ml$user_rating, p = 0.7, list = FALSE)
train_data <- data_ml[trainIndex, ]
test_data <- data_ml[-trainIndex, ]

# Build a random forest model to predict user_rating
rf_model <- randomForest(user_rating ~ ., data = train_data, ntree = 100)

# Evaluate the model
rf_predictions <- predict(rf_model, newdata = test_data)
rf_rmse <- sqrt(mean((rf_predictions - test_data$user_rating)^2))
print(paste("Random Forest RMSE: ", rf_rmse))

# Model Evaluation: Confusion Matrix for classification (if applicable)
# Converting user_rating to a categorical variable for classification
train_data$user_rating <- as.factor(train_data$user_rating)
test_data$user_rating <- as.factor(test_data$user_rating)

rf_model_class <- randomForest(user_rating ~ ., data = train_data, ntree = 100)
rf_predictions_class <- predict(rf_model_class, newdata = test_data)
confusionMatrix(rf_predictions_class, test_data$user_rating)

# 1. Confusion Matrix for Random Forest Classification Model
confusion_mat <- confusionMatrix(rf_predictions_class, test_data$user_rating)
print(confusion_mat)


#Actual vs Predicted Plot (Classification)
ggplot(data.frame(Actual = test_data$user_rating, Predicted = rf_predictions_class), aes(x = Actual, y = Predicted)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Actual vs Predicted User Ratings (Classification)", x = "Actual Rating", y = "Predicted Rating") +
  theme_minimal()

# Residual Plot (for Classification Model)
# Residuals are the differences between actual and predicted classifications
residuals_class <- as.numeric(test_data$user_rating) - as.numeric(rf_predictions_class)
ggplot(data.frame(residuals_class), aes(x = residuals_class)) +
  geom_histogram(binwidth = 1, fill = "red", color = "black", alpha = 0.7) +
  labs(title = "Residuals of the Random Forest Classification Model", x = "Residuals", y = "Frequency") +
  theme_minimal()

#Feature Importance Plot (for Random Forest Classification Model)
importance_df <- data.frame(Feature = rownames(importance(rf_model_class)), 
                            Importance = importance(rf_model_class)[, 1])

ggplot(importance_df, aes(x = reorder(Feature, Importance), y = Importance)) +
  geom_bar(stat = "identity", fill = "purple") +
  coord_flip() +
  labs(title = "Feature Importance in Random Forest Classification Model", x = "Feature", y = "Importance") +
  theme_minimal()
