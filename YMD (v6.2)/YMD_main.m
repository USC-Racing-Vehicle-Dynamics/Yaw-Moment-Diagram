%% Yaw Moment Diagram (v6.2)

%% Clear

clear, clc, close all;

%% Initialization

isInit = YMD_initialize;

%% UI Panel Overview

% UI figure: app
fig = uifigure;
fig.Name = 'Yaw Moment Diagram (v6.2)';
fig.Position = [300 50 850 750];

% UI tab: tabs
tabGroup = uitabgroup(fig, 'Position', [0 0 850 750]);
tabs.setup = uitab(tabGroup, 'Title', 'Setup');
tabs.YMD = uitab(tabGroup, 'Title', 'Single YMD');
tabs.YMDSweep = uitab(tabGroup, 'Title', 'YMD Sweep');
tabs.GGV = uitab(tabGroup, 'Title', 'GGV');

%% Data Tab: Headings

labels.param = uilabel(tabs.setup, 'Position', [50 625 75 22]);
labels.param.Text = '\fontname{Arial}\bfParameter';
labels.param.Interpreter = 'tex';

labels.val = uilabel(tabs.setup, 'Position', [200 625 75 22]);
labels.val.Text = '\fontname{Arial}\bfValue';
labels.val.Interpreter = 'tex';

labels.unit = uilabel(tabs.setup, 'Position', [300 625 50 22]);
labels.unit.Text = '\fontname{Arial}\bfUnit';
labels.unit.Interpreter = 'tex';

labels.plot = uilabel(tabs.setup, 'Position', [400 625 100 22]);
labels.plot.Text = '\fontname{Arial}\bfSingle YMD';
labels.plot.Interpreter = 'tex';

%% Data Tab: Vehicle Parameters

% (1) Mass
paramField.W = uieditfield(tabs.setup, 'numeric', 'Position', [200 600 50 22]);
paramField.W.Value = param.W;
paramField.W.Limits = [0.1 inf];

paramLbl.W = uilabel(tabs.setup, 'Position', [50 600 50 22]);
paramLbl.W.Text = 'Mass';

paramUnit.W = uidropdown(tabs.setup, 'Position', [300 600 50 22]);
paramUnit.W.Items = {'lb'};

% (2) Front weight distribution
paramField.fwd = uieditfield(tabs.setup, 'numeric', 'Position', [200 575 50 22]);
paramField.fwd.Value = param.fwd;
paramField.fwd.Limits = [0 100];
paramField.fwd.ValueDisplayFormat = "%d%%";

paramLbl.fwd = uilabel(tabs.setup, 'Position', [50 575 150 22]);
paramLbl.fwd.Text = 'Front Weight Distribution';

% (3) Wheelbase
paramField.l = uieditfield(tabs.setup, 'numeric', 'Position', [200 550 50 22]);
paramField.l.Value = param.l;
paramField.l.Limits = [0.1 Inf];
paramField.l.ValueDisplayFormat = "%.1f";

paramLbl.l = uilabel(tabs.setup, 'Position', [50 550 150 22]);
paramLbl.l.Text = 'Wheelbase';

paramUnit.l = uidropdown(tabs.setup, 'Position', [300 550 50 22]);
paramUnit.l.Items = {'in'};

% (4) Front track width
paramField.t_F = uieditfield(tabs.setup, 'numeric', 'Position', [200 525 50 22]);
paramField.t_F.Value = param.t_F;
paramField.t_F.Limits = [0.1 Inf];
paramField.t_F.ValueDisplayFormat = "%.1f";

paramLbl.t_F = uilabel(tabs.setup, 'Position', [50 525 150 22]);
paramLbl.t_F.Text = 'Front Track Width';

paramUnit.t_F = uidropdown(tabs.setup, 'Position', [300 525 50 22]);
paramUnit.t_F.Items = {'in'};

% (5) Rear track width
paramField.t_R = uieditfield(tabs.setup, 'numeric', 'Position', [200 500 50 22]);
paramField.t_R.Value = param.t_R;
paramField.t_R.Limits = [0.1 Inf];
paramField.t_R.ValueDisplayFormat = "%.1f";

paramLbl.t_R = uilabel(tabs.setup, 'Position', [50 500 150 22]);
paramLbl.t_R.Text = 'Rear Track Width';

paramUnit.t_R = uidropdown(tabs.setup, 'Position', [300 500 50 22]);
paramUnit.t_R.Items = {'in'};

% (6) CG Height
paramField.h = uieditfield(tabs.setup, 'numeric', 'Position', [200 475 50 22]);
paramField.h.Value = param.h;
paramField.h.Limits = [0 Inf];
paramField.h.ValueDisplayFormat = "%.2f";

paramLbl.h = uilabel(tabs.setup, 'Position', [50 475 150 22]);
paramLbl.h.Text = 'CG Height';

paramUnit.h = uidropdown(tabs.setup, 'Position', [300 475 50 22]);
paramUnit.h.Items = {'in'};

% (7) Front roll center height
paramField.z_RF = uieditfield(tabs.setup, 'numeric', 'Position', [200 450 50 22]);
paramField.z_RF.Value = param.z_RF;
paramField.z_RF.Limits = [0 Inf];
paramField.z_RF.ValueDisplayFormat = "%.2f";

paramLbl.z_RF = uilabel(tabs.setup, 'Position', [50 450 150 22]);
paramLbl.z_RF.Text = 'Front Roll Center Height';

paramUnit.z_RF = uidropdown(tabs.setup, 'Position', [300 450 50 22]);
paramUnit.z_RF.Items = {'in'};

% (8) Rear roll center height
paramField.z_RR = uieditfield(tabs.setup, 'numeric', 'Position', [200 425 50 22]);
paramField.z_RR.Value = param.z_RR;
paramField.z_RR.Limits = [0 Inf];
paramField.z_RR.ValueDisplayFormat = "%.2f";

paramLbl.z_RR = uilabel(tabs.setup, 'Position', [50 425 150 22]);
paramLbl.z_RR.Text = 'Rear Roll Center Height';

paramUnit.z_RR = uidropdown(tabs.setup, 'Position', [300 425 50 22]);
paramUnit.z_RR.Items = {'in'};

% (9) Ackermann
paramField.ackermann = uieditfield(tabs.setup, 'numeric', 'Position', [200 400 50 22]);
paramField.ackermann.Value = param.ackermann;
paramField.ackermann.ValueDisplayFormat = "%d%%";

paramLbl.ackermann = uilabel(tabs.setup, 'Position', [50 400 150 22]);
paramLbl.ackermann.Text = 'Ackermann';

% (10) Front toe
paramField.toe_f = uieditfield(tabs.setup, 'numeric', 'Position', [200 375 50 22]);
paramField.toe_f.Value = param.toe_f;
paramField.toe_f.ValueDisplayFormat = "%.1f°";

paramLbl.toe_f = uilabel(tabs.setup, 'Position', [50 375 150 22]);
paramLbl.toe_f.Text = 'Front Toe';

% (11) Rear toe
paramField.toe_r = uieditfield(tabs.setup, 'numeric', 'Position', [200 350 50 22]);
paramField.toe_r.Value = param.toe_r;
paramField.toe_r.ValueDisplayFormat = "%.1f°";

paramLbl.toe_r = uilabel(tabs.setup, 'Position', [50 350 150 22]);
paramLbl.toe_r.Text = 'Rear Toe';

% (12) Tire spring rate
paramField.tire_k = uieditfield(tabs.setup, 'numeric', 'Position', [200 325 50 22]);
paramField.tire_k.Value = param.tire_k;
paramField.tire_k.Limits = [0 Inf];

paramLbl.tire_k = uilabel(tabs.setup, 'Position', [50 325 150 22]);
paramLbl.tire_k.Text = 'Tire Spring Rate';

paramUnit.tire_k = uidropdown(tabs.setup, 'Position', [300 325 60 22]);
paramUnit.tire_k.Items = {'lb/in'};

% (13) Front spring stiffness
paramField.f_spring_k = uieditfield(tabs.setup, 'numeric', 'Position', [200 300 50 22]);
paramField.f_spring_k.Value = param.f_spring_k;
paramField.f_spring_k.Limits = [0 Inf];

paramLbl.f_spring_k = uilabel(tabs.setup, 'Position', [50 300 150 22]);
paramLbl.f_spring_k.Text = 'Front Spring Stiffness';

paramUnit.f_spring_k = uidropdown(tabs.setup, 'Position', [300 300 60 22]);
paramUnit.f_spring_k.Items = {'lb/in'};

% (14) Rear spring stiffness
paramField.r_spring_k = uieditfield(tabs.setup, 'numeric', 'Position', [200 275 50 22]);
paramField.r_spring_k.Value = param.r_spring_k;
paramField.r_spring_k.Limits = [0 Inf];

paramLbl.r_spring_k = uilabel(tabs.setup, 'Position', [50 275 150 22]);
paramLbl.r_spring_k.Text = 'Rear Spring Stiffness';

paramUnit.r_spring_k = uidropdown(tabs.setup, 'Position', [300 275 60 22]);
paramUnit.r_spring_k.Items = {'lb/in'};

% (15) Front ARB stiffness
paramField.f_arb_k = uieditfield(tabs.setup, 'numeric', 'Position', [200 250 50 22]);
paramField.f_arb_k.Value = param.f_arb_k;
paramField.f_arb_k.Limits = [0 Inf];

paramLbl.f_arb_k = uilabel(tabs.setup, 'Position', [50 250 150 22]);
paramLbl.f_arb_k.Text = 'Front ARB Stiffness';

paramUnit.f_arb_k = uidropdown(tabs.setup, 'Position', [300 250 60 22]);
paramUnit.f_arb_k.Items = {'lb/in'};

% (16) Rear ARB stiffness
paramField.r_arb_k = uieditfield(tabs.setup, 'numeric', 'Position', [200 225 50 22]);
paramField.r_arb_k.Value = param.r_arb_k;
paramField.r_arb_k.Limits = [0 Inf];

paramLbl.r_arb_k = uilabel(tabs.setup, 'Position', [50 225 150 22]);
paramLbl.r_arb_k.Text = 'Rear ARB Stiffness';

paramUnit.r_arb_k = uidropdown(tabs.setup, 'Position', [300 225 60 22]);
paramUnit.r_arb_k.Items = {'lb/in'};

% (17) Coefficient of lift
paramField.C_L = uieditfield(tabs.setup, 'numeric', 'Position', [200 200 50 22]);
paramField.C_L.Value = param.C_L;
paramField.C_L.Limits = [0 Inf];

paramLbl.C_L = uilabel(tabs.setup, 'Position', [50 200 150 22]);
paramLbl.C_L.Text = 'Coefficient of Lift';

% (18) Center of Pressure
paramField.CoP = uieditfield(tabs.setup, 'numeric', 'Position', [200 175 50 22]);
paramField.CoP.Value = param.CoP;
paramField.CoP.Limits = [0 100];
paramField.CoP.ValueDisplayFormat = "%d%%";

paramLbl.CoP = uilabel(tabs.setup, 'Position', [50 175 150 22]);
paramLbl.CoP.Text = 'Center of Pressure';

% (19) Velocity
paramField.V = uieditfield(tabs.setup, 'numeric', 'Position', [200 150 50 22]);
paramField.V.Value = param.V.mph;

paramLbl.V = uilabel(tabs.setup, 'Position', [50 150 150 22]);
paramLbl.V.Text = 'Velocity';

paramUnit.V = uidropdown(tabs.setup, 'Position', [300 150 60 22]);
paramUnit.V.Items = {'mph', 'kph', 'ft/s'};

%% Data Tab: Make Single YMD

%---------------------------------------------*
% Numeric Edit Field: Slip Angle Range Inputs |
%---------------------------------------------*
rangeLbl.SALbl1 = uilabel(tabs.setup);
rangeLbl.SALbl1.Position = [labels.plot.Position(1) labels.plot.Position(2)-25 150 22];
rangeLbl.SALbl1.Text = 'Slip Angle (SA, deg)';

rangeLbl.SALbl2 = uilabel(tabs.setup);
rangeLbl.SALbl2.Position = [labels.plot.Position(1) rangeLbl.SALbl1.Position(2)-25 50 22];
rangeLbl.SALbl2.Text = 'From';

rangeField.SAField1 = uieditfield(tabs.setup, 'numeric');
rangeField.SAField1.Position = [labels.plot.Position(1)+35 rangeLbl.SALbl2.Position(2) 50 22];
rangeField.SAField1.Value = -12;

rangeLbl.SALbl3 = uilabel(tabs.setup);
rangeLbl.SALbl3.Position = [rangeField.SAField1.Position(1)+65 rangeLbl.SALbl2.Position(2) 50 22];
rangeLbl.SALbl3.Text = 'To';

rangeField.SAField2 = uieditfield(tabs.setup, 'numeric');
rangeField.SAField2.Position = [rangeLbl.SALbl3.Position(1)+35 rangeLbl.SALbl2.Position(2) 50 22];
rangeField.SAField2.Value = 12;

rangeLbl.SALbl4 = uilabel(tabs.setup);
rangeLbl.SALbl4.Position = [rangeField.SAField2.Position(1)+65 rangeLbl.SALbl2.Position(2) 100 22];
rangeLbl.SALbl4.Text = 'No. Data Points';

rangeField.SAField3 = uieditfield(tabs.setup, 'numeric');
rangeField.SAField3.Position = [rangeLbl.SALbl4.Position(1)+100 rangeLbl.SALbl2.Position(2) 50 22];
rangeField.SAField3.Value = 30;

%-------------------------------------------------*
% Numeric Edit Field: Steering Angle Range Inputs |
%-------------------------------------------------*
rangeLbl.deltaLbl1 = uilabel(tabs.setup);
rangeLbl.deltaLbl1.Position = [labels.plot.Position(1) rangeField.SAField3.Position(2)-25 150 22];
rangeLbl.deltaLbl1.Text = 'Steering Angle (δ, deg)';

rangeLbl.deltaLbl2 = uilabel(tabs.setup);
rangeLbl.deltaLbl2.Position = [labels.plot.Position(1) rangeLbl.deltaLbl1.Position(2)-25 50 22];
rangeLbl.deltaLbl2.Text = 'From';

rangeField.deltaField1 = uieditfield(tabs.setup, 'numeric');
rangeField.deltaField1.Position = [labels.plot.Position(1)+35 rangeLbl.deltaLbl2.Position(2) 50 22];
rangeField.deltaField1.Value = -12;

rangeLbl.deltaLbl3 = uilabel(tabs.setup);
rangeLbl.deltaLbl3.Position = [rangeField.deltaField1.Position(1)+65 rangeLbl.deltaLbl2.Position(2) 50 22];
rangeLbl.deltaLbl3.Text = 'To';

rangeField.deltaField2 = uieditfield(tabs.setup, 'numeric');
rangeField.deltaField2.Position = [rangeLbl.deltaLbl3.Position(1)+35 rangeLbl.deltaLbl2.Position(2) 50 22];
rangeField.deltaField2.Value = 12;

rangeLbl.deltaLbl4 = uilabel(tabs.setup);
rangeLbl.deltaLbl4.Position = [rangeField.deltaField2.Position(1)+65 rangeLbl.deltaLbl2.Position(2) 100 22];
rangeLbl.deltaLbl4.Text = 'No. Data Points';

rangeField.deltaField3 = uieditfield(tabs.setup, 'numeric');
rangeField.deltaField3.Position = [rangeLbl.deltaLbl4.Position(1)+100 rangeLbl.deltaLbl2.Position(2) 50 22];
rangeField.deltaField3.Value = 30;

%---------------------------------------------*
% Numeric Edit Field: Slip Ratio Range Inputs |
%---------------------------------------------*
rangeLbl.SXLbl1 = uilabel(tabs.setup);
rangeLbl.SXLbl1.Position = [labels.plot.Position(1) rangeField.deltaField3.Position(2)-25 150 22];
rangeLbl.SXLbl1.Text = 'Slip Ratio (SX)';

rangeLbl.SXLbl2 = uilabel(tabs.setup);
rangeLbl.SXLbl2.Position = [labels.plot.Position(1) rangeLbl.SXLbl1.Position(2)-25 50 22];
rangeLbl.SXLbl2.Text = 'From';

rangeField.SXField1 = uieditfield(tabs.setup, 'numeric');
rangeField.SXField1.Position = [labels.plot.Position(1)+35 rangeLbl.SXLbl2.Position(2) 50 22];
rangeField.SXField1.Value = 0;
rangeField.SXField1.Limits = [-0.99 0.99];

rangeLbl.SXLbl3 = uilabel(tabs.setup);
rangeLbl.SXLbl3.Position = [rangeField.SXField1.Position(1)+65 rangeLbl.SXLbl2.Position(2) 50 22];
rangeLbl.SXLbl3.Text = 'To';

rangeField.SXField2 = uieditfield(tabs.setup, 'numeric');
rangeField.SXField2.Position = [rangeLbl.SXLbl3.Position(1)+35 rangeLbl.SXLbl2.Position(2) 50 22];
rangeField.SXField2.Value = 0;
rangeField.SXField2.Limits = [-0.99 0.99];

rangeLbl.SXLbl4 = uilabel(tabs.setup);
rangeLbl.SXLbl4.Position = [rangeField.SXField2.Position(1)+65 rangeLbl.SXLbl2.Position(2) 100 22];
rangeLbl.SXLbl4.Text = 'No. Data Points';

rangeField.SXField3 = uieditfield(tabs.setup, 'numeric');
rangeField.SXField3.Position = [rangeLbl.SXLbl4.Position(1)+100 rangeLbl.SXLbl2.Position(2) 50 22];
rangeField.SXField3.Value = 1;

%------------------------------*
% Push Button: Plot Parameters |
%------------------------------*
plotButton = uibutton(tabs.setup);
plotButton.Position = [labels.plot.Position(1) rangeLbl.SXLbl2.Position(2)-35 185 22];
plotButton.Text = 'Plot/Update with Current Inputs';
plotButton.ButtonPushedFcn = @(src, event) YMD_progress(1);

%% Data Tab: Make YMD Sweep Plot

labels.sweep = uilabel(tabs.setup);
labels.sweep.Position = [labels.plot.Position(1) plotButton.Position(2)-40 100 22];
labels.sweep.Text = '\fontname{Arial}\bfSweep YMD';
labels.sweep.Interpreter = 'tex';

%---------------------------------*
% Dropdown: Parameter to be Swept |
%---------------------------------*
sweptParamLbl = uilabel(tabs.setup);
sweptParamLbl.Position = [labels.plot.Position(1) labels.sweep.Position(2)-25 150 22];
sweptParamLbl.Text = 'Parameter to Sweep';

sweptParam = uidropdown(tabs.setup);
sweptParam.Position = [labels.plot.Position(1)+135 sweptParamLbl.Position(2) 215 22];
sweptParam.Items = ["Mass", "Front Weight Distribution [%]", "Wheelbase",...
    "Front Track Width", "Rear Track Width", "CG Height",...
    "Front Roll Center Height", "Rear Roll Center Height",...
    "Ackermann [%]", "Front Toe", "Rear Toe", "Tire Spring Rate",...
    "Front Spring Stiffness", "Rear Spring Stiffness",...
    "Front ARB Stiffness", "Rear ARB Stiffness",...
    "Coefficient of Lift", "Center of Pressure [%]", 'Velocity [mph]'];
sweptParam.ItemsData = 1: 19;

%----------------------------------------*
% Numeric Edit Field: Sweep Value Inputs |
%----------------------------------------*
sweepLbl.lbl1 = uilabel(tabs.setup);
sweepLbl.lbl1.Position = [labels.plot.Position(1) sweptParam.Position(2)-25 50 22];
sweepLbl.lbl1.Text = 'From';

sweepField.field1 = uieditfield(tabs.setup, 'numeric');
sweepField.field1.Position = [labels.plot.Position(1)+35 sweepLbl.lbl1.Position(2) 50 22];

sweepLbl.lbl2 = uilabel(tabs.setup);
sweepLbl.lbl2.Position = [sweepField.field1.Position(1)+65 sweepLbl.lbl1.Position(2) 50 22];
sweepLbl.lbl2.Text = 'To';

sweepField.field2 = uieditfield(tabs.setup, 'numeric');
sweepField.field2.Position = [sweepLbl.lbl2.Position(1)+35 sweepLbl.lbl1.Position(2) 50 22];

sweepLbl.lbl3 = uilabel(tabs.setup);
sweepLbl.lbl3.Position = [sweepField.field2.Position(1)+65 sweepLbl.lbl1.Position(2) 100 22];
sweepLbl.lbl3.Text = 'Number of Plots';

sweepField.field3 = uieditfield(tabs.setup, 'numeric');
sweepField.field3.Position = [sweepLbl.lbl3.Position(1)+100 sweepLbl.lbl1.Position(2) 50 22];

%--------------------*
% Push Button: Sweep |
%--------------------*
sweepButton = uibutton(tabs.setup);
sweepButton.Position = [labels.plot.Position(1) sweepField.field3.Position(2)-35 185 22];
sweepButton.Text = 'Sweep Over Selected Parameter';
sweepButton.ButtonPushedFcn = @(src, event) YMD_progress(2);

%% Data Tab: Make GGV Diagram

labels.GGV = uilabel(tabs.setup);
labels.GGV.Position = [labels.plot.Position(1) sweepButton.Position(2)-40 100 22];
labels.GGV.Text = '\fontname{Arial}\bfGGV Diagram';
labels.GGV.Interpreter = 'tex';

%-------------------------------------------*
% Numeric Edit Field: Velocity Range Inputs |
%-------------------------------------------*

VLbl.lbl1 = uilabel(tabs.setup);
VLbl.lbl1.Position = [labels.plot.Position(1) labels.GGV.Position(2)-25 150 22];
VLbl.lbl1.Text = 'Velocity [mph]';

VLbl.lbl2 = uilabel(tabs.setup);
VLbl.lbl2.Position = [labels.plot.Position(1) VLbl.lbl1.Position(2)-25 50 22];
VLbl.lbl2.Text = 'From';

VField.field1 = uieditfield(tabs.setup, 'numeric');
VField.field1.Position = [labels.plot.Position(1)+35 VLbl.lbl2.Position(2) 50 22];

VLbl.lbl3 = uilabel(tabs.setup);
VLbl.lbl3.Position = [VField.field1.Position(1)+65 VLbl.lbl2.Position(2) 50 22];
VLbl.lbl3.Text = 'To';

VField.field2 = uieditfield(tabs.setup, 'numeric');
VField.field2.Position = [VLbl.lbl3.Position(1)+35 VLbl.lbl2.Position(2) 50 22];

VLbl.lbl4 = uilabel(tabs.setup);
VLbl.lbl4.Position = [VField.field2.Position(1)+65 VLbl.lbl2.Position(2) 100 22];
VLbl.lbl4.Text = 'Number of Plots';

VField.field3 = uieditfield(tabs.setup, 'numeric');
VField.field3.Position = [VLbl.lbl4.Position(1)+100 VLbl.lbl2.Position(2) 50 22];

%-------------------------------*
% Push Button: Plot GGV Diagram |
%-------------------------------*
GGVButton = uibutton(tabs.setup);
GGVButton.Position = [labels.plot.Position(1) VField.field3.Position(2)-35 185 22];
GGVButton.Text = 'Make GGV Diagram';
GGVButton.ButtonPushedFcn = @(src, event) YMD_progress(7);

%% Single Plot Tab: Plot Area

% UI panel: YMD plot area
panels.YMDPlotArea = uipanel(tabs.YMD);
panels.YMDPlotArea.Position = [75 200 700 500];
panels.YMDPlotArea.BackgroundColor = 'white';

% UI axes: YMD plot axes
YMDAxes = uiaxes(panels.YMDPlotArea, 'Position', [25 25 650 450]);

%% Single Plot Tab: Plot Adjustments

%---------------------------------*
% Dropdown List: Adjust Plot View |
%---------------------------------*
labels.plotView = uilabel(tabs.YMD);
labels.plotView.Position = [100 150 100 22];
labels.plotView.Text = '\fontname{Arial}\bfPlot View';
labels.plotView.Interpreter = 'tex';

viewSelect = uidropdown(tabs.YMD);
viewSelect.Position = [labels.plotView.Position(1) labels.plotView.Position(2)-25 150 22];
viewSelect.Items = ["XY (Classic YMD)", "XZ (Friction Ellipse)", "YZ", "Isometric"];
viewSelect.ValueChangedFcn = @(src, event) YMD_progress(3);

%------------------------------------------------*
% Checkbox: Hide/Show Slip Angle Variation Lines |
%------------------------------------------------*
lineSelect.SALine = uicheckbox(tabs.YMD);
lineSelect.SALine.Position = [labels.plotView.Position(1) viewSelect.Position(2)-25 250 22];
lineSelect.SALine.Text = 'Show Slip Angle Variation Lines';
lineSelect.SALine.Value = 1;
lineSelect.SALine.ValueChangedFcn = @(src, event) YMD_progress(4);

%----------------------------------------------------*
% Checkbox: Hide/Show Steering Angle Variation Lines |
%----------------------------------------------------*
lineSelect.deltaLine = uicheckbox(tabs.YMD);
lineSelect.deltaLine.Position = [labels.plotView.Position(1) lineSelect.SALine.Position(2)-25 250 22];
lineSelect.deltaLine.Text = 'Show Steering Angle Variation Lines';
lineSelect.deltaLine.Value = 1;
lineSelect.deltaLine.ValueChangedFcn = @(src, event) YMD_progress(4);

%------------------------------------------------*
% Checkbox: Hide/Show Slip Ratio Variation Lines |
%------------------------------------------------*
lineSelect.SXLine = uicheckbox(tabs.YMD);
lineSelect.SXLine.Position = [labels.plotView.Position(1) lineSelect.deltaLine.Position(2)-25 250 22];
lineSelect.SXLine.Text = 'Show Slip Ratio Variation Lines';
lineSelect.SXLine.Value = 1;
lineSelect.SXLine.ValueChangedFcn = @(src, event) YMD_progress(4);

%% Single Plot Tab: Export Data & Figure

% UI label: heading (export)
labels.export = uilabel(tabs.YMD);
labels.export.Position = [400 150 100 22];
labels.export.Text = '\fontname{Arial}\bfExport';
labels.export.Interpreter = 'tex';

% UI edit field: export data file name
editFields.export_field1 = uieditfield(tabs.YMD);
editFields.export_field1.Position = [labels.export.Position(1) labels.export.Position(2)-35 165 22];
editFields.export_field1.Value = 'YMD_singlePlot';
editFields.export_field1.HorizontalAlignment = 'right';

% UI label: export data file format
labels.export_lbl1 = uilabel(tabs.YMD);
labels.export_lbl1.Position = [editFields.export_field1.Position(1)+170 editFields.export_field1.Position(2) 30 22];
labels.export_lbl1.Text = '.mat';

% UI button: export data file
buttons.exportData = uibutton(tabs.YMD);
buttons.exportData.Position = [labels.export_lbl1.Position(1)+35 editFields.export_field1.Position(2) 150 22];
buttons.exportData.Text = 'Export Data File';
buttons.exportData.ButtonPushedFcn = @(src, event) YMD_progress(61);

% UI edit field: export figure name
editFields.export_field2 = uieditfield(tabs.YMD);
editFields.export_field2.Position = [labels.export.Position(1) buttons.exportData.Position(2)-35 165 22];
editFields.export_field2.Value = 'YMD_singlePlot';
editFields.export_field2.HorizontalAlignment = 'right';

% UI label: export figure format
labels.export_lbl2 = uilabel(tabs.YMD);
labels.export_lbl2.Position = [editFields.export_field2.Position(1)+170 buttons.exportData.Position(2)-35 30 22];
labels.export_lbl2.Text = '.jpg';

% UI button: export figure
buttons.exportFig = uibutton(tabs.YMD);
buttons.exportFig.Position = [labels.export_lbl2.Position(1)+35 editFields.export_field2.Position(2) 150 22];
buttons.exportFig.Text = 'Export Figure';
buttons.exportFig.ButtonPushedFcn = @(src, event) YMD_progress(62);

%% YMD Sweep Tab: Plot Area

% UI panel: YMD sweep plot area
panels.YMDSweepArea = uipanel(tabs.YMDSweep);
panels.YMDSweepArea.Position = [75 200 700 500];
panels.YMDSweepArea.BackgroundColor = 'white';

% UI axes: YMD sweep plot axes
YMDSweepAxes = uiaxes(panels.YMDSweepArea, 'Position', [25 25 650 450]);

%% YMD Sweep Tab: Plot Adjustments

% UI label: Plot adjustments
labels.sweepPlotAdjustments = uilabel(tabs.YMDSweep);
labels.sweepPlotAdjustments.Position = [100 150 150 22];
labels.sweepPlotAdjustments.Text = '\fontname{Arial}\bfPlot Adjustments';
labels.sweepPlotAdjustments.Interpreter = 'tex';

% UI label: Swept parameter
labels.sweptParam = uilabel(tabs.YMDSweep);
labels.sweptParam.Position = [labels.sweepPlotAdjustments.Position(1) labels.sweepPlotAdjustments.Position(2)-35 150 22];
labels.sweptParam.Text = 'Swept Parameter';

% UI label: Swept parameter name
labels.sweptParamName = uilabel(tabs.YMDSweep);
labels.sweptParamName.Position = [labels.sweptParam.Position(1)+170 labels.sweptParam.Position(2) 200 22];
labels.sweptParamName.Text = '';

% UI label: Highlighted plot
labels.highlightedPlot = uilabel(tabs.YMDSweep);
labels.highlightedPlot.Position = [labels.sweepPlotAdjustments.Position(1) labels.sweptParam.Position(2)-35 150 22];
labels.highlightedPlot.Text = 'Highlighted Plot';

% UI dropdown list: Highlighted plot number
dropdownLists.highlightedPlotNo = uidropdown(tabs.YMDSweep);
dropdownLists.highlightedPlotNo.Position = [labels.highlightedPlot.Position(1)+170 labels.highlightedPlot.Position(2) 100 22];
dropdownLists.highlightedPlotNo.ValueChangedFcn = @(src, event) YMD_progress(5);

%% YMD Sweep Tab: Export Data & Figure

% UI label: export (sweep data)
labels.exportSweep = uilabel(tabs.YMDSweep);
labels.exportSweep.Position = [400 150 100 22];
labels.exportSweep.Text = '\fontname{Arial}\bfExport';
labels.exportSweep.Interpreter = 'tex';

% UI edit field: export data file name
editFields.exportSweepDataName = uieditfield(tabs.YMDSweep);
editFields.exportSweepDataName.Position = [labels.exportSweep.Position(1) labels.exportSweep.Position(2)-35 165 22];
editFields.exportSweepDataName.Value = 'YMD_sweepPlots';
editFields.exportSweepDataName.HorizontalAlignment = 'right';

% UI label: export data file format
labels.exportSweepDataFormat = uilabel(tabs.YMDSweep);
labels.exportSweepDataFormat.Position = [labels.exportSweep.Position(1)+170 editFields.exportSweepDataName.Position(2) 165 22];
labels.exportSweepDataFormat.Text = '.mat';

% UI button: export data file
buttons.exportSweepData = uibutton(tabs.YMDSweep);
buttons.exportSweepData.Position = [labels.exportSweepDataFormat.Position(1)+35 editFields.exportSweepDataName.Position(2) 150 22];
buttons.exportSweepData.Text = 'Export Data File';
buttons.exportSweepData.ButtonPushedFcn = @(src, event) YMD_progress(63);

% UI edit field: export figure name
editFields.exportSweepFigName = uieditfield(tabs.YMDSweep);
editFields.exportSweepFigName.Position = [labels.exportSweep.Position(1) editFields.exportSweepDataName.Position(2)-35 165 22];
editFields.exportSweepFigName.Value = 'YMD_sweepPlot';
editFields.exportSweepFigName.HorizontalAlignment = 'right';

% UI label: export figure format
labels.exportSweepFigFormat = uilabel(tabs.YMDSweep);
labels.exportSweepFigFormat.Position = [editFields.exportSweepFigName.Position(1)+170 editFields.exportSweepFigName.Position(2) 30 22];
labels.exportSweepFigFormat.Text = '.jpg';

% UI button: export figure
buttons.exportSweepFig = uibutton(tabs.YMDSweep);
buttons.exportSweepFig.Position = [buttons.exportSweepData.Position(1) editFields.exportSweepFigName.Position(2) 150 22];
buttons.exportSweepFig.Text = 'Export Figure';
buttons.exportSweepFig.ButtonPushedFcn = @(src, event) YMD_progress(64);

%% GGV Tab: Plot Area

% UI panel: YMD sweep plot area
panels.GGVArea = uipanel(tabs.GGV);
panels.GGVArea.Position = [75 200 700 500];
panels.GGVArea.BackgroundColor = 'white';

% UI axes: YMD sweep plot axes
GGVAxes = uiaxes(panels.GGVArea, 'Position', [25 25 650 450]);

%% GGV Tab: Export Data & Figure

% UI label: export (GGV)
labels.exportGGV = uilabel(tabs.GGV);
labels.exportGGV.Position = [400 150 100 22];
labels.exportGGV.Text = '\fontname{Arial}\bfExport';
labels.exportGGV.Interpreter = 'tex';

% UI edit field: export data file name
editFields.exportGGVDataName = uieditfield(tabs.GGV);
editFields.exportGGVDataName.Position = [labels.exportGGV.Position(1) labels.exportGGV.Position(2)-35 165 22];
editFields.exportGGVDataName.Value = 'GGVPlot';
editFields.exportGGVDataName.HorizontalAlignment = 'right';

% UI label: export data file format
labels.exportGGVDataFormat = uilabel(tabs.GGV);
labels.exportGGVDataFormat.Position = [labels.exportGGV.Position(1)+170 editFields.exportGGVDataName.Position(2) 165 22];
labels.exportGGVDataFormat.Text = '.mat';

% UI button: export data file
buttons.exportGGVData = uibutton(tabs.GGV);
buttons.exportGGVData.Position = [labels.exportGGVDataFormat.Position(1)+35 editFields.exportGGVDataName.Position(2) 150 22];
buttons.exportGGVData.Text = 'Export Data File';
buttons.exportGGVData.ButtonPushedFcn = @(src, event) YMD_progress(65);

% UI edit field: export figure name
editFields.exportGGVFigName = uieditfield(tabs.GGV);
editFields.exportGGVFigName.Position = [labels.exportGGV.Position(1) editFields.exportGGVDataName.Position(2)-35 165 22];
editFields.exportGGVFigName.Value = 'GGVPlot';
editFields.exportGGVFigName.HorizontalAlignment = 'right';

% UI label: export figure format
labels.exportGGVFigFormat = uilabel(tabs.GGV);
labels.exportGGVFigFormat.Position = [editFields.exportGGVFigName.Position(1)+170 editFields.exportGGVFigName.Position(2) 30 22];
labels.exportGGVFigFormat.Text = '.jpg';

% UI button: export figure
buttons.exportGGVFig = uibutton(tabs.GGV);
buttons.exportGGVFig.Position = [buttons.exportGGVData.Position(1) editFields.exportGGVFigName.Position(2) 150 22];
buttons.exportGGVFig.Text = 'Export Figure';
buttons.exportGGVFig.ButtonPushedFcn = @(src, event) YMD_progress(66);