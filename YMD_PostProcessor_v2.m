%% Yaw Moment Diagram: Post Processor

%% Clear

clear, clc, close all;

%% Load Data

YMDData = load('YMD Sweep Results/test.mat');


% T = readtable("YMDDataTable_40mph.xlsx", opts);
% sweptParam = table2array(T(:, 4));
% 
% V_mph = table2array(T(9, 2));


%% Sweep Information

sweepVarName = YMDData.sweptParameter.name; % Sweep parameter name
sweepVarValue = YMDData.sweptParameter.value; % Sweep parameter value
sweepVarRange = length(YMDData.sweptParameter.value); % # Sweep parameter range

%% Lateral Acceleration & Yaw Moment @ Grip

% Lateral accelerations at grip [G]
Ay_leftGrip = zeros(sweepVarRange, 1);
Ay_rightGrip = zeros(sweepVarRange, 1);

% Yaw Moment at grip [lb*ft]
M_leftGrip = zeros(sweepVarRange, 1);
M_rightGrip = zeros(sweepVarRange, 1);

for i = 1: sweepVarRange

    Ay_leftGrip(i) = min(YMDData.Ay(:, :, :, i), [], "all");
    Ay_rightGrip(i) = max(YMDData.Ay(:, :, :, i), [], "all");

    Mi = YMDData.M(:, :, :, i);
    Ayi = YMDData.Ay(:, :, :, i);
    M_leftGrip(i) = Mi(Ayi == Ay_leftGrip(i));
    M_rightGrip(i) = Mi(Ayi == Ay_rightGrip(i));

end

% Absolute average lateral acceleration [G]
absAvgGrip_Ay = (abs(Ay_leftGrip) + abs(Ay_rightGrip))/2;

% Absolute average yaw moment [lb*ft]
absAvgGrip_M = (abs(M_leftGrip) + abs(M_rightGrip))/2;

%% Lateral Acceleration & Yaw Moment @ Basis Points 

% Define basis inputs
basis.SA = 4;
basis.Delta = 4;
basis.SX = 0;

% Find basis index
SA_index = find(YMDData.SA == basis.SA);
Delta_index = find(YMDData.Delta == basis.Delta);
SX_index = find(YMDData.SX == basis.SX);

% Find basis data
basis.Ay = zeros(sweepVarRange, 1);
basis.M = zeros(sweepVarRange, 1);
for i = 1: sweepVarRange

    basis.Ay(i) = YMDData.Ay(SA_index, Delta_index, SX_index, i);
    basis.M(i) = YMDData.M(SA_index, Delta_index, SX_index, i);

end

%% Stability & Control @ Basis Points

% Locate points around basis
basis_left.M = zeros(sweepVarRange, 1);
basis_right.M = zeros(sweepVarRange, 1);
basis_upper.M = zeros(sweepVarRange, 1);
basis_lower.M = zeros(sweepVarRange, 1);

for i = 1: sweepVarRange

    basis_left.M(i) = YMDData.M(SA_index-1, Delta_index, SX_index, i);
    basis_right.M(i) = YMDData.M(SA_index+1, Delta_index, SX_index, i);
    basis_upper.M(i) = YMDData.M(SA_index, Delta_index+1, SX_index, i);
    basis_lower.M(i) = YMDData.M(SA_index, Delta_index-1, SX_index, i);

end

% Stability: d(yaw moment)/d(body slip angle) [lb*ft/deg]
stability.left = (basis_left.M - basis.M) / (YMDData.SA(SA_index-1) - YMDData.SA(SA_index));
stability.right = (basis_right.M - basis.M) / (YMDData.SA(SA_index+1) - YMDData.SA(SA_index));

% Control: d(yaw moment)/d(steering angle) [lb*ft/deg]
control.upper = (basis_upper.M - basis.M) / (YMDData.Delta(Delta_index+1) - YMDData.Delta(Delta_index));
control.lower = (basis_lower.M - basis.M) / (YMDData.Delta(Delta_index-1) - YMDData.Delta(Delta_index));

%% Plotting

% Lateral acceleration & yaw moment @ grip
figure; hold on; grid on;
xlabel(sweepVarName); 
yyaxis left
plot(sweepVarValue, absAvgGrip_Ay);
ylabel('Absolue Average Lateral Acceleration [G]'); 
yyaxis right
plot(sweepVarValue, absAvgGrip_M);
ylabel('Absolue Average Yaw Moment [lb*ft]'); 
title('Grip Analysis');