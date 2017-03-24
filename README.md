# SAS
Targeted Cross-Sell campaign for Time Deposit A/Cs of Wells Fargo

OBJECTIVES
#PHASE1: Data Cleansing and Merging
1. Merge US Census Zipcode data for Texas with FDIC data for branch-level details of Wells Fargo
2. Clean the merged dataset by analysing and deleting missing records

#Phase2: Segmentation
1. Segregate highly correlated attributes (Pearson factor, r > .8), and eliminate one with less discrimination in samples
2. Detect themes in the dataset for the remaining attributes (by testing different combinations of nfactor, fuzz and mineigen)

#Phase3: Variable Conversion
1. Convert Nominal variables to Binary and set Ordinal variables to middle of the range values
2. Check Ordinal variables for Linearity (compare linear and quadratic form of variables based on Schwartz Criteria)

#Phase4: Forecasting
1. Segregate dataset into Training and Testing samples with ranuni module
2. Run Logistic Regression algorithm (stepwise selection) on Training sample to detect important predictors for response variable
3. Score the model for Testing sample and compare Accuracy results to detect Overfitting of variables
4. Run Linear Regression algorithm with important Predictors, to explain the results to the Business entities


RESULT:
Forecasted 73% sales from interactions with only 48% of segmented consumer sample
