%% Function: Make Sweep YMD Plot

% Make multiple YMD plots based on one selected varying parameter,
% other parameters stays constant

function sweptParamIndex = YMD_sweepYMD(progress)

%% Parameter Setup

% Import parameters
param = evalin('base', 'param');

% Convert units for script calculation
param.fwd = param.fwd/100;              % [%] to [-]
param.l = param.l/12;                   % [in] to [ft]
param.t_F = param.t_F/12;               % [in] to [ft]
param.t_R = param.t_R/12;               % [in] to [ft]
param.h = param.h/12;                   % [in] to [ft]
param.z_RF = param.z_RF/12;             % [in] to [ft]
param.z_RR = param.z_RR/12;             % [in] to [ft]
param.ackermann = param.ackermann/100;  % [%] to [-]
param.toe_f = deg2rad(param.toe_f);     % [deg] to [rad]
param.toe_r = deg2rad(param.toe_r);     % [deg] to [rad]
param.tire_k = param.tire_k*12;         % [lb/in] to [lb/ft]
param.f_spring_k = param.f_spring_k*12; % [lb/in] to [lb/ft]
param.r_spring_k = param.r_spring_k*12; % [lb/in] to [lb/ft]
param.f_arb_k = param.f_arb_k*12;       % [lb/in] to [lb/ft]
param.r_arb_k = param.r_arb_k*12;       % [lb/in] to [lb/ft]
param.CoP = param.CoP/100;              % [%] to [-]

%% Visual Setup

YMDSweepAxes = evalin('base', 'YMDSweepAxes');

% Clear axes
cla(YMDSweepAxes);

% Obtain swept parameter space
sweepField = evalin('base', 'sweepField');
sweep.lowerLimit = sweepField.field1.Value;
sweep.upperLimit = sweepField.field2.Value;
sweep.dataPts = sweepField.field3.Value;
sweep.range = linspace(sweep.lowerLimit, sweep.upperLimit, sweep.dataPts);

% Fill swept parameter space into the dropdown list
sweptParamList = evalin("base", 'sweptParamList');
sweptParamList.Items = string(sweep.range);

% Set up number of sweep plots
YMDSweepPlots = cell(length(sweep.range), 3);
assignin('base', 'YMDSweepPlots', YMDSweepPlots);

% Find parameter to be swept
sweptParam = evalin('base', 'sweptParam');

% Show parameter to sweep
sweepInfoLbl = evalin("base", 'sweepInfoLbl2');
switch sweptParam.ValueIndex

    case 1
        sweepInfoLbl.Text = 'Mass';

    case 2
        sweepInfoLbl.Text = 'Front Weight Distribution';

    case 3
        sweepInfoLbl.Text = 'Wheelbase';

    case 4
        sweepInfoLbl.Text = 'Front Track Width';

    case 5
        sweepInfoLbl.Text = 'Rear Track Width';

    case 6
        sweepInfoLbl.Text = 'CG Height';

    case 7
        sweepInfoLbl.Text = 'Front Roll Center Height';

    case 8
        sweepInfoLbl.Text = 'Rear Roll Center Height';

    case 9
        sweepInfoLbl.Text = 'Ackermann';

    case 10
        sweepInfoLbl.Text = 'Front Toe';

    case 11
        sweepInfoLbl.Text = 'Rear Toe';

    case 12
        sweepInfoLbl.Text = 'Tire Spring Rate';

    case 13
        sweepInfoLbl.Text = 'Front Spring Stiffness';

    case 14
        sweepInfoLbl.Text = 'Rear Spring Stiffness';

    case 15
        sweepInfoLbl.Text = 'Front ARB Stiffness';

    case 16
        sweepInfoLbl.Text = 'Rear ARB Stiffness';

    case 17
        sweepInfoLbl.Text = 'Coefficient of Lift';

    case 18
        sweepInfoLbl.Text = 'Center of Pressure';

    case 19
        sweepInfoLbl.Text = 'Velocity [mph]';

end

% 
sweptParamInfo.name = sweepInfoLbl.Text;
sweptParamInfo.value = sweep.range;

%% Loop to Plot

AxSweepData = [];
AySweepData = [];
MSweepData = [];
for sweptParamIndex = 1: length(sweep.range)

    progress.Message = strcat("Plotting Figure ", string(sweptParamIndex), " of ", string(length(sweep.range)), "...");
    progress.Value = (sweptParamIndex - 1)/length(sweep.range);

    [AxData, AyData, MData] = YMD_sweepYMD_singlePlot(param, sweptParam, sweep, sweptParamIndex);
    
    AxSweepData(:, :, :, sweptParamIndex) = AxData;
    AySweepData(:, :, :, sweptParamIndex) = AyData;
    MSweepData(:, :, :, sweptParamIndex) = MData;

end

% Export Data
assignin('base', 'sweptParamInfo', sweptParamInfo);
assignin('base', 'AxSweepData', AxSweepData);
assignin('base', 'AySweepData', AySweepData);
assignin('base', 'MSweepData', MSweepData);

% Update progress
progress.Value = 1;
progress.Message = 'Finishing Up...';

%% Plot Adjustments

grid(YMDSweepAxes, 'on');
xlabel(YMDSweepAxes, 'Lateral Acceleration [G]');
ylabel(YMDSweepAxes, 'Yaw Moment [lb*ft]');
zlabel(YMDSweepAxes, 'Longitudinal Acceleration [G]')
title(YMDSweepAxes, 'Yaw Moment Diagram');
hold(YMDSweepAxes, 'off');

% Highlight the plot with first value of swept parameter
YMDSweepPlots = evalin('base', 'YMDSweepPlots');
set(YMDSweepPlots{1, 1}, 'color', 'r');
set(YMDSweepPlots{1, 2}, 'color', 'b');
set(YMDSweepPlots{1, 3}, 'color', 'k');
uistack(YMDSweepPlots{1, 1}, 'top');
uistack(YMDSweepPlots{1, 2}, 'top');
uistack(YMDSweepPlots{1, 3}, 'top');
if length(sweep.range) >= 2

    for i = 2: length(sweep.range)
    
        set(YMDSweepPlots{i, 1}, 'color', [0.8 0.8 0.8 0.05]);
        set(YMDSweepPlots{i, 2}, 'color', [0.8 0.8 0.8 0.05]);
        set(YMDSweepPlots{i, 3}, 'color', [0.8 0.8 0.8 0.05]);
    
    end

end

% Switch to Sweep Plot tab
tabs = evalin("base", 'tabs');
tabGroup = evalin("base", 'tabGroup');
tabGroup.SelectedTab = tabs.YMDSweep;

%% Upload Plot Info

assignin('base', 'YMDSweepPlots', YMDSweepPlots);
assignin('base', 'sweep', sweep);
assignin('base', 'sweptParamList', sweptParamList);

end