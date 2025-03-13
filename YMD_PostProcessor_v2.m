%% Yaw Moment Diagram: Post Processor

%% Clear

clear, clc, close all;

%% Load Data

YMDData = load('YMD Sweep Results/YMD_sweepPlots.mat');


% T = readtable("YMDDataTable_40mph.xlsx", opts);
% sweptParam = table2array(T(:, 4));
% 
% V_mph = table2array(T(9, 2));


%% Sweep Information

noSweepPts = length(YMDData.sweptParameter.value);

%% Acceleration & Yaw Moment @ Grip

% Accelerations at grip [G]
leftGrip_Accel = zeros(noSweepPts, 1);
rightGrip_Accel = zeros(noSweepPts, 1);

% Yaw Moment at grip [lb*ft]
leftGrip_YM = zeros(noSweepPts, 1);
rightGrip_YM = zeros(noSweepPts, 1);

for i = 1: noSweepPts

    [leftGrip_Accel(i), leftGripIndex] = min(YMDData.Ay(:, :, i), [], "all");
    [rightGrip_Accel(i), rightGripIndex] = max(YMDData.Ay(:, :, i), [], "all");

    Mi = YMDData.M(:, :, i);
    Ayi = YMDData.Ay(:, :, i);
    leftGrip_YM(i) = Mi(Ayi == leftGrip_Accel(i));
    rightGrip_YM(i) = Mi(Ayi == rightGrip_Accel(i));

end

% Absolute average yaw moment [lb*ft]
absAvgGrip_YM = (abs(leftGrip_YM) + abs(rightGrip_YM))/2;

%% Acceleration @ Basis Points 
SweepRange = YMDData.sweptParameter.value;
plot(SweepRange, absAvgGrip_YM); 
xlabel(YMDData.sweptParameter.name); 
ylabel('Absolue Average Yaw Moment'); 