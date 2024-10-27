%% Yaw Moment Diagram: Post Processor

%% Clear

clear, clc, close all;

%% Swept Parameter Names (Keep Commented)

% 1.  Mass
% 2.  Front Weight Distribution
% 3.  Wheelbase
% 4.  Front Track Width
% 5.  Rear Track Width
% 6.  CG Height
% 7.  Front Roll Center Height
% 8.  Rear Roll Center Height
% 9.  Ackermann
% 10. Front Toe
% 11. Rear Toe
% 12. Tire Spring Rate
% 13. Front Spring Stiffness
% 14. Rear Spring Stiffness
% 15. Front ARB Stiffness
% 16. Rear ARB Stiffness
% 17. Coefficient of Lift
% 18. Front Center of Pressure

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

% Sheet numbers for selected parameters
sheetNoList = [1 2 6 10 10 11 11 13];
opts = detectImportOptions("YMDDataTable.xlsx");

% Yaw moment @ grip
YMG_RefIndexes = [6 6 8 9 9  9 9  5];
YMG_CmpIndexes = [1 4 1 1 17 1 17 1];
YMG_paramDiff = zeros(1, length(sheetNoList));
YMG_diff = zeros(1, length(sheetNoList));
YMG_barLabels = cell(1, length(sheetNoList));

% Yaw moment @ basis point
YMB_RefIndexes = [6 6 8 9 9  9 9  5];
YMB_CmpIndexes = [1 1 1 1 17 1 17 1];
YMB_paramDiff = zeros(1, length(sheetNoList));
YMB_diff = zeros(1, length(sheetNoList));
YMB_barLabels = cell(1, length(sheetNoList));

% Stability @ basis point
stb_RefIndexes = [6 6 8 9 9  9 9  5];
stb_CmpIndexes = [1 1 1 1 17 1 17 1];
stb_paramDiff = zeros(1, length(sheetNoList));
stb_diff = zeros(1, length(sheetNoList));
stb_barLabels = cell(1, length(sheetNoList));

% Control @ basis point
ctrl_RefIndexes = [6 6 8 9 9  9 9  5];
ctrl_CmpIndexes = [1 1 1 1 17 1 17 1];
ctrl_paramDiff = zeros(1, length(sheetNoList));
ctrl_diff = zeros(1, length(sheetNoList));
ctrl_barLabels = cell(1, length(sheetNoList));

%% Generate Bar Chart Data

for i = 1: length(sheetNoList)

    sheetNo = sheetNoList(i);
    
    opts.Sheet = sheetNo;
    T = readtable("YMDDataTable_40mph.xlsx", opts, 'ReadVariableNames',false);
    sweptParam = table2array(T(:, 4));
    
    % Indexes for each tiled plot
    YMG_RefIndex = YMG_RefIndexes(i);
    YMG_CmpIndex = YMG_CmpIndexes(i);
    YMB_RefIndex = YMB_RefIndexes(i);
    YMB_CmpIndex = YMB_CmpIndexes(i);
    stb_RefIndex = stb_RefIndexes(i);
    stb_CmpIndex = stb_CmpIndexes(i);
    ctrl_RefIndex = ctrl_RefIndexes(i);
    ctrl_CmpIndex = ctrl_CmpIndexes(i);

    % Velocity, slip angle, and steering angle
    V_mph = table2array(T(9, 2));
    basis3_beta = table2array(T(24, 2));
    basis3_delta = table2array(T(25, 2));

    % Switch Table for Swept Parameter
    switch(sheetNo)
    
        case(1)
            paramName = 'Mass'; 
            paramUnit = ' [lb]';
            diffType = 'percentage';
        case(2)
            paramName = 'Front Weight Distribution';
            paramUnit = ' [%]';
            diffType = 'percentage';
        case(3) 
            paramName = 'Wheelbase';
            paramUnit = ' [in]';
            diffType = 'percentage';
        case(4) 
            paramName = 'Front Track Width';
            paramUnit = ' [in]';
            diffType = 'percentage';
        case(5) 
            paramName = 'Rear Track Width';
            paramUnit = ' [in]';
            diffType = 'percentage';
        case(6) 
            paramName = 'CG Height'; 
            paramUnit = ' [in]';
            diffType = 'percentage';
        case(7) 
            paramName = 'Front Roll Center Height';
            paramUnit = ' [in]';
            diffType = 'percentage';
        case(8) 
            paramName = 'Rear Roll Center Height';
            paramUnit = ' [in]';
            diffType = 'percentage';
        case(9) 
            paramName = 'Ackermann';
            paramUnit = ' [%]';
            diffType = 'percentage';
        case(10) 
            paramName = 'Front Toe';
            paramUnit = ' [deg]';
            diffType = 'absolute';
        case(11) 
            paramName = 'Rear Toe';
            paramUnit = ' [deg]';
            diffType = 'absolute';
        case(12)
            paramName = 'Tire Spring Rate';
            paramUnit = ' [lb/in]';
            diffType = 'percentage';
        case(13)
            paramName = 'Front Spring Stiffness';
            paramUnit = ' [lb/in]';
            diffType = 'absolute';
        case(14)
            paramName = 'Rear Spring Stiffness';
            paramUnit = ' [lb/in]';
            diffType = 'percentage';
        case(15)
            paramName = 'Front ARB Stiffness';
            paramUnit = ' [lb/in]';
            diffType = 'percentage';
        case(16)
            paramName = 'Rear ARB Stiffness';
            paramUnit = ' [lb/in]';
            diffType = 'percentage';
        case(17) 
            paramName = 'Coefficient of Lift';
            paramUnit = '';
            diffType = 'percentage';
        case(18) 
            paramName = 'Front Center of Pressure';
            paramUnit = ' [%]';
            diffType = 'percentage';
    
    end

    %----------------------*
    % 1) Yaw moment @ grip |
    %----------------------*
    leftGrip_YM = table2array(T(:, 6));
    rightGrip_YM = table2array(T(:, 8));
    absAvgGrip_YM = (abs(leftGrip_YM) + abs(rightGrip_YM))/2;

    % Difference in swept parameter
    if strcmp(diffType, 'absolute')

        YMG_paramDiff(i) = table2array(T(YMG_CmpIndex, 4)) - table2array(T(YMG_RefIndex, 4));
        paramDiffText = horzcat(num2str(YMG_paramDiff(i)), paramUnit);

    elseif strcmp(diffType, 'percentage')

        YMG_paramDiff(i) = (table2array(T(YMG_CmpIndex, 4)) - table2array(T(YMG_RefIndex, 4)))*100/table2array(T(YMG_RefIndex, 4));
        paramDiffText = horzcat(num2str(YMG_paramDiff(i)), '%');

    end

    if YMG_paramDiff(i) > 0
    
        YMG_paramDiffText = horzcat(' +', paramDiffText);
    
    else
    
        YMG_paramDiffText = horzcat(' ', paramDiffText);
    
    end

    % Percent difference in yaw moment
    YMG_diff(i) = (absAvgGrip_YM(YMG_CmpIndex) - absAvgGrip_YM(YMG_RefIndex))*100/absAvgGrip_YM(YMG_RefIndex);
    
    % Bar chart label
    YMG_barLabels{i} = horzcat(paramName, YMG_paramDiffText);

    %-----------------------------*
    % 2) Yaw moment @ basis point |
    %-----------------------------*
    basis3_YM = table2array(T(:, 24));
    
    % Difference in swept parameter
    if strcmp(diffType, 'absolute')

        YMB_paramDiff(i) = table2array(T(YMB_CmpIndex, 4)) - table2array(T(YMB_RefIndex, 4));
        paramDiffText = horzcat(num2str(YMB_paramDiff(i)), paramUnit);

    elseif strcmp(diffType, 'percentage')

        YMB_paramDiff(i) = (table2array(T(YMB_CmpIndex, 4)) - table2array(T(YMB_RefIndex, 4)))*100/table2array(T(YMB_RefIndex, 4));
        paramDiffText = horzcat(num2str(YMB_paramDiff(i)), '%');

    end

    if YMB_paramDiff(i) > 0
    
        YMB_paramDiffText = horzcat(' +', paramDiffText);
           
    else
    
        YMB_paramDiffText = horzcat(' ', paramDiffText);
    
    end

    % Percent difference in yaw moment
    YMB_diff(i) = (basis3_YM(YMB_CmpIndex) - basis3_YM(YMB_RefIndex))*100/basis3_YM(YMB_RefIndex);
    
    % Bar chart label
    YMB_barLabels{i} = horzcat(paramName, YMB_paramDiffText);

    %----------------------------*
    % 3) Stability @ basis point |
    %----------------------------*
    basis3_leftStb = table2array(T(:, 25));
    basis3_rightStb = table2array(T(:, 26));
    basis3_avgStb = (basis3_leftStb + basis3_rightStb)/2;
    
    % Difference in swept parameter
    if strcmp(diffType, 'absolute')

        stb_paramDiff(i) = table2array(T(stb_CmpIndex, 4)) - table2array(T(stb_RefIndex, 4));
        paramDiffText = horzcat(num2str(stb_paramDiff(i)), paramUnit);

    elseif strcmp(diffType, 'percentage')

        stb_paramDiff(i) = (table2array(T(stb_CmpIndex, 4)) - table2array(T(stb_RefIndex, 4)))*100/table2array(T(stb_RefIndex, 4));
        paramDiffText = horzcat(num2str(stb_paramDiff(i)), '%');

    end

    if stb_paramDiff(i) > 0
    
        stb_paramDiffText = horzcat(' +', paramDiffText);
    
    else
    
        stb_paramDiffText = horzcat(' ', paramDiffText);
    
    end

    % Percent difference in stability
    stb_diff(i) = (basis3_avgStb(stb_CmpIndex) - basis3_avgStb(stb_RefIndex))*100/basis3_avgStb(stb_RefIndex);
    
    % Bar chart label
    stb_barLabels{i} = horzcat(paramName, stb_paramDiffText);

    %--------------------------*
    % 4) Control @ basis point |
    %--------------------------*
    basis3_upperCtrl = table2array(T(:, 27));
    basis3_lowerCtrl = table2array(T(:, 28));
    basis3_avgCtrl = (basis3_upperCtrl + basis3_lowerCtrl)/2;
    
    % Difference in swept parameter
    if strcmp(diffType, 'absolute')

        ctrl_paramDiff(i) = table2array(T(ctrl_CmpIndex, 4)) - table2array(T(ctrl_RefIndex, 4));
        paramDiffText = horzcat(num2str(ctrl_paramDiff(i)), paramUnit);

    elseif strcmp(diffType, 'percentage')

        ctrl_paramDiff(i) = (table2array(T(ctrl_CmpIndex, 4)) - table2array(T(ctrl_RefIndex, 4)))*100/table2array(T(ctrl_RefIndex, 4));
        paramDiffText = horzcat(num2str(ctrl_paramDiff(i)), '%');

    end

    if ctrl_paramDiff(i) > 0
    
        ctrl_paramDiffText = horzcat(' +', paramDiffText);
    
    else
    
        ctrl_paramDiffText = horzcat(' ', paramDiffText);      
    
    end

    % Percent difference in control
    ctrl_diff(i) = (basis3_avgCtrl(ctrl_CmpIndex) - basis3_avgCtrl(ctrl_RefIndex))*100/basis3_avgCtrl(ctrl_RefIndex);
    
    % Bar chart label
    ctrl_barLabels{i} = horzcat(paramName, ctrl_paramDiffText);

end

% Sort and rearrange bars
YMG_barLabelsSorted = cell(1, length(sheetNoList));
YMB_barLabelsSorted = cell(1, length(sheetNoList));
stb_barLabelsSorted = cell(1, length(sheetNoList));
ctrl_barLabelsSorted = cell(1, length(sheetNoList));

[YMG_diffSorted, YMG_sortedIndex] = sort(YMG_diff, 'descend');
[YMB_diffSorted, YMB_sortedIndex] = sort(YMB_diff, 'descend');
[stb_diffSorted, stb_sortedIndex] = sort(stb_diff, 'descend');
[ctrl_diffSorted, ctrl_sortedIndex] = sort(ctrl_diff, 'descend');

for j = 1: length(sheetNoList)

    YMG_barLabelsSorted{j} = YMG_barLabels{YMG_sortedIndex(j)};
    YMB_barLabelsSorted{j} = YMB_barLabels{YMB_sortedIndex(j)};
    stb_barLabelsSorted{j} = stb_barLabels{stb_sortedIndex(j)};
    ctrl_barLabelsSorted{j} = ctrl_barLabels{ctrl_sortedIndex(j)};

end

%% Display Bar Chart

figure(1);
tiledlayout(2, 2);
sgtitle_text = compose('Vehicle Sensitivity @ %d [mph]\nBasis: β = %.1f [deg], δ = %.1f [deg]', V_mph, basis3_beta, basis3_delta);
sgtitle(sgtitle_text);

nexttile,
bar(YMG_barLabelsSorted, YMG_diffSorted);
hold on;
grid on;
ylabel('% Difference');
title('Yaw Moment @ Grip');

nexttile,
bar(YMB_barLabelsSorted, YMB_diffSorted);
hold on;
grid on;
ylabel('% Difference');
title('Yaw Moment @ Basis');

nexttile,
bar(stb_barLabelsSorted, stb_diffSorted);
hold on;
grid on;
ylabel('% Difference');
title('Stability @ Basis');

nexttile,
bar(ctrl_barLabelsSorted, ctrl_diffSorted);
hold on;
grid on;
ylabel('% Difference');
title('Control @ Basis');
