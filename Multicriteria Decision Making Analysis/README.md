Multicriteria Decision Making Analysis

Input files 

1. Performance_measure.txt - This file contains a [m x n] matrix (m is the number of school buildings considered in the MCDM analysis, n is the number of criteria in the analysis). More information on defining the performance measures are provided in Opabola and Galasso (under review).
2. Wcriteria.txt -  This file is used to specify if the considered criterion is a cost or benefit criterion (See Table 2 of paper)
3. criteria_weights_scenario_3.txt - Weight of each considered criterion.


Matlab scripts

Topsis.m - This script runs the Technique for Order of Preference by Similarity to Ideal Solution (TOPSIS) which was originally developed by Ching-Lai Hwang and Yoon in 1981
