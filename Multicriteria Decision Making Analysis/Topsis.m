% A matlab code to run the Technique for Order of Preference by Similarity to Ideal Solution (TOPSIS) hich was originally developed by Ching-Lai Hwang and Yoon in 1981

% Written by Tayo Opabola
%
% The code presented below was used in:
%
% Opabola E.A. & Galasso C. "Informing disaster-risk management policies
% for education infrastructure using scenario-based recovery analyses"
% (under review)

%% Input parameters
Wcriteria = importdata('Wcriteria.txt'); % used to identify cost and benefit criteria (See Table 2 of paper)
W = importdata('criteria_weights_scenario_3.txt'); % weight of each criterion
X = importdata('Performance_measure.txt'); % performance measures defined using tables (See Tables 3 & 4 of paper for more discussions)


Xval=length(X(:,1));
Y = zeros([Xval,length(W)]);
%% calculating the normalized matrix
for j=1:length(W)
    for i=1:Xval
    Y(i,j)=X(i,j)/sqrt(sum((X(:,j).^2)));
    end
end
Normalized_Matrix = num2str([Y])
%% calculating the weighted mormalized matrix
for j=1:length(W)
    for i=1:Xval
        Yw(i,j)=Y(i,j).*W(j);
    end
end
Weighted_Normalized_Matrix = num2str([Yw])
%% calculating the positive and negative best
 
for j=1:length(W)
    if Wcriteria(1,j)== 0
        Vp(1,j)= min(Yw(:,j));
        Vn(1,j)= max(Yw(:,j));
    else
        Vp(1,j)= max(Yw(:,j));
        Vn(1,j)= min(Yw(:,j));
    end
end
 Positive_best = num2str([Vp])
 Negative_best = num2str([Vn])
 
%% Euclidean distance from Ideal Best and Worst
for j=1:length(W)
    for i=1:Xval
        Sp(i,j)=((Yw(i,j)-Vp(j)).^2);
        Sn(i,j)=((Yw(i,j)-Vn(j)).^2);
    end
end
 
for i=1:Xval
    Splus(i)=sqrt(sum(Sp(i,:)));
    Snegative(i)=sqrt(sum(Sn(i,:)));
end
%% calculating the performance score
P=zeros(Xval,1);
for i=1:Xval
    P(i)=Snegative(i)/(Splus(i)+Snegative(i));
end
Performance_Score =  num2str([P])

[C,~,ic] = unique(P,'sorted'); % ic are ranks from lowest to highest ; C are unique values
r=(1+max(ic)-ic);  % r: rank (highest receives 1; lowest receives length(C); tied values receive same rank)
[P,r]
