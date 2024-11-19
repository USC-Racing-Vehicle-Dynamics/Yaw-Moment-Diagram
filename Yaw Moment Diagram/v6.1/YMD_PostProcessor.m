%% Yaw Moment Diagram: Post Processor

%% Clear

clear, clc, close all;

%% Column Names of YMD Data Table (Keep Commented)


% 1 Parameters                                  2  Nominal Value
%----------------------------------------------------------------------------------------
% 3  No.                                        4  Swept Parameter 
% 5  Left Grip Acceleration [G]                 6  Left Grip Yaw Moment [lb*ft]
% 7  Right Grip Acceleration [G]                8  Right Grip Yaw Moment [lb*ft]
% 9  Left Limit Balance Acceleration [G]        10 Right Limit Balance Acceleration [G]
% 11 Basis Point 1: Acceleration [G]            12 Basis Point 1: Yaw Moment [lb*ft]
% 13 Basis Point 1: Left Stability [lb*ft/deg]  14 Basis Point 1: Right Stability [lb*ft/deg]
% 15 Basis Point 1: Upper Control [lb*ft/deg]   16 Basis Point 1: Lower Control [lb*ft/deg]
% 17 Basis Point 2: Acceleration [G]            18 Basis Point 2: Yaw Moment [lb*ft]
% 19 Basis Point 2: Left Stability [lb*ft/deg]  20 Basis Point 2: Right Stability [lb*ft/deg]
% 21 Basis Point 2: Upper Control [lb*ft/deg]   22 Basis Point 2: Lower Control [lb*ft/deg]
% 23 Basis Point 3: Acceleration [G]            24 Basis Point 3: Yaw Moment [lb*ft]
% 25 Basis Point 3: Left Stability [lb*ft/deg]  26 Basis Point 3: Right Stability [lb*ft/deg]
% 27 Basis Point 3: Upper Control[lb*ft/deg]    28 Basis Point 3: Lower Control [lb*ft/deg]

%% Load Data Table

% Choose Sheet Number
sheetNo = 18;

opts = detectImportOptions("YMDDataTable.xlsx");
opts.Sheet = sheetNo;

T = readtable("YMDDataTable_40mph.xlsx", opts);
sweptParam = table2array(T(:, 4));

V_mph = table2array(T(9, 2));

%% Switch Table for Swept Parameter

switch(sheetNo)

    case(1)
        dispXLabel = 'Mass [lb]';       
    case(2)
        dispXLabel = 'Front Weight Distribution [%]';
    case(3) 
        dispXLabel = 'Wheelbase [in]';    
    case(4) 
        dispXLabel = 'Front Track Width [in]';   
    case(5) 
        dispXLabel = 'Rear Track Width [in]';
    case(6) 
        dispXLabel = 'CG Height [in]';     
    case(7) 
        dispXLabel = 'Front Roll Center Height [in]';
    case(8) 
        dispXLabel = 'Rear Roll Center Height [in]';
    case(9) 
        dispXLabel = 'Ackermann [%]';
    case(10) 
        dispXLabel = 'Front Toe [deg]';
    case(11) 
        dispXLabel = 'Rear Toe [deg]';
    case(12)
        dispXLabel = 'Tire Spring Rate [lb/in]';
    case(13)
        dispXLabel = 'Front Spring Stiffness [lb/in]';
    case(14)
        dispXLabel = 'Rear Spring Stiffness [lb/in]';
    case(15)
        dispXLabel = 'Front ARB Stiffness [lb/in]';
    case(16)
        dispXLabel = 'Rear ARB Stiffness [lb/in]';
    case(17) 
        dispXLabel = 'Coefficient of Lift';
    case(18) 
        dispXLabel = 'Front Center of Pressure [%]';

end

%% Acceleration @ Grip

leftGrip_Accel = table2array(T(:, 5));
rightGrip_Accel = table2array(T(:, 7));
absAvgGrip_Accel = (abs(leftGrip_Accel) + abs(rightGrip_Accel))/2;

absAvgText = horzcat('Absolute Average @ ', num2str(V_mph), ' mph');

figure(1);
hold on
% plot(sweptParam, abs(leftGrip_Accel), '-*', DisplayName='Acceleration @ Left Grip (-)');
% plot(sweptParam, abs(rightGrip_Accel), '-*', DisplayName='Acceleration @ Right Grip (+)');
plot(sweptParam, absAvgGrip_Accel, '-*', DisplayName=absAvgText);
xlabel(dispXLabel);
ylabel('Accleration [G]');
title('Acceleration @ Grip');
legend('Location', 'southoutside');

%% Yaw Moment @ Grip

leftGrip_YM = table2array(T(:, 6));
rightGrip_YM = table2array(T(:, 8));
absAvgGrip_YM = (abs(leftGrip_YM) + abs(rightGrip_YM))/2;

figure(2);
hold on
% plot(sweptParam, abs(leftGrip_YM), '-*', DisplayName='Yaw Moment @ Left Grip (Absolute)');
% plot(sweptParam, abs(rightGrip_YM), '-*', DisplayName='Yaw Moment @ Right Grip (Absolute)');
plot(sweptParam, absAvgGrip_YM, '-*', DisplayName=absAvgText);
xlabel(dispXLabel);
ylabel('Yaw Moment [lb*ft]');
title('Yaw Moment @ Grip');
legend('Location', 'northwest');

%% Acceleration @ Limit Balance

leftLB = table2array(T(:, 9));
rightLB = table2array(T(:, 10));
absAvgLB = (abs(leftLB) + abs(rightLB))/2;

absAvgText = horzcat('Absolute Average @ ', num2str(V_mph), ' mph');

figure(3);
hold on
% plot(sweptParam, abs(leftLB), '-*', DisplayName='Acceleration @ Left Limit Balance (-)');
% plot(sweptParam, abs(rightLB), '-*', DisplayName='Acceleration @ Right Limit Balance (+)');
plot(sweptParam, absAvgLB, '-*', DisplayName=absAvgText);
xlabel(dispXLabel);
ylabel('Accleration [G]');
title('Acceleration @ Limit Balance');
legend('Location', 'northeast');

%% Acceleration @ Basis Points

basis1_Accel = table2array(T(:, 11));
basis2_Accel = table2array(T(:, 17));
basis3_Accel = table2array(T(:, 23));

basis1_Info = horzcat('β = ', num2str(table2array(T(20, 2))), ' [deg], ', ...
    'δ = ', num2str(table2array(T(21, 2))), ' [deg]');
basis2_Info = horzcat('β = ', num2str(table2array(T(22, 2))), ' [deg], ', ...
    'δ = ', num2str(table2array(T(23, 2))), ' [deg]');
basis3_Info = horzcat('β = ', num2str(table2array(T(24, 2))), ' [deg], ', ...
    'δ = ', num2str(table2array(T(25, 2))), ' [deg]');

% figure;
% AccelBasisFig = tiledlayout(3, 1);
% 
% nexttile,
% plot(sweptParam, basis1_Accel, '-o');
% grid on
% title(basis1_Info);
% 
% nexttile,
% plot(sweptParam, basis2_Accel, '-o');
% grid on
% title(basis2_Info);
% 
% nexttile,
% plot(sweptParam, basis3_Accel, '-o');
% grid on
% title(basis3_Info);
% 
% xlabel(dispXLabel);
% ylabel(AccelBasisFig, 'Acceleration [G]');
% title(AccelBasisFig, 'Acceleration @ Basis Points');

%% Yaw Moment @ Basis Points

basis1_YM = table2array(T(:, 12));
basis2_YM = table2array(T(:, 18));
basis3_YM = table2array(T(:, 24));

% figure;
% YMBasisFig = tiledlayout(3, 1);
% 
% nexttile,
% plot(sweptParam, basis1_YM, '-o', DisplayName='Yaw Moment');
% grid on
% title(basis1_Info);
% 
% nexttile,
% plot(sweptParam, basis2_YM, '-o', DisplayName='Yaw Moment');
% grid on
% title(basis2_Info);
% 
% nexttile,
% plot(sweptParam, basis3_YM, '-o', DisplayName='Yaw Moment');
% grid on
% title(basis3_Info);
% 
% xlabel(YMBasisFig, dispXLabel);
% ylabel(YMBasisFig, 'Yaw Moment [lb*ft]');
% title(YMBasisFig, 'Yaw Moment @ Basis Points');

%% Stability @ Basis Points

basis1_LeftStb = table2array(T(:, 13));
basis1_RightStb = table2array(T(:, 14));
basis2_LeftStb = table2array(T(:, 19));
basis2_RightStb = table2array(T(:, 20));
basis3_LeftStb = table2array(T(:, 25));
basis3_RightStb = table2array(T(:, 26));

figure;
StbFig = tiledlayout(3, 1);

nexttile,
hold on
grid on
plot(sweptParam, basis1_LeftStb, '-o', DisplayName='Left Stability');
plot(sweptParam, basis1_RightStb, '-o', DisplayName='Right Stability');
title(basis1_Info);
legend('Location', 'eastoutside');

nexttile,
hold on
grid on
plot(sweptParam, basis2_LeftStb, '-x', DisplayName='Left Stability');
plot(sweptParam, basis2_RightStb, '-x', DisplayName='Right Stability');
title(basis2_Info);
legend('Location', 'eastoutside');

nexttile,
hold on
grid on
plot(sweptParam, basis3_LeftStb, '-^', DisplayName='Left Stability');
plot(sweptParam, basis3_RightStb, '-^', DisplayName='Right Stability');
title(basis3_Info);
legend('Location', 'eastoutside');

xlabel(StbFig, dispXLabel);
ylabel(StbFig, 'Stability Number [lb*ft/deg]');
title(StbFig, 'Stability @ Basis Points');

%% Control @ Basis Points

basis1_UpperCtrl = table2array(T(:, 15));
basis1_LowerCtrl = table2array(T(:, 16));
basis1_avgCtrl = (basis1_UpperCtrl + basis1_LowerCtrl)/2;
basis2_UpperCtrl = table2array(T(:, 21));
basis2_LowerCtrl = table2array(T(:, 22));
basis2_avgCtrl = (basis2_UpperCtrl + basis2_LowerCtrl)/2;
basis3_UpperCtrl = table2array(T(:, 27));
basis3_LowerCtrl = table2array(T(:, 28));
basis3_avgCtrl = (basis3_UpperCtrl + basis3_LowerCtrl)/2;

figure;
ctrlFig = tiledlayout(3, 1);

nexttile,
hold on
grid on
plot(sweptParam, basis1_UpperCtrl, '-o', DisplayName='Upper Control');
plot(sweptParam, basis1_LowerCtrl, '-o', DisplayName='Lower Control');
title(basis1_Info);
legend('Location', 'eastoutside');

nexttile,
hold on
grid on
plot(sweptParam, basis2_UpperCtrl, '-x', DisplayName='Upper Control');
plot(sweptParam, basis2_LowerCtrl, '-x', DisplayName='Lower Control');
title(basis2_Info);
legend('Location', 'eastoutside');

nexttile,
hold on
grid on
plot(sweptParam, basis3_UpperCtrl, '-^', DisplayName='Upper Control');
plot(sweptParam, basis3_LowerCtrl, '-^', DisplayName='Lower Control');
title(basis3_Info);
legend('Location', 'eastoutside');

xlabel(ctrlFig, dispXLabel);
ylabel(ctrlFig, 'Control Number [lb*ft/deg]');
title(ctrlFig, 'Control @ Basis Points');




