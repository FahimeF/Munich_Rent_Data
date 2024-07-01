library(ggpubr)
library(rstatix)
library(dplyr)

# Set working directory to the script's location (this is useful for portability)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Load data from the working directory
munich_rent_data <- read.csv("rent_index_99.csv", header = TRUE)

# Create a new column for rent per square meter
munich_rent_data$rentsqm <- munich_rent_data$net.rent / munich_rent_data$living.area

# Replace quality of location values 1, 2, 3 with 'average', 'good', and 'top' respectively
munich_rent_data$quality.of.location[munich_rent_data$quality.of.location == 1] <- 'average'
munich_rent_data$quality.of.location[munich_rent_data$quality.of.location == 2] <- 'good'
munich_rent_data$quality.of.location[munich_rent_data$quality.of.location == 3] <- 'top'

# Check missing data
apply(munich_rent_data, 2, function(x) any(is.na(x)))

# Summary of data
summary_data <- group_by(munich_rent_data, quality.of.location) %>%
  summarise(
    count = n(),
    Min = min(rentsqm, na.rm = TRUE),
    mean = mean(rentsqm, na.rm = TRUE),
    median = median(rentsqm, na.rm = TRUE),
    var = var(rentsqm, na.rm = TRUE),
    Max = max(rentsqm, na.rm = TRUE),
    IQR = IQR(rentsqm, na.rm = TRUE)
  )
print(summary_data)

# Variance homogeneity check 
ggboxplot(munich_rent_data, x = "quality.of.location", y = "rentsqm",
          color = "quality.of.location", palette = c("red", "blue", "green"),
          order = c("average", "good", "top"),
          ylab = "RentSqm", xlab = "QualityOfLocation")

# Normality check by histogram
par(mfrow=c(1,3))

averageLocation <- munich_rent_data$rentsqm[munich_rent_data$quality.of.location == 'average']
goodLocation <- munich_rent_data$rentsqm[munich_rent_data$quality.of.location == 'good']
topLocation <- munich_rent_data$rentsqm[munich_rent_data$quality.of.location == 'top']

hist(averageLocation, col = 'red', main = NULL, freq = TRUE, breaks = 15, ylim = c(0, 300))
hist(goodLocation, col = 'red', main = NULL, freq = TRUE, breaks = 15, ylim = c(0, 300))
hist(topLocation, col = 'red', main = NULL, freq = TRUE, breaks = 15, ylim = c(0, 300))

# We want to know if there is any significant difference 
# between the rentsqm of apartments in the 3 quality of locations. we will apply
# non-parametric method Kruskal-walis as data is not normality distributed
kruskal_result <- kruskal.test(rentsqm ~ quality.of.location, data = munich_rent_data)
kruskal_result
# As the p-value is less than the significance level 0.05,
# we can conclude that there are significant differences between the quality of location groups.

# go into more details to check each pair
# before adjustment
pairwise.wilcox.test(munich_rent_data$rentsqm, munich_rent_data$quality.of.location,
                     p.adjust.method = "none")

# before adjustment, there are significant difference between all pair of locations (p < 0.05).

# after adjustment
# Due to multiple testing and possibility of FWER, adjustment is needed 
pairwise.wilcox.test(munich_rent_data$rentsqm, munich_rent_data$quality.of.location,
                     p.adjust.method = "bonferroni")

# after adjustment, there are significant difference between all pair of locations (p < 0.05).

