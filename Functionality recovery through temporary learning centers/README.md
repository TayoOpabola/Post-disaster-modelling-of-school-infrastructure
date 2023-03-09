Functionality recovery through temporary learning centers


Input files

building_info.txt - This file contains information on each school building column 1- school ID (1-80); column 2- number of students in each building ; column 3 (pre-code 0, post-code 1); column 4- number of stories; column 5 building typology (1- 1story precode, 2- 2story precodde, 3- 1story postcode, 4- 2story postcode).
initial_location.txt.txt - This file contains school ID and location. Location has been erased from the uploadrd file for confidentiality reasons.
transisi.txt - This file contains information on the availability of anticipatory funds for construction of temporary learning centres (TLC) (1 - yes, 0 - No).
D_02s.mat & D_PGA.mat - These files contain the seismic intensities that are used in simulating the functionality levels of the school buildings. These sample files have been derived from a hazard analysis as described in Opabola and Galasso (under review).


Matlab scripts

TLC_construction_trajectory.m - This script is used to simulate the  short-term recovery trajectory of school infrastructure (which typically entails the construction of temporary learning centres (TLC)).
