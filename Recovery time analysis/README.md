Recovery time analysis


Input files
1. intervention_sequence.dat - This file contains the intervention sequence for tasks needed for a damaged building to attain a given functionality level. User should specify the task in column 1. Preceding tasks should be placed in column 2. 
2. PERT_info.txt - This file contains the estimated [a, m, b] for each task (this accounts for the mitigation and amplification factors). More information on how to calculate a, m and b are available in Opabola and Galasso (under review).

Matlab scripts
1. Recovery_time_analysis.m - This is the main script. Here is where you specify the input parameters. It also runs the Monte Carlo Simulation to generate probabilistic distribution of recovery time
2. cpm_new.m - This script runs the critical path analysis for each simulation (There is no need to modify this script).
3. buildGraph.m - This script builds the intervent graph (There is no need to modify this script).
4. activityToIndex.m - This script is used to convert predecessors and successors to indices for easier manipulation (There is no need to modify this script).
