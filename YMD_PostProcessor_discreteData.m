%% Yaw Moment Diagram: Post Processor (Discrete Data)

%% Clear

clear, clc, close all;

%% Load Data

data(1) = load('YMD Results/YMD_singlePlot.mat'); % Reference data
data(2) = load('YMD Results/YMD_mass600.mat'); name(1) = {'Mass -50 lb'};

% Number of data sets
datasize = length(data);

%% Lateral Acceleration & Yaw Moment @ Basis Points 

% Define basis inputs
basis.SA = 4;
basis.Delta = 4;
basis.SX = 0;

% Find basis index
SA_index = find(data(1).SA == basis.SA);
Delta_index = find(data(1).Delta == basis.Delta);

% Find basis dat
basis.Ay = zeros(datasize, 1);
basis.M = zeros(datasize, 1);
for i = 1: datasize

    basis.Ay(i) = data(i).Ay(SA_index, Delta_index);
    basis.M(i) = data(i).M(SA_index, Delta_index);

end

%% Stability & Control @ Basis Points

% Locate points around basis
basis_left.M = zeros(datasize, 1);
basis_right.M = zeros(datasize, 1);
basis_upper.M = zeros(datasize, 1);
basis_lower.M = zeros(datasize, 1);

for i = 1: datasize

    basis_left.M(i) = data(i).M(SA_index-1, Delta_index);
    basis_right.M(i) = data(i).M(SA_index+1, Delta_index);
    basis_upper.M(i) = data(i).M(SA_index, Delta_index+1);
    basis_lower.M(i) = data(i).M(SA_index, Delta_index-1);

    % Stability: d(yaw moment)/d(body slip angle) [lb*ft/deg]
    stability.left(i) = (basis_left.M(i) - basis.M(i)) / (data(i).SA(SA_index-1) - data(i).SA(SA_index));
    stability.right(i) = (basis_right.M(i) - basis.M(i)) / (data(i).SA(SA_index+1) - data(i).SA(SA_index));
    stability.average(i) = (stability.left(i) + stability.right(i)) / 2;

    % Control: d(yaw moment)/d(steering angle) [lb*ft/deg]
    control.upper(i) = (basis_upper.M(i) - basis.M(i)) / (data(i).Delta(Delta_index+1) - data(i).Delta(Delta_index));
    control.lower(i) = (basis_lower.M(i) - basis.M(i)) / (data(i).Delta(Delta_index-1) - data(i).Delta(Delta_index));
    control.average(i) = (control.lower(i) + control.upper(i)) / 2;

end

% Stability and control differences [%]
stability.diff = zeros(datasize-1, 1);
control.diff = zeros(datasize-1, 1);
for i = 1: datasize-1

    stability.diff(i) = (stability.average(i+1) - stability.average(1)) * 100 / stability.average(1);
    control.diff(i) = (control.average(i+1) - control.average(1)) * 100 / control.average(1);

end

%% Plotting

% Vehicle sensitivity
figure;
bar(categorical(name), stability.diff);
ylabel('Difference [%]')
title('Vehicle Stability @ Basis');