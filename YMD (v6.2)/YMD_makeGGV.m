%% Function: Make GGV Diagram

% Make GGV plots based on varying velocity,
% other parameters stays constant

function sweptVIndex = YMD_makeGGV(progress)

%% Parameter Setup

% Import parameters
param = evalin('base', 'param');

% Convert units for script calculation
param.fwd = param.fwd/100;              % [%] to none
param.l = param.l/12;                   % [in] to [ft]
param.t_F = param.t_F/12;               % [in] to [ft]
param.t_R = param.t_R/12;               % [in] to [ft]
param.h = param.h/12;                   % [in] to [ft]
param.z_RF = param.z_RF/12;             % [in] to [ft]
param.z_RR = param.z_RR/12;             % [in] to [ft]
param.ackermann = param.ackermann/100;  % [%] to none
param.toe_f = deg2rad(param.toe_f);     % [deg] to [rad]
param.toe_r = deg2rad(param.toe_r);     % [deg] to [rad]
param.tire_k = param.tire_k*12;         % [lb/in] to [lb/ft]
param.f_spring_k = param.f_spring_k*12; % [lb/in] to [lb/ft]
param.r_spring_k = param.r_spring_k*12; % [lb/in] to [lb/ft]
param.f_arb_k = param.f_arb_k*12;       % [lb/in] to [lb/ft]
param.r_arb_k = param.r_arb_k*12;       % [lb/in] to [lb/ft]
param.CoP = param.CoP/100;              % [%] to none

%% Visual Setup

GGVAxes = evalin('base', 'GGVAxes');

% Clear axes
cla(GGVAxes);

% Obtain swept parameter space
VField = evalin('base', 'VField');
V.lowerLimit = VField.field1.Value;
V.upperLimit = VField.field2.Value;
V.dataPts = VField.field3.Value;
V.range = linspace(V.lowerLimit, V.upperLimit, V.dataPts);

% Set up number of sweep plots
GGVPlots = cell(length(V.range), 3);
assignin('base', 'GGVPlots', GGVPlots);

%% Loop to Plot

AxData_GGV = [];
AyData_GGV = [];
VData_GGV = [];

for sweptVIndex = 1: length(V.range)

    progress.Message = strcat("Plotting Figure ", string(sweptVIndex), " of ", string(length(V.range)), "...");
    progress.Value = (sweptVIndex - 1)/length(V.range);

    [AxData, AyData] = YMD_makeGGV_singlePlot(param, V, sweptVIndex);

    AxData_GGV(:, :, sweptVIndex) = AxData;
    AyData_GGV(:, :, sweptVIndex) = AyData;
    
end

% Export data
assignin('base', 'AxData_GGV', AxData_GGV);
assignin('base', 'AyData_GGV', AyData_GGV);

% Update progress
progress.Value = 1;
progress.Message = 'Finishing Up...';

%% Plot Adjustments

grid(GGVAxes, 'on');
xlabel(GGVAxes, 'Lateral Acceleration [G]');
ylabel(GGVAxes, 'Longitudinal Acceleration [G]');
zlabel(GGVAxes, 'Velocity [mph]')
title(GGVAxes, 'GGV Diagram');
hold(GGVAxes, 'off');

% Switch to Sweep Plot tab
tabs = evalin("base", 'tabs');
tabGroup = evalin("base", 'tabGroup');
tabGroup.SelectedTab = tabs.GGV;

%% Upload Plot Info

assignin('base', 'GGVPlots', GGVPlots);
assignin('base', 'V', V);

end