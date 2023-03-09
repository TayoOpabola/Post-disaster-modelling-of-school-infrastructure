%% Estimating the recovery time to attain a functionality level, given an intervention sequence
% 

% The algorithm returns the distribution of recovery time to achieve a functionality level, accounting for socioeconomic, political, technical, environmental, cultural factors that can impede recovery 
% Created by Tayo Opabola, 08/08/2021
%
% The code presented below is described in the document below
%
% Opabola E.A. & Galasso C. "Informing disaster-risk management policies
% for education infrastructure using scenario-based recovery analyses"
% (under review)


%% Input parameters
nn = 1000;  % number of Monte Carlo Simulations

filename ='intervention_sequence.dat';  % File containing the intervention sequence for tasks needed for a damaged building to attain a given functionality level
file = importdata('PERT_parameters.txt'); % File containing the estimated [a, m, b] for each task (this accounts for the mitigation and amplification factors)


%% Generate nn samples from the PERT distribution for each task using specified [a, m, b]

[row, column] =size (file);

for i = 1:row
    
          
     Rand(i,:) = randp([file(i,1) file(i,2) file(i,2)],[1,nn]);   
        
        
end

%% Run CPM analysis for each simulation 
fileId = fopen(filename);
Data = textscan(fileId,'%s %s');
fclose(fileId);

for i = 1: nn
    Data{1,3} = Rand(:,i);
    Time(i,1) = cpm_new(Data);
end


ecdf(Time)
%% Fit distribution to simulated Time

% [theta, beta] = fit_rel_dist (Time);
