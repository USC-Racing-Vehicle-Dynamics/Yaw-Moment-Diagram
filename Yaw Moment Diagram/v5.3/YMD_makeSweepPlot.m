%% Function: Make Sweep YMD Plot

% Make multiple plots based on one selected varying parameter,
% other parameters stays constant

function sweptParamIndex = YMD_makeSweepPlot(progress)

%% Program Setup

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

%% Sweep Setup

% Obtain swept parameter space
sweepField.field1 = evalin('base', 'sweepField.field1');
sweepField.field2 = evalin('base', 'sweepField.field2');
sweepField.field3 = evalin('base', 'sweepField.field3');
sweptParamMin = get(sweepField.field1, 'value');
sweptParamMax = get(sweepField.field2, 'value');
sweptNoPts = get(sweepField.field3, 'value');
sweptParamSpace = linspace(sweptParamMin, sweptParamMax, sweptNoPts);

% Fill swept parameter space into the dropdown list
sweptParamList = evalin("base", 'sweptParamList');
sweptParamList.Items = string(sweptParamSpace);

% Set up number of sweep plots
YMDSweepPlots = cell(1, length(sweptParamSpace));

% Switch sweep status
sweepButton = evalin("base", 'sweepButton');
if guidata(sweepButton) == 1

    sweptParamSpace = evalin('base', 'sweptParamSpace');
    guidata(sweepButton, 0);

end

% Find parameter to be swept
sweptParam = evalin('base', 'sweptParam');

% Show parameter to sweep
sweepInfoLbl2 = evalin("base", 'sweepInfoLbl2');
switch sweptParam.ValueIndex

    case 1
        sweepInfoLbl2.Text = 'Mass';

    case 2
        sweepInfoLbl2.Text = 'Front Weight Distribution';

    case 3
        sweepInfoLbl2.Text = 'Wheelbase';

    case 4
        sweepInfoLbl2.Text = 'Front Track Width';

    case 5
        sweepInfoLbl2.Text = 'Rear Track Width';

    case 6
        sweepInfoLbl2.Text = 'CG Height';

    case 7
        sweepInfoLbl2.Text = 'Front Roll Center Height';

    case 8
        sweepInfoLbl2.Text = 'Rear Roll Center Height';

    case 9
        sweepInfoLbl2.Text = 'Ackermann';

    case 10
        sweepInfoLbl2.Text = 'Front Toe';

    case 11
        sweepInfoLbl2.Text = 'Rear Toe';

    case 12
        sweepInfoLbl2.Text = 'Tire Spring Rate';

    case 13
        sweepInfoLbl2.Text = 'Front Spring Stiffness';

    case 14
        sweepInfoLbl2.Text = 'Rear Spring Stiffness';

    case 15
        sweepInfoLbl2.Text = 'Front ARB Stiffness';

    case 16
        sweepInfoLbl2.Text = 'Rear ARB Stiffness';

    case 17
        sweepInfoLbl2.Text = 'Coefficient of Lift';

    case 18
        sweepInfoLbl2.Text = 'Center of Pressure';

    case 19
        sweepInfoLbl2.Text = 'Velocity [mph]';

end

YMDSweep = evalin('base', 'YMDSweep');


%% Loop to Plot

for sweptParamIndex = 1: length(sweptParamSpace)

    progress.Message = strcat("Plotting Figure ", string(sweptParamIndex), " of ", string(length(sweptParamSpace)), "...");
    progress.Value = sweptParamIndex/length(sweptParamSpace);

    YMD_makeSinglePlotforSweep(param, sweptParam, sweptParamSpace, sweptParamIndex, YMDSweepPlots, YMDSweep);
    
end

progress.Message = 'Finishing Up...';

%% Plot Adjustments

grid(YMDSweep, 'on');
xlabel(YMDSweep, 'x');
xlim(YMDSweep, [-2.5, 2.5]);
ylim(YMDSweep, [-4000, 4000]);
xlabel(YMDSweep, 'Lateral Acceleration [G]');
ylabel(YMDSweep, 'Yaw Moment [lb*ft]');
title(YMDSweep, 'Yaw Moment Diagram');
hold(YMDSweep, 'off');

%cellArray = cell(1922, 1);
%cellArray{:} = deal('k');
%[YMDSweepPlots{1}.Color] = deal('k');

[YMDSweepPlots{1}(:, 1).Color] = deal('b');
[YMDSweepPlots{1}(:, 2).Color] = deal('r');
uistack(YMDSweepPlots{1}(:, 1), 'top');
uistack(YMDSweepPlots{1}(:, 2), 'top');

for i = 2: length(sweptParamSpace)

    [YMDSweepPlots{i}.Color] = deal([0.8 0.8 0.8 0.05]);

end

% Switch to Sweep Plot tab
tabGroup = evalin("base", 'tabGroup');
tab = evalin("base", 'tab');
tabGroup.SelectedTab = tab.sweepPlot;

%% Upload Plot Info

assignin('base', 'YMDSweepPlots', YMDSweepPlots);
assignin('base', 'sweptParamSpace', sweptParamSpace);
assignin('base', 'sweptParamList', sweptParamList);

% End of function

end