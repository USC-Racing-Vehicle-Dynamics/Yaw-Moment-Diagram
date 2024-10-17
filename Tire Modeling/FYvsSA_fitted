%% Tire Force Analysis: Lateral Force vs. Slip Angle (Fitted Data)

% Compare lateral force vs. slip angle for different tires, with the peak
% lateral force displayed. The lateral force is computed from fitted tire
% models

%% Clear

clear, clc, close all;

%% Unit Conversions

N2lbf = 0.224809;
psi2pa = 6894.76;

%% Setup

% Pressure
IP_psi = 11; % from +8 to +14
IP_pa = IP_psi*psi2pa;

% Inclination angle
IA_deg = 2; % from 0 to +4
IA_rad = deg2rad(IA_deg);

% Normal load
FZ_lbs = 250; % positive is down(-z)
FZ_N = FZ_lbs/N2lbf;

% Slip angle
SA_deg = -18: 0.5: 18;
SA_rad = deg2rad(SA_deg);

% UI Table
rowCount = 1;

%% Vector Spaces

% Lateral force, FY [lbf]
FY_R20 = zeros(length(SA_rad), 1);
FY_LCO = zeros(length(SA_rad), 1);
FY_R25B = zeros(length(SA_rad), 1);
FY_R20n = zeros(length(SA_rad), 1);

FYSA_R20 = zeros(2, length(SA_rad));
FYSA_LCO = zeros(2, length(SA_rad));
FYSA_R25B = zeros(2, length(SA_rad));
FYSA_R20n = zeros(2, length(SA_rad));

%% 1st Tire Model: Hoosier 43075 R20 16"x7.5"

tire1 = load("Fitted Data/43075_R20_16x7.5_FY0.mat");

for i = 1: length(SA_rad)

    [FX1, FY1] = magicformula(tire1.mfparams, 0, SA_rad(i), FZ_N, IP_pa, IA_rad);
    FY_R20(i) = -FY1*N2lbf;
    FYSA_R20(1, i) = FY_R20(i);
    FYSA_R20(2, i) = SA_deg(i);

end

plot(SA_deg, FY_R20, 'b', LineWidth=2, DisplayName='R20 16"x7.5"');
hold on;

[FYmax_R20, index_R20] = max(FYSA_R20(1, :));

tableRow{rowCount, 1} = 'R20 16"x7.5"';
tableRow{rowCount, 2} = IP_psi;
tableRow{rowCount, 3} = FZ_lbs;
tableRow{rowCount, 4} = IA_deg;
tableRow{rowCount, 5} = FYmax_R20;
tableRow{rowCount, 6} = FYSA_R20(2, index_R20);
rowCount = rowCount + 1;

%% 2nd Tire Model: Hoosier 43075 LCO 16"x7.5"

tire2 = load("Fitted Data/43075_LCO_16x7.5_FY0.mat");

for i = 1: length(SA_rad)

    [FX2, FY2] = magicformula(tire2.mfparams, 0, SA_rad(i), FZ_N, IP_pa, IA_rad);
    FY_LCO(i) = -FY2*N2lbf;
    FYSA_LCO(1, i) = FY_LCO(i);
    FYSA_LCO(2, i) = SA_deg(i);

end

plot(SA_deg, FY_LCO, 'r', LineWidth=2, DisplayName='LCO 16"x7.5"');
hold on;

[FYmax_LCO, index_LCO] = max(FYSA_LCO(1, :));

tableRow{rowCount, 1} = 'LCO 16"x7.5"';
tableRow{rowCount, 2} = IP_psi;
tableRow{rowCount, 3} = FZ_lbs;
tableRow{rowCount, 4} = IA_deg;
tableRow{rowCount, 5} = FYmax_LCO;
tableRow{rowCount, 6} = FYSA_LCO(2, index_LCO);
rowCount = rowCount + 1;

%% 3rd Tire Model: Hoosier 43075 R25B 16"x7.5"

tire3 = load("Fitted Data/43075_R25B_16x7.5_FY0.mat");

for i = 1: length(SA_rad)

    [FX3, FY3] = magicformula(tire3.mfparams, 0, SA_rad(i), FZ_N, IP_pa, IA_rad);
    FY_R25B(i) = -FY3*N2lbf;
    FYSA_R25B(1, i) = FY_R25B(i);
    FYSA_R25B(2, i) = SA_deg(i);

end

plot(SA_deg, FY_R25B, Color='#00CC00', LineWidth=2, DisplayName='R25B 16"x7.5"');
hold on;

[FYmax_R25B, index_R25B] = max(FYSA_R25B(1, :));

tableRow{rowCount, 1} = 'R25B 16"x7.5"';
tableRow{rowCount, 2} = IP_psi;
tableRow{rowCount, 3} = FZ_lbs;
tableRow{rowCount, 4} = IA_deg;
tableRow{rowCount, 5} = FYmax_R25B;
tableRow{rowCount, 6} = FYSA_R25B(2, index_R25B);
rowCount = rowCount + 1;

%% 4th tire model: Hoosier 43075 R20 16"x6"

tire4 = load("Fitted Data/43070_R20_16x6_FY0.mat");

for i = 1: length(SA_rad)

    [FX4, FY4] = magicformula(tire4.mfparams, 0, SA_rad(i), FZ_N, IP_pa, IA_rad);
    FY_R20n(i) = -FY4*N2lbf;
    FYSA_R20n(1, i) = FY_R20n(i);
    FYSA_R20n(2, i) = SA_deg(i);

end

plot(SA_deg, FY_R20n, Color='#00AAFF', LineWidth=2, DisplayName='R20 16"x6"');
hold on;

[FYmax_R20n, index_R20n] = max(FYSA_R20n(1, :));

tableRow{rowCount, 1} = 'R20 16"x6"';
tableRow{rowCount, 2} = IP_psi;
tableRow{rowCount, 3} = FZ_lbs;
tableRow{rowCount, 4} = IA_deg;
tableRow{rowCount, 5} = FYmax_R20n;
tableRow{rowCount, 6} = FYSA_R20n(2, index_R20n);
rowCount = rowCount + 1;

%% Plot Setup

grid;
hold off;
xlabel('Slip Angle [deg]');
ylabel('Lateral Force, FY [lb]');
title('Lateral Tire Forces vs. Slip Angle', ...
    sprintf(['IP = %d psi, IA = %d' char(176) ', FZ = %d lbf'], ...
    IP_psi, IA_deg, FZ_lbs));
legend('Location', 'southeast');

%% UI Table

figure(2);
t = uitable("Data", tableRow, 'Position', [10, 10, 660, 400], 'ColumnWidth', {75, 100, 100, 100, 125, 125});
t.ColumnName = {'Tire', 'Pressure [psi]', 'Normal Load [lb]',...
    'Camber [deg]', 'Peak Lateral Force [lb]','Slip Angle [deg]'};
