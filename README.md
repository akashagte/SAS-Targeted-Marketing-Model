# SAS
Targeted Cross-Sell campaign for Time Deposit A/Cs of Wells Fargo

OBJECTIVES
#PHASE1: Data Cleansing and Merging
> Merge US Census Zipcode data for Texas with FDIC data for branch-level details of Wells Fargo
> Clean the merged dataset by analysing and deleting missing records

#Phase2: Segmentation
> Segregate highly correlated attributes (Pearson factor, r > .8), and eliminate one with less discrimination in samples
> Detect themes in the dataset for the remaining attributes (by testing different combinations of nfactor, fuzz and mineigen)

#Phase3: Variable Conversion
> Convert Nominal variables to Binary and set Ordinal variables to middle of the range values
> Check Ordinal variables for Linearity (compare linear and quadratic form of variables based on Schwartz Criteria)

#Phase4: Forecasting
> Segregate dataset into Training and Testing samples with ranuni module
> Run Logistic Regression algorithm (stepwise selection) on Training sample to detect important predictors for response variable
> Score the model for Testing sample and compare Accuracy results to detect Overfitting of variables
> Run Linear Regression algorithm with important Predictors, to explain the results to the Business entities


RESULT
> Forecasted 73% sales from interactions with only 48% of segmented consumer sample
