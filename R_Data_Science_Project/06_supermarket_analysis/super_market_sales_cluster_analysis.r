install.packages("cluster")
# Load required libraries
library(dplyr)
library(ggplot2)
library(skimr)
library(lubridate)

data<-read.csv("C:/Users/Admin/Desktop/New folder/01_Supermarket_product_prediction/supermarket_sales - Sheet1.csv")

#Checking for the dataset.
str(data)

#Checking for the null values.
sum(is.na(data))

# Convert Date and Time to proper datetime format
data$Date <- as.Date(data$Date, format="%m/%d/%Y")
data$Time <- hms::as_hms(data$Time)

# Extract additional features from Date
data$Year <- year(data$Date)
data$Month <- month(data$Date)
data$Day <- day(data$Date)
data$Weekday <- weekdays(data$Date)

# Boxplot of Total by Payment Method
ggplot(data, aes(x=Payment, y=Total, fill=Payment)) + 
  geom_boxplot() + 
  labs(title="Boxplot of Total by Payment Method", x="Payment Method", y="Total")

# Distribution of Ratings
ggplot(data, aes(x=Rating)) +
  geom_histogram(binwidth = 0.5, fill="steelblue", color="black") +
  labs(title="Distribution of Ratings", x="Rating", y="Frequency")

# Correlation matrix of numerical features
numeric_cols <- data %>% 
  select(`Unit.price`, Quantity, Tax = `Tax.5.`, Total, cogs, `gross.margin.percentage`, `gross.income`, Rating)

cor_matrix <- cor(numeric_cols)
print(cor_matrix)

# Visualizing the correlation matrix
corrplot::corrplot(cor_matrix, method="circle")

# Feature Engineering: Create a new feature "Total Sales per Customer"
data <- data %>%
  group_by(`Customer.type`) %>%
  mutate(Total_Sales_Per_Customer = sum(Total)) %>%
  ungroup()

# Feature Engineering: Create a new feature "Revenue per Product Line"
data <- data %>%
  group_by(`Product.line`) %>%
  mutate(Revenue_Per_Product_Line = sum(Total)) %>%
  ungroup()

#Bivarient analysis
ggplot(data, aes(x=Unit.price, y=Quantity)) + geom_point() + labs(title="Quantity vs Unit Price")

ggplot(data, aes(x=Gender, y=Total)) + geom_boxplot() + labs(title="Total Spend by Gender")

ggplot(data, aes(x="", y=Total)) + geom_boxplot() + labs(title="Boxplot of Total Sales")

#Average values
data %>% group_by(Customer.type) %>% summarise(Average_Spend = mean(Total))

#Cluster analysis
kmeans_result <- kmeans(data[,c("Unit.price", "Total")], centers=3)

hclust_result <- hclust(dist(data[,c("Unit.price", "Total")]))
