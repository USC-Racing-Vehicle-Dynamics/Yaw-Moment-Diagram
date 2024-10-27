%% Yaw Moment Diagram (v5.3)

%% Clear

clear, clc, close all;

%% Initialization

isInit = YMD_initialize;

%% UI Panel Overview

fig = uifigure('Position', [300 300 850 700]);

% Tabs
tabGroup = uitabgroup(fig, 'Position', [0 0 850 700]);
tab.data = uitab(tabGroup, 'Title', 'Data');
tab.singlePlot = uitab(tabGroup, 'Title', 'Single Plot');
tab.sweepPlot = uitab(tabGroup, 'Title', 'Sweep Plot');

%% Data Tab: Headings

heading.param = uilabel(tab.data, 'Position', [50 625 75 22]);
heading.param.Text = '\fontname{Arial}\bfParameter';
heading.param.Interpreter = 'tex';

heading.val = uilabel(tab.data, 'Position', [200 625 75 22]);
heading.val.Text = '\fontname{Arial}\bfValue';
heading.val.Interpreter = 'tex';

heading.unit = uilabel(tab.data, 'Position', [300 625 50 22]);
heading.unit.Text = '\fontname{Arial}\bfUnit';
heading.unit.Interpreter = 'tex';

heading.plot = uilabel(tab.data, 'Position', [400 625 100 22]);
heading.plot.Text = '\fontname{Arial}\bfSingle Plot';
heading.plot.Interpreter = 'tex';

heading.sweep = uilabel(tab.data, 'Position', [400 550 100 22]);
heading.sweep.Text = '\fontname{Arial}\bfSweep Plot';
heading.sweep.Interpreter = 'tex';

%% Data Tab: Vehicle Parameters

% (1) Mass
paramField.W = uieditfield(tab.data, 'numeric', 'Position', [200 600 50 22]);
paramField.W.Value = param.W;
paramField.W.Limits = [0.1 inf];

paramLbl.W = uilabel(tab.data, 'Position', [50 600 50 22]);
paramLbl.W.Text = 'Mass';

paramUnit.W = uidropdown(tab.data, 'Position', [300 600 50 22]);
paramUnit.W.Items = {'lb'};

% (2) Front weight distribution
paramField.fwd = uieditfield(tab.data, 'numeric', 'Position', [200 575 50 22]);
paramField.fwd.Value = param.fwd;
paramField.fwd.Limits = [0 100];
paramField.fwd.ValueDisplayFormat = "%d%%";

paramLbl.fwd = uilabel(tab.data, 'Position', [50 575 150 22]);
paramLbl.fwd.Text = 'Front Weight Distribution';

% (3) Wheelbase
paramField.l = uieditfield(tab.data, 'numeric', 'Position', [200 550 50 22]);
paramField.l.Value = param.l;
paramField.l.Limits = [0.1 Inf];
paramField.l.ValueDisplayFormat = "%.1f";

paramLbl.l = uilabel(tab.data, 'Position', [50 550 150 22]);
paramLbl.l.Text = 'Wheelbase';

paramUnit.l = uidropdown(tab.data, 'Position', [300 550 50 22]);
paramUnit.l.Items = {'in'};

% (4) Front track width
paramField.t_F = uieditfield(tab.data, 'numeric', 'Position', [200 525 50 22]);
paramField.t_F.Value = param.t_F;
paramField.t_F.Limits = [0.1 Inf];
paramField.t_F.ValueDisplayFormat = "%.1f";

paramLbl.t_F = uilabel(tab.data, 'Position', [50 525 150 22]);
paramLbl.t_F.Text = 'Front Track Width';

paramUnit.t_F = uidropdown(tab.data, 'Position', [300 525 50 22]);
paramUnit.t_F.Items = {'in'};

% (5) Rear track width
paramField.t_R = uieditfield(tab.data, 'numeric', 'Position', [200 500 50 22]);
paramField.t_R.Value = param.t_R;
paramField.t_R.Limits = [0.1 Inf];
paramField.t_R.ValueDisplayFormat = "%.1f";

paramLbl.t_R = uilabel(tab.data, 'Position', [50 500 150 22]);
paramLbl.t_R.Text = 'Rear Track Width';

paramUnit.t_R = uidropdown(tab.data, 'Position', [300 500 50 22]);
paramUnit.t_R.Items = {'in'};

% (6) CG Height
paramField.h = uieditfield(tab.data, 'numeric', 'Position', [200 475 50 22]);
paramField.h.Value = param.h;
paramField.h.Limits = [0 Inf];
paramField.h.ValueDisplayFormat = "%.2f";

paramLbl.h = uilabel(tab.data, 'Position', [50 475 150 22]);
paramLbl.h.Text = 'CG Height';

paramUnit.h = uidropdown(tab.data, 'Position', [300 475 50 22]);
paramUnit.h.Items = {'in'};

% (7) Front roll center height
paramField.z_RF = uieditfield(tab.data, 'numeric', 'Position', [200 450 50 22]);
paramField.z_RF.Value = param.z_RF;
paramField.z_RF.Limits = [0 Inf];
paramField.z_RF.ValueDisplayFormat = "%.2f";

paramLbl.z_RF = uilabel(tab.data, 'Position', [50 450 150 22]);
paramLbl.z_RF.Text = 'Front Roll Center Height';

paramUnit.z_RF = uidropdown(tab.data, 'Position', [300 450 50 22]);
paramUnit.z_RF.Items = {'in'};

% (8) Rear roll center height
paramField.z_RR = uieditfield(tab.data, 'numeric', 'Position', [200 425 50 22]);
paramField.z_RR.Value = param.z_RR;
paramField.z_RR.Limits = [0 Inf];
paramField.z_RR.ValueDisplayFormat = "%.2f";

paramLbl.z_RR = uilabel(tab.data, 'Position', [50 425 150 22]);
paramLbl.z_RR.Text = 'Rear Roll Center Height';

paramUnit.z_RR = uidropdown(tab.data, 'Position', [300 425 50 22]);
paramUnit.z_RR.Items = {'in'};

% (9) Ackermann
paramField.ackermann = uieditfield(tab.data, 'numeric', 'Position', [200 400 50 22]);
paramField.ackermann.Value = param.ackermann;
paramField.ackermann.ValueDisplayFormat = "%d%%";

paramLbl.ackermann = uilabel(tab.data, 'Position', [50 400 150 22]);
paramLbl.ackermann.Text = 'Ackermann';

% (10) Front toe
paramField.toe_f = uieditfield(tab.data, 'numeric', 'Position', [200 375 50 22]);
paramField.toe_f.Value = param.toe_f;
paramField.toe_f.ValueDisplayFormat = "%.1f°";

paramLbl.toe_f = uilabel(tab.data, 'Position', [50 375 150 22]);
paramLbl.toe_f.Text = 'Front Toe';

% (11) Rear toe
paramField.toe_r = uieditfield(tab.data, 'numeric', 'Position', [200 350 50 22]);
paramField.toe_r.Value = param.toe_r;
paramField.toe_r.ValueDisplayFormat = "%.1f°";

paramLbl.toe_r = uilabel(tab.data, 'Position', [50 350 150 22]);
paramLbl.toe_r.Text = 'Rear Toe';

% (12) Tire spring rate
paramField.tire_k = uieditfield(tab.data, 'numeric', 'Position', [200 325 50 22]);
paramField.tire_k.Value = param.tire_k;
paramField.tire_k.Limits = [0 Inf];

paramLbl.tire_k = uilabel(tab.data, 'Position', [50 325 150 22]);
paramLbl.tire_k.Text = 'Tire Spring Rate';

paramUnit.tire_k = uidropdown(tab.data, 'Position', [300 325 60 22]);
paramUnit.tire_k.Items = {'lb/in'};

% (13) Front spring stiffness
paramField.f_spring_k = uieditfield(tab.data, 'numeric', 'Position', [200 300 50 22]);
paramField.f_spring_k.Value = param.f_spring_k;
paramField.f_spring_k.Limits = [0 Inf];

paramLbl.f_spring_k = uilabel(tab.data, 'Position', [50 300 150 22]);
paramLbl.f_spring_k.Text = 'Front Spring Stiffness';

paramUnit.f_spring_k = uidropdown(tab.data, 'Position', [300 300 60 22]);
paramUnit.f_spring_k.Items = {'lb/in'};

% (14) Rear spring stiffness
paramField.r_spring_k = uieditfield(tab.data, 'numeric', 'Position', [200 275 50 22]);
paramField.r_spring_k.Value = param.r_spring_k;
paramField.r_spring_k.Limits = [0 Inf];

paramLbl.r_spring_k = uilabel(tab.data, 'Position', [50 275 150 22]);
paramLbl.r_spring_k.Text = 'Rear Spring Stiffness';

paramUnit.r_spring_k = uidropdown(tab.data, 'Position', [300 275 60 22]);
paramUnit.r_spring_k.Items = {'lb/in'};

% (15) Front ARB stiffness
paramField.f_arb_k = uieditfield(tab.data, 'numeric', 'Position', [200 250 50 22]);
paramField.f_arb_k.Value = param.f_arb_k;
paramField.f_arb_k.Limits = [0 Inf];

paramLbl.f_arb_k = uilabel(tab.data, 'Position', [50 250 150 22]);
paramLbl.f_arb_k.Text = 'Front ARB Stiffness';

paramUnit.f_arb_k = uidropdown(tab.data, 'Position', [300 250 60 22]);
paramUnit.f_arb_k.Items = {'lb/in'};

% (16) Rear ARB stiffness
paramField.r_arb_k = uieditfield(tab.data, 'numeric', 'Position', [200 225 50 22]);
paramField.r_arb_k.Value = param.r_arb_k;
paramField.r_arb_k.Limits = [0 Inf];

paramLbl.r_arb_k = uilabel(tab.data, 'Position', [50 225 150 22]);
paramLbl.r_arb_k.Text = 'Rear ARB Stiffness';

paramUnit.r_arb_k = uidropdown(tab.data, 'Position', [300 225 60 22]);
paramUnit.r_arb_k.Items = {'lb/in'};

% (17) Coefficient of lift
paramField.C_L = uieditfield(tab.data, 'numeric', 'Position', [200 200 50 22]);
paramField.C_L.Value = param.C_L;
paramField.C_L.Limits = [0 Inf];

paramLbl.C_L = uilabel(tab.data, 'Position', [50 200 150 22]);
paramLbl.C_L.Text = 'Coefficient of Lift';

% (18) Center of Pressure
paramField.CoP = uieditfield(tab.data, 'numeric', 'Position', [200 175 50 22]);
paramField.CoP.Value = param.CoP;
paramField.CoP.Limits = [0 100];
paramField.CoP.ValueDisplayFormat = "%d%%";

paramLbl.CoP = uilabel(tab.data, 'Position', [50 175 150 22]);
paramLbl.CoP.Text = 'Center of Pressure';

% (19) Velocity
paramField.V = uieditfield(tab.data, 'numeric', 'Position', [200 150 50 22]);
paramField.V.Value = param.V.mph;

paramLbl.V = uilabel(tab.data, 'Position', [50 150 150 22]);
paramLbl.V.Text = 'Velocity';

paramUnit.V = uidropdown(tab.data, 'Position', [300 150 60 22]);
paramUnit.V.Items = {'mph', 'kph', 'ft/s'};

%% Data Tab: Make Single Plot

%------------------------------*
% Push Button: Plot Parameters |
%------------------------------*
plotButton = uibutton(tab.data, 'Position', [400 590 185 22]);
plotButton.Text = 'Plot with Current Numbers';
plotButton.ButtonPushedFcn = @(src, event) YMD_progress(1);

%% Data Tab: Make Sweep Plot

%---------------------------------*
% Dropdown: Parameter to be Swept |
%---------------------------------*
sweptParamLbl = uilabel(tab.data, 'Position', [400 515 150 22]);
sweptParamLbl.Text = 'Parameter to Sweep';

sweptParam = uidropdown(tab.data, 'Position', [535 515 215 22]);
sweptParam.Items = ["Mass", "Front Weight Distribution", "Wheelbase",...
    "Front Track Width", "Rear Track Width", "CG Height",...
    "Front Roll Center Height", "Rear Roll Center Height",...
    "Ackermann", "Front Toe", "Rear Toe", "Tire Spring Rate",...
    "Front Spring Stiffness", "Rear Spring Stiffness",...
    "Front ARB Stiffness", "Rear ARB Stiffness",...
    "Coefficient of Lift", "Center of Pressure", 'Velocity [mph]'];
sweptParam.ItemsData = 1: 19;

%----------------------------------------*
% Numeric Edit Field: Sweep Value Inputs |
%----------------------------------------*
sweepLbl.lbl1 = uilabel(tab.data, 'Position', [400 480 50 22]);
sweepLbl.lbl1.Text = 'From';

sweepField.field1 = uieditfield(tab.data, 'numeric', 'Position', [435 480 50 22]);

sweepLbl.lbl2 = uilabel(tab.data, 'Position', [500 480 50 22]);
sweepLbl.lbl2.Text = 'To';

sweepField.field2 = uieditfield(tab.data, 'numeric', 'Position', [535 480 50 22]);

sweepLbl.lbl3 = uilabel(tab.data, 'Position', [600 480 100 22]);
sweepLbl.lbl3.Text = 'Number of Plots';

sweepField.field3 = uieditfield(tab.data, 'numeric', 'Position', [700 480 50 22]);

%--------------------*
% Push Button: Sweep |
%--------------------*
sweepButton = uibutton(tab.data, 'Position', [400 445 185 22]);
sweepButton.Text = 'Sweep Over Τhis Parameter';
sweepButton.ButtonPushedFcn = @(src, event) YMD_progress(2);

%% Single Plot Tab: Adjust Plot Ranges

%------------------------------*
% Range Slider: Slip Angle (β) |
%------------------------------*
rangeSlider.beta = uislider(tab.singlePlot, 'range', 'step', 1);
rangeSlider.beta.Position = [100 125 400 3];
rangeSlider.beta.Limits = rad2deg([Beta.lowerLimit Beta.upperLimit]);
rangeSlider.beta.Value = rad2deg([Beta.lowerLimit Beta.upperLimit]);
rangeSlider.beta.MajorTicks = rad2deg(Beta.lowerLimit): 5: rad2deg(Beta.upperLimit);
rangeSlider.beta.MinorTicks = rad2deg(Beta.lowerLimit): 1: rad2deg(Beta.upperLimit);
rangeSlider.beta.Tooltip = 'Slip Angle';
rangeSlider.beta.ValueChangedFcn = @(src, event) YMD_progress(3);

rangeSlider.betaLbl = uilabel(tab.singlePlot, 'Position', [100 135 200 22]);
rangeSlider.betaLbl.Text = 'Slip Angle, β [deg]';

%----------------------------------*
% Range Slider: Steering Angle (δ) |
%----------------------------------*
rangeSlider.delta = uislider(tab.singlePlot, 'range', 'step', 1);
rangeSlider.delta.Position = [100 50 400 3];
rangeSlider.delta.Limits = rad2deg([Delta.lowerLimit Delta.upperLimit]);
rangeSlider.delta.Value = rad2deg([Delta.lowerLimit Delta.upperLimit]);
rangeSlider.delta.MajorTicks = rad2deg(Delta.lowerLimit): 5: rad2deg(Delta.upperLimit);
rangeSlider.delta.MinorTicks = rad2deg(Delta.lowerLimit): 1: rad2deg(Delta.upperLimit);
rangeSlider.delta.Tooltip = 'Steering Angle';
rangeSlider.delta.ValueChangedFcn = @(src, event) YMD_progress(3);

rangeSlider.deltaLbl = uilabel(tab.singlePlot, 'Position', [100 60 200 22]);
rangeSlider.deltaLbl.Text = 'Steering Angle, δ [deg]';

%% Data Tab: Export Data

%--------------------------*
% Push Button: Export Data |
%--------------------------*
exportPlotButton = uibutton(tab.singlePlot, 'Position', [550 35 200 22]);
exportPlotButton.Text = 'Export Data Files';
exportPlotButton.ButtonPushedFcn = @(src, event) YMD_progress(5);

%-----------------------------------*
% Text Edit Field: Export Data Info |
%-----------------------------------*
exportField.field1 = uieditfield(tab.singlePlot, 'Position', [550 125 165 22]);
exportField.field1.Value = 'LateralAcceleration';
exportField.field1.HorizontalAlignment = 'right';

exportField.field2 = uieditfield(tab.singlePlot, 'Position', [550 75 165 22]);
exportField.field2.Value = 'YawMoment';
exportField.field2.HorizontalAlignment = 'right';

exportLbl.lbl1 = uilabel(tab.singlePlot, 'Position', [550 150 200 22]);
exportLbl.lbl1.Text = 'Lateral Acceleration Data File';

exportLbl.lbl2 = uilabel(tab.singlePlot, 'Position', [720 125 30 22]);
exportLbl.lbl2.Text = '.mat';

exportLbl.lbl3 = uilabel(tab.singlePlot, 'Position', [550 100 200 22]);
exportLbl.lbl3.Text = 'Yaw Moment Data File';

exportLbl.lbl4 = uilabel(tab.singlePlot, 'Position', [720 75 30 22]);
exportLbl.lbl4.Text = '.mat';

%% Sweep Plot Tab: Highlight Selected Plot

sweepInfoLbl1 = uilabel(tab.sweepPlot, 'Position', [150 125 150 22]);
sweepInfoLbl1.Text = 'Parameter to Sweep';

sweepInfoLbl2 = uilabel(tab.sweepPlot, 'Position', [300 125 200 22]);
sweepInfoLbl2.Text = '';

sweepInfoLbl3 = uilabel(tab.sweepPlot, 'Position', [150 100 150 22]);
sweepInfoLbl3.Text = 'Highlighted Plot';

%----------------------------------*
% Dropdown: Swept Parameter Values |
%----------------------------------*
sweptParamList = uidropdown(tab.sweepPlot, 'Position', [300 100 100 22]);
sweptParamList.ValueChangedFcn = @(src, event) YMD_progress(4);

%% YMD Plots

YMD = uiaxes(tab.singlePlot, 'Position', [100 200 650 450]);
YMDSweep = uiaxes(tab.sweepPlot, 'Position', [100 200 650 450]);

