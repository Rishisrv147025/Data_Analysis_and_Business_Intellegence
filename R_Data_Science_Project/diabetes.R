library(dplyr)
library(ggplot2)
library(tidyr)
data<-read.csv("C:/Users/Admin/Downloads/DiabetesMissingData.csv")
str(data)
# Check for missing values
missing_values <- colSums(is.na(data))

# Print the missing values
print("Missing Values in Each Column:")
print(missing_values)

# Impute missing values for each column based on the chosen strategy

# Impute Glucose with mean
data$Glucose[is.na(data$Glucose)] <- mean(data$Glucose, na.rm = TRUE)

# Impute Diastolic_BP with mean
data$Diastolic_BP[is.na(data$Diastolic_BP)] <- mean(data$Diastolic_BP, na.rm = TRUE)

# Impute Skin_Fold with median (or mean)
data$Skin_Fold[is.na(data$Skin_Fold)] <- median(data$Skin_Fold, na.rm = TRUE)

# Impute Serum_Insulin with median (or mean)
data$Serum_Insulin[is.na(data$Serum_Insulin)] <- median(data$Serum_Insulin, na.rm = TRUE)

# Impute BMI with mean
data$BMI[is.na(data$BMI)] <- mean(data$BMI, na.rm = TRUE)
# Check for missing values
missing_values_1 <- colSums(is.na(data))

# Print the missing values
print("Missing Values in Each Column:")
print(missing_values_1)

# Histogram of Glucose levels
ggplot(data, aes(x = Glucose)) +
  geom_histogram(binwidth = 10, fill = "blue", color = "white") +
  labs(title = "Distribution of Glucose Levels", x = "Glucose", y = "Frequency") +
  theme_minimal()

# Box plot for BMI by Class
ggplot(data, aes(x = factor(Class), y = BMI)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "BMI Distribution by Diabetes Class", x = "Diabetes Class", y = "BMI") +
  theme_minimal()

# Calculate the correlation matrix
cor_matrix <- cor(data[sapply(data, is.numeric)], use = "complete.obs")

# Load corrplot for visualization
library(corrplot)

# Create a heatmap of the correlation matrix
corrplot(cor_matrix, method = "circle", type = "upper", tl.col = "black", tl.srt = 45)

# T-test for BMI between classes
t_test_result <- t.test(BMI ~ Class, data = data)
print(t_test_result)

# If you have more than two groups, use ANOVA
anova_result <- aov(BMI ~ factor(Class), data = data)
summary(anova_result)

# Chi-squared test for the relationship between Pregnant and Class
table_pregnant_class <- table(data$Pregnant, data$Class)
chi_squared_result <- chisq.test(table_pregnant_class)
print(chi_squared_result)

# Logistic regression model
model <- glm(Class ~ Glucose + BMI + Age + Diabetes_Pedigree, data = data, family = binomial)

# Summary of the model
summary(model)

# Predictions
data$predicted_probabilities <- predict(model, type = "response")

# Classify based on a threshold (0.5)
data$predicted_class <- ifelse(data$predicted_probabilities > 0.5, 1, 0)

# Confusion Matrix
table(data$Class, data$predicted_class)

# Load the necessary library for ROC curve
library(pROC)

# ROC Curve
roc_curve <- roc(data$Class, data$predicted_probabilities)
plot(roc_curve, main="ROC Curve")
auc(roc_curve)

