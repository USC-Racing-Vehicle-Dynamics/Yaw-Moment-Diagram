%% Yaw Moment Diagram: Post Processor (Discrete Data)

%% Clear

clear, clc, close all;

%% Load Data

cd ..
addpath('YMD Results');

d = 0;
n = 0;

data(d+1) = load('YMD Results/YMD_default.mat'); d = d + 1; % Reference data
data(d+1) = load('YMD Results/YMD_fwd-4.mat'); name(n+1) = {'Front Weight Distribution -4%'}; d = d + 1; n = n + 1;
data(d+1) = load('YMD Results/YMD_rearToe+2.mat'); name(n+1) = {'Rear Toe +2 deg'};  d = d + 1; n = n + 1;
data(d+1) = load('YMD Results/YMD_frontSpring-40.mat'); name(n+1) = {'Front Spring Stiffness -40 lb/in'}; d = d + 1; n = n + 1;
data(d+1) = load('YMD Results/YMD_frontToe+2.mat'); name(n+1) = {'Front Toe +2 deg'}; d = d + 1; n = n + 1;
data(d+1) = load('YMD Results/YMD_frontToe-2.mat'); name(n+1) = {'Front Toe -2 deg'}; d = d + 1; n = n + 1;
data(d+1) = load('YMD Results/YMD_CGh-10%.mat'); name(n+1) = {'CG Height -10%'}; d = d + 1; n = n + 1;
data(d+1) = load('YMD Results/YMD_rearToe-2.mat'); name(n+1) = {'Rear Toe -2 deg'}; d = d + 1; n = n + 1;
data(d+1) = load('YMD Results/YMD_mass-10%.mat'); name(n+1) = {'Mass -10%'}; d = d + 1; n = n + 1;

% Number of data sets
datasize = length(data);

%% Grip Analysis (Lateral Acceleration & Yaw Moment)

% Lateral accelerations at grip [G]
grip.Ay_left = zeros(datasize, 1);
grip.Ay_right = zeros(datasize, 1);

% Yaw Moment at grip [lb*ft]
grip.M_left = zeros(datasize, 1);
grip.M_right = zeros(datasize, 1);

for i = 1: datasize

    grip.Ay_left(i) = min(data(i).Ay, [], "all");
    grip.Ay_right(i) = max(data(i).Ay, [], "all");

    grip.M_left(i) = data(i).M(data(i).Ay == grip.Ay_left(i));
    grip.M_right(i) = data(i).M(data(i).Ay == grip.Ay_right(i));

end

% Absolute average lateral acceleration [G]
grip.Ay_absAvg = (abs(grip.Ay_left) + abs(grip.Ay_right))/2;

% Absolute average yaw moment [lb*ft]
grip.M_absAvg = (abs(grip.M_left) + abs(grip.M_right))/2;


% Differences with respect to reference [%]
grip.Ay_diff = zeros(datasize-1, 1);
grip.M_diff = zeros(datasize-1, 1);
for i = 1: datasize-1

    grip.Ay_diff(i) = (grip.Ay_absAvg(i+1) - grip.Ay_absAvg(1)) * 100 / grip.Ay_absAvg(1);
    grip.M_diff(i) = (grip.M_absAvg(i+1) - grip.M_absAvg(1)) * 100 / grip.M_absAvg(1);

end

%% Limit Balance Analysis (Lateral Acceleration)

addpath('YMD (v6.2)');

for i = 1: datasize

    intersection = [];

    for j = 1: length(data(i).SA)
    
        SA_isoline_x = data(i).Ay(j, :);
        SA_isoline_y = data(i).M(j, :);
    
        SA_isoline = [SA_isoline_x; SA_isoline_y];
    
        M0_line = [-5 5; 0 0];
    
        [~, intersection(j, :)] = GetPolyLineIntersection(SA_isoline, M0_line);
    
    end

    % Find limit balance accelerations [G]
    limitBalance.Ay_right(i) = max(intersection(:, 1)); 
    limitBalance.Ay_left(i) = min(intersection(:, 1));
    limitBalance.Ay_absAvg(i) = (limitBalance.Ay_right(i) - limitBalance.Ay_left(i)) / 2;

end

% Differences with respect to reference [%]
limitBalance.Ay_diff = zeros(datasize-1, 1);
for i = 1: datasize-1

    limitBalance.Ay_diff(i) = (limitBalance.Ay_absAvg(i+1) - limitBalance.Ay_absAvg(1)) * 100 / limitBalance.Ay_absAvg(1);

end

%% Self-Defined Basis Analysis (Lateral Acceleration & Yaw Moment)

% Define basis inputs
basis.SA = 4;
basis.Delta = 4;
basis.SX = 0;

% Find basis index
SA_index = find(data(1).SA == basis.SA);
Delta_index = find(data(1).Delta == basis.Delta);

% Find basis data
basis.Ay = zeros(datasize, 1);
basis.M = zeros(datasize, 1);
for i = 1: datasize

    basis.Ay(i) = data(i).Ay(SA_index, Delta_index);
    basis.M(i) = data(i).M(SA_index, Delta_index);

end

%% Self-Defined Basis Analysis (Stability & Control)

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
    basisStability.left(i) = (basis_left.M(i) - basis.M(i)) / (data(i).SA(SA_index-1) - data(i).SA(SA_index));
    basisStability.right(i) = (basis_right.M(i) - basis.M(i)) / (data(i).SA(SA_index+1) - data(i).SA(SA_index));
    basisStability.average(i) = (basisStability.left(i) + basisStability.right(i)) / 2;

    % Control: d(yaw moment)/d(steering angle) [lb*ft/deg]
    basisControl.upper(i) = (basis_upper.M(i) - basis.M(i)) / (data(i).Delta(Delta_index+1) - data(i).Delta(Delta_index));
    basisControl.lower(i) = (basis_lower.M(i) - basis.M(i)) / (data(i).Delta(Delta_index-1) - data(i).Delta(Delta_index));
    basisControl.average(i) = (basisControl.lower(i) + basisControl.upper(i)) / 2;

end

% Differences with respect to reference [%]
basisStability.diff = zeros(datasize-1, 1);
basisControl.diff = zeros(datasize-1, 1);
for i = 1: datasize-1

    basisStability.diff(i) = (basisStability.average(i+1) - basisStability.average(1)) * 100 / basisStability.average(1);
    basisControl.diff(i) = (basisControl.average(i+1) - basisControl.average(1)) * 100 / basisControl.average(1);

end

%% Sort Data

[grip.M_diff, grip_sortIndex] = sort(grip.M_diff, 'descend');
[limitBalance.Ay_diff, limitBalance_sortIndex] = sort(limitBalance.Ay_diff, 'descend');
[basisStability.diff, stability_sortIndex] = sort(basisStability.diff, 'descend');
[basisControl.diff, control_sortIndex] = sort(basisControl.diff, 'descend');

for i = 1: length(name)

    name_sorted.grip{i} = name{grip_sortIndex(i)};
    name_sorted.limitBalance{i} = name{limitBalance_sortIndex(i)};
    name_sorted.stability{i} = name{stability_sortIndex(i)};
    name_sorted.control{i} = name{control_sortIndex(i)};
 
end

%% Plotting

% Vehicle sensitivity
figure;
tiledlayout(2, 2);

nexttile; 
bar(name_sorted.grip, grip.M_diff);
ylabel('Difference [%]');
title('Yaw Moment @ Grip');

nexttile;
bar(name_sorted.limitBalance, limitBalance.Ay_diff);
ylabel('Difference [%]');
title('Lateral Acceleration @ Limit Balance');

nexttile;
bar(name_sorted.stability, basisStability.diff);
ylabel('Difference [%]');
title('Vehicle Stability @ Basis');
subtitle(sprintf('Slip Angle = %d deg, Steering = %d deg', basis.SA, basis.Delta));

nexttile;
bar(name_sorted.control, basisControl.diff);
ylabel('Difference [%]');
title('Vehicle Control @ Basis');
subtitle(sprintf('Slip Angle = %d deg, Steering = %d deg', basis.SA, basis.Delta));