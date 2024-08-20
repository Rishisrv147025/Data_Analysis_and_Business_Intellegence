# Install necessary packages if not already installed
install.packages(c("tidyverse", "caret", "ggplot2", "dplyr", "lubridate"))
install.packages('Amelia')
# Load the libraries
library(tidyverse)
library(caret)
library(ggplot2)
library(dplyr)
library(lubridate)
library(Amelia) 
library(corrplot)


data<-read.csv("C:/Users/Admin/Downloads/electronic_vehicle_dataset.csv")

str(data)

sum(is.na(data))

missing_value<-sapply(data, function(x) sum(is.na(x)))
missing_value

missmap(data, main = "Missing values vs Observed")

data$Postal.Code<-ifelse(is.na(data$Postal.Code),mean(data$Postal.Code,na.rm=TRUE),data$Postal.Code)
data$Legislative.Distric<-ifelse(is.na(data$Legislative.Distric),mean(data$Legislative.District,na.rm=TRUE),data$Legislative.District)
data$X2020.Census.Tract<-ifelse(is.na(data$X2020.Census.Tract),mean(data$X2020.Census.Tract,na.rm=TRUE),data$X2020.Census.Tract)

sum(is.na(data))

# Histogram of Base MSRP
ggplot(data, aes(x = `Base.MSRP`)) +
  geom_histogram(binwidth = 5000, fill = "blue", color = "black") +
  labs(title = "Distribution of Base MSRP", x = "Base MSRP", y = "Count")

# Bar chart for the number of vehicles per make
ggplot(data, aes(x = Make)) +
  geom_bar(fill = "green", color = "black") +
  labs(title = "Number of Vehicles by Make", x = "Make", y = "Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Scatter plot of Electric Range vs Base MSRP
ggplot(data, aes(x = `Electric.Range`, y = `Base.MSRP`)) +
  geom_point(color = "purple") +
  labs(title = "Electric Range vs Base MSRP", x = "Electric Range (miles)", y = "Base MSRP ($)") +
  theme_minimal()

# Boxplot of Base MSRP by Electric Vehicle Type
ggplot(data, aes(x = `Electric.Vehicle.Type`, y = `Base.MSRP`, fill = `Electric.Vehicle.Type`)) +
  geom_boxplot() +
  labs(title = "Base MSRP by Electric Vehicle Type", x = "Electric Vehicle Type", y = "Base MSRP ($)") +
  theme_minimal() +
  theme(legend.position = "none")

# Group by and summarize (example: average MSRP by make)
avg_msrp_by_make <- data %>%
  group_by(Make) %>%
  summarise(Average_MSRP = mean(`Base.MSRP`))
print(avg_msrp_by_make)

# Correlation matrix for numerical features
correlation_matrix <- cor(data[, sapply(data, is.numeric)], use = "complete.obs")
corrplot(correlation_matrix, method = "circle")


data$Model.Year <- as.factor(data$Model.Year)
data$Electric.Vehicle.Type <- as.factor(data$Electric.Vehicle.Type)
data$Clean.Alternative.Fuel.Vehicle..CAFV..Eligibility <- as.factor(data$Clean.Alternative.Fuel.Vehicle..CAFV..Eligibility)

#Let's remove a dataset
# Remove the 'Make' column
data <- data %>% select(-Make)

# Transform categorical variables to factors
data <- data %>%
  mutate(across(where(is.character), as.factor))

# Boxplot for detecting outliers in Electric Range
ggplot(data, aes(y = Electric.Range)) +
  geom_boxplot(fill = "lightcoral") +
  labs(title = "Boxplot of Electric Range", y = "Electric Range")

# Identifying outliers using the IQR method
Q1 <- quantile(data$Electric.Range, 0.25)
Q3 <- quantile(data$Electric.Range, 0.75)
IQR <- Q3 - Q1
outliers <- data[data$Electric.Range < (Q1 - 1.5 * IQR) | data$Electric.Range > (Q3 + 1.5 * IQR), ]

set.seed(123)  # For reproducibility
trainIndex <- createDataPartition(data$Electric.Range, p = .8, 
                                  list = FALSE, 
                                  times = 1)

# Create training and test sets
train_data <- data[trainIndex, ]
test_data <- data[-trainIndex, ]

# Fit a linear regression model without the Make variable
model <- lm(Electric.Range ~ Model.Year + Base.MSRP + Clean.Alternative.Fuel.Vehicle..CAFV..Eligibility, data = train_data)

# Summary of the model
summary(model)

# Make predictions on the test set
predictions <- predict(model, newdata = test_data)

# Compare predictions with actual values
comparison <- data.frame(Actual = test_data$Electric.Range, Predicted = predictions)

# Evaluate the model
postResample(pred = predictions, obs = test_data$Electric.Range)

# Plot actual vs predicted
ggplot(comparison, aes(x = Actual, y = Predicted)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  labs(title = "Actual vs Predicted Electric Range", x = "Actual Electric Range", y = "Predicted Electric Range")

