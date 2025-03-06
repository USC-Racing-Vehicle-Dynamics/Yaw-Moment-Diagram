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

for sweptVIndex = 1: length(V.range)

    progress.Message = strcat("Plotting Figure ", string(sweptVIndex), " of ", string(length(V.range)), "...");
    progress.Value = (sweptVIndex - 1)/length(V.range);

    YMD_makeSinglePlot4GGV(param, V, sweptVIndex);
    
end

progress.Value = 1;
progress.Message = 'Finishing Up...';

%% Plot Adjustments

grid(GGVAxes, 'on');
xlabel(GGVAxes, 'Lateral Acceleration [G]');
ylabel(GGVAxes, 'Longitudinal Acceleration [G]');
zlabel(GGVAxes, 'Velocity [mph]')
title(GGVAxes, 'GGV Diagram');
hold(GGVAxes, 'off');

% % Highlight the plot with first value of swept parameter
% GGVPlots = evalin('base', 'GGVPlots');
% set(GGVPlots{1, 1}, 'color', 'r');
% set(GGVPlots{1, 2}, 'color', 'b');
% set(GGVPlots{1, 3}, 'color', 'k');
% uistack(GGVPlots{1, 1}, 'top');
% uistack(GGVPlots{1, 2}, 'top');
% uistack(GGVPlots{1, 3}, 'top');
% if length(V.range) >= 2
% 
%     for i = 2: length(V.range)
% 
%         set(GGVPlots{i, 1}, 'color', [0.8 0.8 0.8 0.05]);
%         set(GGVPlots{i, 2}, 'color', [0.8 0.8 0.8 0.05]);
%         set(GGVPlots{i, 3}, 'color', [0.8 0.8 0.8 0.05]);
% 
%     end
% 
% end

% Switch to Sweep Plot tab
tab = evalin("base", 'tab');
tabGroup = evalin("base", 'tabGroup');
tabGroup.SelectedTab = tab.GGV;

%% Upload Plot Info

assignin('base', 'GGVPlots', GGVPlots);
assignin('base', 'V', V);
%assignin('base', 'sweptParamList', sweptParamList);

% End of function

end