# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(caret)
library(randomForest)
library(corrplot)
library(Amelia)

data<-read.csv("C:/Users/Admin/Downloads/appleStore_1.csv")

str(data)

sum(is.na(data))

missmap(data, main = "Missing values vs Observed")

data$cont_rating <- as.numeric(gsub("\\+", "", data$cont_rating))

# Distribution of app prices
ggplot(data, aes(x = price)) + 
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of App Prices", x = "Price", y = "Count")

ggplot(data, aes(x = user_rating)) + 
  geom_histogram(binwidth = 0.5, fill = "green", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of User Ratings", x = "User Rating", y = "Count")

# Total number of ratings by genre
total_ratings_by_genre <- data %>%
  group_by(prime_genre) %>%
  summarise(total_ratings = sum(rating_count_tot))
print(total_ratings_by_genre)

# Top 10 most expensive apps
top_10_expensive_apps <- data %>%
  arrange(desc(price)) %>%
  head(10)
print(top_10_expensive_apps)

# Group by genre and calculate average user rating and price
genre_summary <- data %>%
  group_by(prime_genre) %>%
  summarise(avg_rating = mean(user_rating, na.rm = TRUE),
            avg_price = mean(price, na.rm = TRUE),
            app_count = n()) %>%
  arrange(desc(avg_rating))

ggplot(genre_summary, aes(x = reorder(prime_genre, avg_rating), y = avg_rating)) +
  geom_bar(stat = "identity", fill = "purple") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Average User Rating by Genre", x = "Genre", y = "Average Rating")

# Count of Apps by Currency
ggplot(data, aes(x = currency)) +
  geom_bar(fill = "purple") +
  labs(title = "Count of Apps by Currency", x = "Currency", y = "Count")

# Count of Apps by Content Rating
ggplot(data, aes(x = cont_rating)) +
  geom_bar(fill = "cyan") +
  labs(title = "Count of Apps by Content Rating", x = "Content Rating", y = "Count")

# Count of Apps by Prime Genre
ggplot(data, aes(x = prime_genre)) +
  geom_bar(fill = "lightgreen") +
  coord_flip() +
  labs(title = "Count of Apps by Prime Genre", x = "Prime Genre", y = "Count")

# Correlation matrix of numeric variables
numeric_vars <- data %>% select_if(is.numeric)
corr_matrix <- cor(numeric_vars)
corrplot(corr_matrix, method = "color")

# Create a new feature - log of price to handle skewness
data$log_price <- log1p(data$price)

# Boxplot for detecting outliers in User Rating
ggplot(data, aes(y = user_rating)) +
  geom_boxplot(fill = "lightcoral") +
  labs(title = "Boxplot of User Rating", y = "User Rating")

# Identifying outliers using the IQR method for User Rating
Q1 <- quantile(data$user_rating, 0.25)
Q3 <- quantile(data$user_rating, 0.75)
IQR <- Q3 - Q1
user_rating_outliers <- data[data$user_rating < (Q1 - 1.5 * IQR) | data$user_rating > (Q3 + 1.5 * IQR), ]

# Display outliers
print(nrow(user_rating_outliers))
head(user_rating_outliers)

# Repeat for other numerical variables, e.g., price
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

# Select features for the model
features <- data %>% select(id, size_bytes, log_price, rating_count_tot, rating_count_ver, user_rating, prime_genre)

# Split the data into training and testing sets
set.seed(123)
train_index <- createDataPartition(features$user_rating, p = 0.8, list = FALSE)
train_data <- features[train_index, ]
test_data <- features[-train_index, ]

# Train the random forest model
set.seed(123)
rf_model <- randomForest(user_rating ~ ., data = train_data, ntree = 100)

# Print model summary
print(rf_model)

# Make predictions on the test set
predictions <- predict(rf_model, test_data)

# Calculate Mean Absolute Error
mae <- mean(abs(predictions - test_data$user_rating))
print(paste("Mean Absolute Error (MAE):", mae))

# Calculate Mean Squared Error
mse <- mean((predictions - test_data$user_rating)^2)
print(paste("Mean Squared Error (MSE):", mse))

# Calculate Root Mean Squared Error
rmse <- sqrt(mse)
print(paste("Root Mean Squared Error (RMSE):", rmse))

# Calculate R-squared
r_squared <- 1 - (sum((predictions - test_data$user_rating)^2) / sum((mean(test_data$user_rating) - test_data$user_rating)^2))
print(paste("R-squared:", r_squared))

# Scatter plot: Actual vs Predicted
ggplot(data = test_data, aes(x = user_rating, y = predictions)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_abline(slope = 1, intercept = 0, color = "red") +  # Line of perfect prediction
  labs(title = "Actual vs Predicted User Ratings", x = "Actual User Rating", y = "Predicted User Rating")

# Residuals
residuals <- test_data$user_rating - predictions

# Residual plot
ggplot(data = test_data, aes(x = predictions, y = residuals)) +
  geom_point(color = "orange", alpha = 0.5) +
  geom_hline(yintercept = 0, color = "red") +  # Line at 0
  labs(title = "Residuals vs Predicted", x = "Predicted User Rating", y = "Residuals")
