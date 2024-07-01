# Munich_Rent_Data

The measurement of residential rent based on various facilities and qualities has always
been important for both tenants and landlords. The apartment’s characteristics, size,
and condition result in the average rent within a specific area. Therefore, it is of great
interest which facility and quality can be used more significantly for having an accurate
rent prediction.

In this project, rent indices for Munich are used which are collected in 1999.
It contains net rent of 3082 apartments and 6 other characteristics
and qualities of each. The purpose is to analyze the given data set and determine the
significance of the quality of the location on the rent per square meter, and also examine
pairwise differences between the rent per square meter for different location qualities.

Since project objective is based on rent per square meter, another variable by dividing
rent by size of the living area is added to the data set for further analysis. The ANOVA
assumptions are checked with the help of histograms, box plots, and statistical measures
summary. Furthermore, variance homogeneity assumption is failed and non-parametric
test is required. The Kruskal-Wallis rank sum test is used to determine the significance
of the quality of the location on the rent per square meter. To investigate any probable
pairwise difference between pairs of location, the Wilcoxon test is conducted, first
without any adjustment and then with the correction of p-values using the Bonferroni
method.
