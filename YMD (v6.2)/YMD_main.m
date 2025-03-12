%% Yaw Moment Diagram (v6.2)

% Update: 1. Bug fixes for updated magicformula function

%% Clear

clear, clc, close all;

%% Initialization

isInit = YMD_initialize;

%% UI Panel Overview

fig = uifigure('Position', [300 300 850 700]);

% Tabs
tabGroup = uitabgroup(fig, 'Position', [0 0 850 700]);
tab.setup = uitab(tabGroup, 'Title', 'Setup');
tab.YMD = uitab(tabGroup, 'Title', 'Single YMD');
tab.YMDSweep = uitab(tabGroup, 'Title', 'YMD Sweep');
tab.GGV = uitab(tabGroup, 'Title', 'GGV');

%% Data Tab: Headings

heading.param = uilabel(tab.setup, 'Position', [50 625 75 22]);
heading.param.Text = '\fontname{Arial}\bfParameter';
heading.param.Interpreter = 'tex';

heading.val = uilabel(tab.setup, 'Position', [200 625 75 22]);
heading.val.Text = '\fontname{Arial}\bfValue';
heading.val.Interpreter = 'tex';

heading.unit = uilabel(tab.setup, 'Position', [300 625 50 22]);
heading.unit.Text = '\fontname{Arial}\bfUnit';
heading.unit.Interpreter = 'tex';

heading.plot = uilabel(tab.setup, 'Position', [400 625 100 22]);
heading.plot.Text = '\fontname{Arial}\bfSingle YMD';
heading.plot.Interpreter = 'tex';

%% Data Tab: Vehicle Parameters

% (1) Mass
paramField.W = uieditfield(tab.setup, 'numeric', 'Position', [200 600 50 22]);
paramField.W.Value = param.W;
paramField.W.Limits = [0.1 inf];

paramLbl.W = uilabel(tab.setup, 'Position', [50 600 50 22]);
paramLbl.W.Text = 'Mass';

paramUnit.W = uidropdown(tab.setup, 'Position', [300 600 50 22]);
paramUnit.W.Items = {'lb'};

% (2) Front weight distribution
paramField.fwd = uieditfield(tab.setup, 'numeric', 'Position', [200 575 50 22]);
paramField.fwd.Value = param.fwd;
paramField.fwd.Limits = [0 100];
paramField.fwd.ValueDisplayFormat = "%d%%";

paramLbl.fwd = uilabel(tab.setup, 'Position', [50 575 150 22]);
paramLbl.fwd.Text = 'Front Weight Distribution';

% (3) Wheelbase
paramField.l = uieditfield(tab.setup, 'numeric', 'Position', [200 550 50 22]);
paramField.l.Value = param.l;
paramField.l.Limits = [0.1 Inf];
paramField.l.ValueDisplayFormat = "%.1f";

paramLbl.l = uilabel(tab.setup, 'Position', [50 550 150 22]);
paramLbl.l.Text = 'Wheelbase';

paramUnit.l = uidropdown(tab.setup, 'Position', [300 550 50 22]);
paramUnit.l.Items = {'in'};

% (4) Front track width
paramField.t_F = uieditfield(tab.setup, 'numeric', 'Position', [200 525 50 22]);
paramField.t_F.Value = param.t_F;
paramField.t_F.Limits = [0.1 Inf];
paramField.t_F.ValueDisplayFormat = "%.1f";

paramLbl.t_F = uilabel(tab.setup, 'Position', [50 525 150 22]);
paramLbl.t_F.Text = 'Front Track Width';

paramUnit.t_F = uidropdown(tab.setup, 'Position', [300 525 50 22]);
paramUnit.t_F.Items = {'in'};

% (5) Rear track width
paramField.t_R = uieditfield(tab.setup, 'numeric', 'Position', [200 500 50 22]);
paramField.t_R.Value = param.t_R;
paramField.t_R.Limits = [0.1 Inf];
paramField.t_R.ValueDisplayFormat = "%.1f";

paramLbl.t_R = uilabel(tab.setup, 'Position', [50 500 150 22]);
paramLbl.t_R.Text = 'Rear Track Width';

paramUnit.t_R = uidropdown(tab.setup, 'Position', [300 500 50 22]);
paramUnit.t_R.Items = {'in'};

% (6) CG Height
paramField.h = uieditfield(tab.setup, 'numeric', 'Position', [200 475 50 22]);
paramField.h.Value = param.h;
paramField.h.Limits = [0 Inf];
paramField.h.ValueDisplayFormat = "%.2f";

paramLbl.h = uilabel(tab.setup, 'Position', [50 475 150 22]);
paramLbl.h.Text = 'CG Height';

paramUnit.h = uidropdown(tab.setup, 'Position', [300 475 50 22]);
paramUnit.h.Items = {'in'};

% (7) Front roll center height
paramField.z_RF = uieditfield(tab.setup, 'numeric', 'Position', [200 450 50 22]);
paramField.z_RF.Value = param.z_RF;
paramField.z_RF.Limits = [0 Inf];
paramField.z_RF.ValueDisplayFormat = "%.2f";

paramLbl.z_RF = uilabel(tab.setup, 'Position', [50 450 150 22]);
paramLbl.z_RF.Text = 'Front Roll Center Height';

paramUnit.z_RF = uidropdown(tab.setup, 'Position', [300 450 50 22]);
paramUnit.z_RF.Items = {'in'};

% (8) Rear roll center height
paramField.z_RR = uieditfield(tab.setup, 'numeric', 'Position', [200 425 50 22]);
paramField.z_RR.Value = param.z_RR;
paramField.z_RR.Limits = [0 Inf];
paramField.z_RR.ValueDisplayFormat = "%.2f";

paramLbl.z_RR = uilabel(tab.setup, 'Position', [50 425 150 22]);
paramLbl.z_RR.Text = 'Rear Roll Center Height';

paramUnit.z_RR = uidropdown(tab.setup, 'Position', [300 425 50 22]);
paramUnit.z_RR.Items = {'in'};

% (9) Ackermann
paramField.ackermann = uieditfield(tab.setup, 'numeric', 'Position', [200 400 50 22]);
paramField.ackermann.Value = param.ackermann;
paramField.ackermann.ValueDisplayFormat = "%d%%";

paramLbl.ackermann = uilabel(tab.setup, 'Position', [50 400 150 22]);
paramLbl.ackermann.Text = 'Ackermann';

% (10) Front toe
paramField.toe_f = uieditfield(tab.setup, 'numeric', 'Position', [200 375 50 22]);
paramField.toe_f.Value = param.toe_f;
paramField.toe_f.ValueDisplayFormat = "%.1f°";

paramLbl.toe_f = uilabel(tab.setup, 'Position', [50 375 150 22]);
paramLbl.toe_f.Text = 'Front Toe';

% (11) Rear toe
paramField.toe_r = uieditfield(tab.setup, 'numeric', 'Position', [200 350 50 22]);
paramField.toe_r.Value = param.toe_r;
paramField.toe_r.ValueDisplayFormat = "%.1f°";

paramLbl.toe_r = uilabel(tab.setup, 'Position', [50 350 150 22]);
paramLbl.toe_r.Text = 'Rear Toe';

% (12) Tire spring rate
paramField.tire_k = uieditfield(tab.setup, 'numeric', 'Position', [200 325 50 22]);
paramField.tire_k.Value = param.tire_k;
paramField.tire_k.Limits = [0 Inf];

paramLbl.tire_k = uilabel(tab.setup, 'Position', [50 325 150 22]);
paramLbl.tire_k.Text = 'Tire Spring Rate';

paramUnit.tire_k = uidropdown(tab.setup, 'Position', [300 325 60 22]);
paramUnit.tire_k.Items = {'lb/in'};

% (13) Front spring stiffness
paramField.f_spring_k = uieditfield(tab.setup, 'numeric', 'Position', [200 300 50 22]);
paramField.f_spring_k.Value = param.f_spring_k;
paramField.f_spring_k.Limits = [0 Inf];

paramLbl.f_spring_k = uilabel(tab.setup, 'Position', [50 300 150 22]);
paramLbl.f_spring_k.Text = 'Front Spring Stiffness';

paramUnit.f_spring_k = uidropdown(tab.setup, 'Position', [300 300 60 22]);
paramUnit.f_spring_k.Items = {'lb/in'};

% (14) Rear spring stiffness
paramField.r_spring_k = uieditfield(tab.setup, 'numeric', 'Position', [200 275 50 22]);
paramField.r_spring_k.Value = param.r_spring_k;
paramField.r_spring_k.Limits = [0 Inf];

paramLbl.r_spring_k = uilabel(tab.setup, 'Position', [50 275 150 22]);
paramLbl.r_spring_k.Text = 'Rear Spring Stiffness';

paramUnit.r_spring_k = uidropdown(tab.setup, 'Position', [300 275 60 22]);
paramUnit.r_spring_k.Items = {'lb/in'};

% (15) Front ARB stiffness
paramField.f_arb_k = uieditfield(tab.setup, 'numeric', 'Position', [200 250 50 22]);
paramField.f_arb_k.Value = param.f_arb_k;
paramField.f_arb_k.Limits = [0 Inf];

paramLbl.f_arb_k = uilabel(tab.setup, 'Position', [50 250 150 22]);
paramLbl.f_arb_k.Text = 'Front ARB Stiffness';

paramUnit.f_arb_k = uidropdown(tab.setup, 'Position', [300 250 60 22]);
paramUnit.f_arb_k.Items = {'lb/in'};

% (16) Rear ARB stiffness
paramField.r_arb_k = uieditfield(tab.setup, 'numeric', 'Position', [200 225 50 22]);
paramField.r_arb_k.Value = param.r_arb_k;
paramField.r_arb_k.Limits = [0 Inf];

paramLbl.r_arb_k = uilabel(tab.setup, 'Position', [50 225 150 22]);
paramLbl.r_arb_k.Text = 'Rear ARB Stiffness';

paramUnit.r_arb_k = uidropdown(tab.setup, 'Position', [300 225 60 22]);
paramUnit.r_arb_k.Items = {'lb/in'};

% (17) Coefficient of lift
paramField.C_L = uieditfield(tab.setup, 'numeric', 'Position', [200 200 50 22]);
paramField.C_L.Value = param.C_L;
paramField.C_L.Limits = [0 Inf];

paramLbl.C_L = uilabel(tab.setup, 'Position', [50 200 150 22]);
paramLbl.C_L.Text = 'Coefficient of Lift';

% (18) Center of Pressure
paramField.CoP = uieditfield(tab.setup, 'numeric', 'Position', [200 175 50 22]);
paramField.CoP.Value = param.CoP;
paramField.CoP.Limits = [0 100];
paramField.CoP.ValueDisplayFormat = "%d%%";

paramLbl.CoP = uilabel(tab.setup, 'Position', [50 175 150 22]);
paramLbl.CoP.Text = 'Center of Pressure';

% (19) Velocity
paramField.V = uieditfield(tab.setup, 'numeric', 'Position', [200 150 50 22]);
paramField.V.Value = param.V.mph;

paramLbl.V = uilabel(tab.setup, 'Position', [50 150 150 22]);
paramLbl.V.Text = 'Velocity';

paramUnit.V = uidropdown(tab.setup, 'Position', [300 150 60 22]);
paramUnit.V.Items = {'mph', 'kph', 'ft/s'};

%% Data Tab: Make Single YMD

%---------------------------------------------*
% Numeric Edit Field: Slip Angle Range Inputs |
%---------------------------------------------*
rangeLbl.SALbl1 = uilabel(tab.setup);
rangeLbl.SALbl1.Position = [heading.plot.Position(1) heading.plot.Position(2)-25 150 22];
rangeLbl.SALbl1.Text = 'Slip Angle (SA, deg)';

rangeLbl.SALbl2 = uilabel(tab.setup);
rangeLbl.SALbl2.Position = [heading.plot.Position(1) rangeLbl.SALbl1.Position(2)-25 50 22];
rangeLbl.SALbl2.Text = 'From';

rangeField.SAField1 = uieditfield(tab.setup, 'numeric');
rangeField.SAField1.Position = [heading.plot.Position(1)+35 rangeLbl.SALbl2.Position(2) 50 22];
rangeField.SAField1.Value = -15;

rangeLbl.SALbl3 = uilabel(tab.setup);
rangeLbl.SALbl3.Position = [rangeField.SAField1.Position(1)+65 rangeLbl.SALbl2.Position(2) 50 22];
rangeLbl.SALbl3.Text = 'To';

rangeField.SAField2 = uieditfield(tab.setup, 'numeric');
rangeField.SAField2.Position = [rangeLbl.SALbl3.Position(1)+35 rangeLbl.SALbl2.Position(2) 50 22];
rangeField.SAField2.Value = 15;

rangeLbl.SALbl4 = uilabel(tab.setup);
rangeLbl.SALbl4.Position = [rangeField.SAField2.Position(1)+65 rangeLbl.SALbl2.Position(2) 100 22];
rangeLbl.SALbl4.Text = 'No. Data Points';

rangeField.SAField3 = uieditfield(tab.setup, 'numeric');
rangeField.SAField3.Position = [rangeLbl.SALbl4.Position(1)+100 rangeLbl.SALbl2.Position(2) 50 22];
rangeField.SAField3.Value = 31;

%-------------------------------------------------*
% Numeric Edit Field: Steering Angle Range Inputs |
%-------------------------------------------------*
rangeLbl.deltaLbl1 = uilabel(tab.setup);
rangeLbl.deltaLbl1.Position = [heading.plot.Position(1) rangeField.SAField3.Position(2)-25 150 22];
rangeLbl.deltaLbl1.Text = 'Steering Angle (δ, deg)';

rangeLbl.deltaLbl2 = uilabel(tab.setup);
rangeLbl.deltaLbl2.Position = [heading.plot.Position(1) rangeLbl.deltaLbl1.Position(2)-25 50 22];
rangeLbl.deltaLbl2.Text = 'From';

rangeField.deltaField1 = uieditfield(tab.setup, 'numeric');
rangeField.deltaField1.Position = [heading.plot.Position(1)+35 rangeLbl.deltaLbl2.Position(2) 50 22];
rangeField.deltaField1.Value = -15;

rangeLbl.deltaLbl3 = uilabel(tab.setup);
rangeLbl.deltaLbl3.Position = [rangeField.deltaField1.Position(1)+65 rangeLbl.deltaLbl2.Position(2) 50 22];
rangeLbl.deltaLbl3.Text = 'To';

rangeField.deltaField2 = uieditfield(tab.setup, 'numeric');
rangeField.deltaField2.Position = [rangeLbl.deltaLbl3.Position(1)+35 rangeLbl.deltaLbl2.Position(2) 50 22];
rangeField.deltaField2.Value = 15;

rangeLbl.deltaLbl4 = uilabel(tab.setup);
rangeLbl.deltaLbl4.Position = [rangeField.deltaField2.Position(1)+65 rangeLbl.deltaLbl2.Position(2) 100 22];
rangeLbl.deltaLbl4.Text = 'No. Data Points';

rangeField.deltaField3 = uieditfield(tab.setup, 'numeric');
rangeField.deltaField3.Position = [rangeLbl.deltaLbl4.Position(1)+100 rangeLbl.deltaLbl2.Position(2) 50 22];
rangeField.deltaField3.Value = 31;

%---------------------------------------------*
% Numeric Edit Field: Slip Ratio Range Inputs |
%---------------------------------------------*
rangeLbl.SXLbl1 = uilabel(tab.setup);
rangeLbl.SXLbl1.Position = [heading.plot.Position(1) rangeField.deltaField3.Position(2)-25 150 22];
rangeLbl.SXLbl1.Text = 'Slip Ratio (SX)';

rangeLbl.SXLbl2 = uilabel(tab.setup);
rangeLbl.SXLbl2.Position = [heading.plot.Position(1) rangeLbl.SXLbl1.Position(2)-25 50 22];
rangeLbl.SXLbl2.Text = 'From';

rangeField.SXField1 = uieditfield(tab.setup, 'numeric');
rangeField.SXField1.Position = [heading.plot.Position(1)+35 rangeLbl.SXLbl2.Position(2) 50 22];
rangeField.SXField1.Value = 0;
rangeField.SXField1.Limits = [-0.99 0.99];

rangeLbl.SXLbl3 = uilabel(tab.setup);
rangeLbl.SXLbl3.Position = [rangeField.SXField1.Position(1)+65 rangeLbl.SXLbl2.Position(2) 50 22];
rangeLbl.SXLbl3.Text = 'To';

rangeField.SXField2 = uieditfield(tab.setup, 'numeric');
rangeField.SXField2.Position = [rangeLbl.SXLbl3.Position(1)+35 rangeLbl.SXLbl2.Position(2) 50 22];
rangeField.SXField2.Value = 0;
rangeField.SXField2.Limits = [-0.99 0.99];

rangeLbl.SXLbl4 = uilabel(tab.setup);
rangeLbl.SXLbl4.Position = [rangeField.SXField2.Position(1)+65 rangeLbl.SXLbl2.Position(2) 100 22];
rangeLbl.SXLbl4.Text = 'No. Data Points';

rangeField.SXField3 = uieditfield(tab.setup, 'numeric');
rangeField.SXField3.Position = [rangeLbl.SXLbl4.Position(1)+100 rangeLbl.SXLbl2.Position(2) 50 22];
rangeField.SXField3.Value = 1;

%------------------------------*
% Push Button: Plot Parameters |
%------------------------------*
plotButton = uibutton(tab.setup);
plotButton.Position = [heading.plot.Position(1) rangeLbl.SXLbl2.Position(2)-35 185 22];
plotButton.Text = 'Plot/Update with Current Inputs';
plotButton.ButtonPushedFcn = @(src, event) YMD_progress(1);

%% Data Tab: Make YMD Sweep Plot

heading.sweep = uilabel(tab.setup);
heading.sweep.Position = [heading.plot.Position(1) plotButton.Position(2)-40 100 22];
heading.sweep.Text = '\fontname{Arial}\bfSweep YMD';
heading.sweep.Interpreter = 'tex';

%---------------------------------*
% Dropdown: Parameter to be Swept |
%---------------------------------*
sweptParamLbl = uilabel(tab.setup);
sweptParamLbl.Position = [heading.plot.Position(1) heading.sweep.Position(2)-25 150 22];
sweptParamLbl.Text = 'Parameter to Sweep';

sweptParam = uidropdown(tab.setup);
sweptParam.Position = [heading.plot.Position(1)+135 sweptParamLbl.Position(2) 215 22];
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
sweepLbl.lbl1 = uilabel(tab.setup);
sweepLbl.lbl1.Position = [heading.plot.Position(1) sweptParam.Position(2)-25 50 22];
sweepLbl.lbl1.Text = 'From';

sweepField.field1 = uieditfield(tab.setup, 'numeric');
sweepField.field1.Position = [heading.plot.Position(1)+35 sweepLbl.lbl1.Position(2) 50 22];

sweepLbl.lbl2 = uilabel(tab.setup);
sweepLbl.lbl2.Position = [sweepField.field1.Position(1)+65 sweepLbl.lbl1.Position(2) 50 22];
sweepLbl.lbl2.Text = 'To';

sweepField.field2 = uieditfield(tab.setup, 'numeric');
sweepField.field2.Position = [sweepLbl.lbl2.Position(1)+35 sweepLbl.lbl1.Position(2) 50 22];

sweepLbl.lbl3 = uilabel(tab.setup);
sweepLbl.lbl3.Position = [sweepField.field2.Position(1)+65 sweepLbl.lbl1.Position(2) 100 22];
sweepLbl.lbl3.Text = 'Number of Plots';

sweepField.field3 = uieditfield(tab.setup, 'numeric');
sweepField.field3.Position = [sweepLbl.lbl3.Position(1)+100 sweepLbl.lbl1.Position(2) 50 22];

%--------------------*
% Push Button: Sweep |
%--------------------*
sweepButton = uibutton(tab.setup);
sweepButton.Position = [heading.plot.Position(1) sweepField.field3.Position(2)-35 185 22];
sweepButton.Text = 'Sweep Over Selected Parameter';
sweepButton.ButtonPushedFcn = @(src, event) YMD_progress(2);

%% Data Tab: Make GGV Diagram

heading.GGV = uilabel(tab.setup);
heading.GGV.Position = [heading.plot.Position(1) sweepButton.Position(2)-40 100 22];
heading.GGV.Text = '\fontname{Arial}\bfGGV Diagram';
heading.GGV.Interpreter = 'tex';

%-------------------------------------------*
% Numeric Edit Field: Velocity Range Inputs |
%-------------------------------------------*

VLbl.lbl1 = uilabel(tab.setup);
VLbl.lbl1.Position = [heading.plot.Position(1) heading.GGV.Position(2)-25 150 22];
VLbl.lbl1.Text = 'Velocity [mph]';

VLbl.lbl2 = uilabel(tab.setup);
VLbl.lbl2.Position = [heading.plot.Position(1) VLbl.lbl1.Position(2)-25 50 22];
VLbl.lbl2.Text = 'From';

VField.field1 = uieditfield(tab.setup, 'numeric');
VField.field1.Position = [heading.plot.Position(1)+35 VLbl.lbl2.Position(2) 50 22];

VLbl.lbl3 = uilabel(tab.setup);
VLbl.lbl3.Position = [VField.field1.Position(1)+65 VLbl.lbl2.Position(2) 50 22];
VLbl.lbl3.Text = 'To';

VField.field2 = uieditfield(tab.setup, 'numeric');
VField.field2.Position = [VLbl.lbl3.Position(1)+35 VLbl.lbl2.Position(2) 50 22];

VLbl.lbl4 = uilabel(tab.setup);
VLbl.lbl4.Position = [VField.field2.Position(1)+65 VLbl.lbl2.Position(2) 100 22];
VLbl.lbl4.Text = 'Number of Plots';

VField.field3 = uieditfield(tab.setup, 'numeric');
VField.field3.Position = [VLbl.lbl4.Position(1)+100 VLbl.lbl2.Position(2) 50 22];

%-------------------------------*
% Push Button: Plot GGV Diagram |
%-------------------------------*
GGVButton = uibutton(tab.setup);
GGVButton.Position = [heading.plot.Position(1) VField.field3.Position(2)-35 185 22];
GGVButton.Text = 'Make GGV Diagram';
GGVButton.ButtonPushedFcn = @(src, event) YMD_progress(7);

%% Single Plot Tab: Plot Adjustments

%---------------------------------*
% Dropdown List: Adjust Plot View |
%---------------------------------*
heading.plotView = uilabel(tab.YMD);
heading.plotView.Position = [100 150 100 22];
heading.plotView.Text = '\fontname{Arial}\bfPlot View';
heading.plotView.Interpreter = 'tex';

viewSelect = uidropdown(tab.YMD);
viewSelect.Position = [heading.plotView.Position(1) heading.plotView.Position(2)-25 150 22];
viewSelect.Items = ["Default (Isometric)", "XY (Classic YMD)", "XZ (Friction Ellipse)", "YZ"];
viewSelect.ValueChangedFcn = @(src, event) YMD_progress(3);

%------------------------------------------------*
% Checkbox: Hide/Show Slip Angle Variation Lines |
%------------------------------------------------*
lineSelect.SALine = uicheckbox(tab.YMD);
lineSelect.SALine.Position = [heading.plotView.Position(1) viewSelect.Position(2)-25 250 22];
lineSelect.SALine.Text = 'Show Slip Angle Variation Lines';
lineSelect.SALine.Value = 1;
lineSelect.SALine.ValueChangedFcn = @(src, event) YMD_progress(4);

%----------------------------------------------------*
% Checkbox: Hide/Show Steering Angle Variation Lines |
%----------------------------------------------------*
lineSelect.deltaLine = uicheckbox(tab.YMD);
lineSelect.deltaLine.Position = [heading.plotView.Position(1) lineSelect.SALine.Position(2)-25 250 22];
lineSelect.deltaLine.Text = 'Show Steering Angle Variation Lines';
lineSelect.deltaLine.Value = 1;
lineSelect.deltaLine.ValueChangedFcn = @(src, event) YMD_progress(4);

%------------------------------------------------*
% Checkbox: Hide/Show Slip Ratio Variation Lines |
%------------------------------------------------*
lineSelect.SXLine = uicheckbox(tab.YMD);
lineSelect.SXLine.Position = [heading.plotView.Position(1) lineSelect.deltaLine.Position(2)-25 250 22];
lineSelect.SXLine.Text = 'Show Slip Ratio Variation Lines';
lineSelect.SXLine.Value = 1;
lineSelect.SXLine.ValueChangedFcn = @(src, event) YMD_progress(4);

%% Single Plot Tab: Export Data

heading.exportData = uilabel(tab.YMD);
heading.exportData.Position = [550 150 100 22];
heading.exportData.Text = '\fontname{Arial}\bfExport Data';
heading.exportData.Interpreter = 'tex';

%-----------------------------------*
% Text Edit Field: Export Data Info |
%-----------------------------------*
exportField.field = uieditfield(tab.YMD);
exportField.field.Position = [heading.exportData.Position(1) heading.exportData.Position(2)-25 165 22];
exportField.field.Value = 'YMD_singlePlot';
exportField.field.HorizontalAlignment = 'right';

exportLbl.lbl = uilabel(tab.YMD, 'Position', [720 125 30 22]);
exportLbl.lbl.Text = '.mat';

%--------------------------*
% Push Button: Export Data |
%--------------------------*
exportPlotButton = uibutton(tab.YMD);
exportPlotButton.Position = [heading.exportData.Position(1) exportField.field.Position(2)-35 200 22];
exportPlotButton.Text = 'Export Data File';
exportPlotButton.ButtonPushedFcn = @(src, event) YMD_progress(61);

%% YMD Sweep Tab: Highlight Selected Plot

sweepInfoLbl1 = uilabel(tab.YMDSweep, 'Position', [150 125 150 22]);
sweepInfoLbl1.Text = 'Parameter to Sweep';

sweepInfoLbl2 = uilabel(tab.YMDSweep, 'Position', [300 125 200 22]);
sweepInfoLbl2.Text = '';

sweepInfoLbl3 = uilabel(tab.YMDSweep, 'Position', [150 100 150 22]);
sweepInfoLbl3.Text = 'Highlighted Plot';

%----------------------------------*
% Dropdown: Swept Parameter Values |
%----------------------------------*
sweptParamList = uidropdown(tab.YMDSweep, 'Position', [300 100 100 22]);
sweptParamList.ValueChangedFcn = @(src, event) YMD_progress(5);

%% YMD Sweep Tab: Export Data

heading.exportSweepData = uilabel(tab.YMDSweep);
heading.exportSweepData.Position = [550 150 100 22];
heading.exportSweepData.Text = '\fontname{Arial}\bfExport Data';
heading.exportSweepData.Interpreter = 'tex';

%-----------------------------------*
% Text Edit Field: Export Data Info |
%-----------------------------------*
exportField_sweep.field = uieditfield(tab.YMDSweep);
exportField_sweep.field.Position = [heading.exportSweepData.Position(1) heading.exportSweepData.Position(2)-25 165 22];
exportField_sweep.field.Value = 'YMD_sweepPlots';
exportField_sweep.field.HorizontalAlignment = 'right';

exportLbl_sweep.lbl = uilabel(tab.YMDSweep, 'Position', [720 125 30 22]);
exportLbl_sweep.lbl.Text = '.mat';

%--------------------------*
% Push Button: Export Data |
%--------------------------*
exportButton_sweep = uibutton(tab.YMDSweep);
exportButton_sweep.Position = [heading.exportSweepData.Position(1) exportField_sweep.field.Position(2)-35 200 22];
exportButton_sweep.Text = 'Export Data File';
exportButton_sweep.ButtonPushedFcn = @(src, event) YMD_progress(62);

%% GGV Tab

%% YMD Plots

YMDAxes = uiaxes(tab.YMD, 'Position', [100 200 650 450]);
YMDSweepAxes = uiaxes(tab.YMDSweep, 'Position', [100 200 650 450]);
GGVAxes = uiaxes(tab.GGV, 'Position', [100 200 650 450]);

