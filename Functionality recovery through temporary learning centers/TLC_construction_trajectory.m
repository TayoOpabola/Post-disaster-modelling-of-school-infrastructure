% Simulating recovery trajectory of school infrastructure (construction of
% temporary learning centres (TLC))
% Created by Tayo Opabola, 03/04/2020 Updated 05/06/2022
%
% The code presented below is described in the document below
%
% Opabola E.A. & Galasso C. "Informing disaster-risk management policies
% for education infrastructure using scenario-based recovery analyses"
% (under review)


%% Input parameters
D_02s = load('put location of mat file');
D_PGA = load('put location of mat file');

%median values used for analysis
D_02s = median(D_02s.D_02s);
D_PGA= median(D_PGA.D_PGA);

Fragility = [0.2 0.4; 0.5 0.4; 0.5 0.4; 1 0.4]; % Fragility functions of buildings exceeding the FL1 functionality level. first column = median value and second column = logarithmic dispersion
N_s = 1000; % how many Monte-Carlo simulations to run

% Information on school buildings
Buildings = importdata('building_info.txt'); % column 1- school ID (1-80); column 2- number of students in each building ; column 3 (pre-code 0, post-code 1); column 4- number of stories; column 5 building typology (1- 1story precode, 2- 2storu precodde, 3- 1story postcode, 4- 2story postcode)
Type = Buildings(:,5); % used to define building typology
no_build = Buildings(:,1); % school ID
no_schools = importdata('initial_location.txt'); %contains school ID and location. Location has been erased from the uploadrd file for confidentiality reasons
no_stories = Buildings(:,4);
transisi = importdata('transisi.txt'); %Availability of anticipatory funds for construction of temporary learning centres (TLC) (1 - yes, 0 - No)

%%

%% output of recovery time analysis for construction of TLC (see recovery time analysis file)
% Time to complete construction of TLC assuming availability of
% anticipatory funds
%NB: Because most TLCs are non-engineered make-shift structures, the
%analysis assumes each school are able to source for labour without
%problems
m_rt = 40;  %median in days
sigma_rt = 0.25;  %logarithmic standard deviation  (NB: another option is to simply simulate input N_s simulated time directly from the recovery time analysis)
% Time to complete construction of TLC assuming inavailability of
% anticipatory funds
m_st = 100; %median in days
sigma_st = 0.25;  %logarithmic standard deviation


%% This code extracts the distribution of seismic intensity at each building site. 

for i = 1: length (no_build)
    
    c = no_build(i);
    D_02s_final(:,i) = D_02s(c);  % A Sa(0.2sec) was adopted for the 2-story buildings (similar to the fragility functions)
    
end

for i = 1: length (no_build)
    
    c = no_build(i);
    D_PGA_final(:,i) = D_PGA(c); % A PGA was adopted for the 1-story buildings (similar to the fragility functions)
    
end

%% plot generation


ss= [0 0];
plot(ss,ss, 'color', [.5 .5 .5])
hold on
plot(ss,  ss, 'k--','LineWidth',1)



%% MCS for functionality level of each school building
for i = 1: length (Type)
         
        median = (Fragility(Type(i),1));
        sigma = (Fragility(Type(i),2));
    
        Sa = lognrnd(log(median), sigma, [N_s 1]);
        
        if Type(i)==1 || Type(i)== 3
            Sa_demand = D_02s_final(:,i);
        else
            Sa_demand = D_PGA_final(:,i);
        end
        
        State = Sa_demand - Sa;
        
        for j = 1 : length (State)
            
            if State(j) >= 0
                DS(j) = 0;
            else
                DS(j) = 1;
            end
        end
        
        WDS(:,i) = DS;
                
end
% If FL > FL1 0, else 1
%% Estimate proportion of students with access to FL0 & FL1 buildings for each simulation
for i = 1 : length(Type)
    
    WW(:,i) = Buildings(i,2)* WDS(:,i);
    
end


for iii = 1:N_s
    for i = 1: length(no_schools)
        pop_cont(iii,i) = 0;
        for j = 1:length(Type)
            
            if Buildings(j,1) == i
                pop_cont(iii,i) = WW(iii,j) + pop_cont(iii,i);
                
            else
                pop_cont(iii,i) = 0 + pop_cont(iii,i);
            end
            
        end
        
    end
end



for i = 1: length(no_schools)
    tot_pop(i) = 0;
    for j = 1:length(Type)
        
        if Buildings(j,1) == i
            tot_pop(i) = Buildings(j,2) + tot_pop(i);
            
        else
            tot_pop(i) = 0 + tot_pop(i);
        end
        
    end
    
end


for i = 1: N_s
    
    for j = 1: length (no_schools)
    
        proportion(i,j) = pop_cont(i,j)/tot_pop(j);
    
    end
end

%%

%Sort out availability of anticipatory funds for school buildings with FL >
%FL1

for i = 1: length (no_build)
    
    c = no_build(i);
    trans(i,1) = transisi(c);
    
end

for i = 1: length (no_build)
    
    if trans(i) == 1
        
        rec_time(:,i) = lognrnd(log(m_rt), sigma_rt, [N_s 1]);
    
    else
        
        rec_time(:,i) = lognrnd(log(m_st), sigma_st, [N_s 1]);
        
    end
    
end

for i = 1:N_s
    
    for j = 1 : length (no_build)
        
        
       final(j,1) = Buildings(j,2);
       final(j,2) = WDS(i,j);
       final (j,3) = rec_time (i,j);
       
       if final(j,2) ==1
           final(j,4) = 0;
       else
           final (j,4) = final (j,3);
           
       end
      
       
       
    end
    
    sort_final = sortrows(final,4);
    sort_final(1,5) =  sort_final(1,1);
    for jj = 2: length (no_build)
        sort_final(jj,5) = sort_final(jj,1)+ sort_final(jj-1,5);
    end
    
    xxx = 0;
    for jjj = 1: length (no_build)
        
        if sort_final(jjj,4) == 0
            starter = xxx+jjj;
        end
    end
    
    functionality = sort_final(starter:end,5);
    time = sort_final(starter:end,4);
    
    plot(time,functionality,'color', [.5 .5 .5])
    hold on
    
end

% Plot points to get the 'pre-disaster' line in the plot
pre_dis_y = [17055 17055 10850];
pre_dis_x =[-50 0 0];

plot (pre_dis_x, pre_dis_y,'color', [.5 .5 .5])

xlim([-30 250])
ylabel({'Number of students in' ;'continued education at schools'});

% Create xlabel
xlabel('Time after earthquake [days]')

set(gca,'FontSize',16)

ax = gca;
ax.YAxis.Exponent = 0;


