%% Yaw Moment Diagram: Post Processor (Refactored)
% This script loads YMD sweep data, performs various analyses on vehicle
% balance and control, and generates summary plots.

%% --- Configuration & Setup ---
% clear; clc; close all;

% Add paths
cd ..; % Assuming the script is in a subfolder
addpath('YMD Sweep Results');
addpath('YMD (v6.2)'); % For GetPolyLineIntersection

% --- Files to Load ---
% Add the .mat files from your YMD sweep runs here.
datafiles = {
    'YMD Sweep Results/20mph_cop_sweep.mat';
    'YMD Sweep Results/40mph_cop_sweep.mat';
    'YMD Sweep Results/60mph_cop_sweep.mat'
};

% --- Corresponding Plot Names ---
datanames = {
    '20 mph';
    '40 mph';
    '60 mph'
};


% --- Basis Point Definition ---
basis.SA = 4;    % Body Slip Angle [deg]
basis.Delta = 4; % Steering Angle [deg]
basis.SX = 0;    % Longitudinal Slip Ratio

%% --- Data Loading and Initialization ---
% Load all specified data files into a structured array.
for i = 1:length(datafiles)
    data(i) = load(datafiles{i});
end

datasize = length(data);

% Extract sweep information from the first data file (assumed consistent)
sweepVarName = data(1).sweptParameter.name;
sweepVarValue = data(1).sweptParameter.value;
sweepVarRange = length(sweepVarValue);

fprintf('Processing %d datasets sweeping "%s".\n', datasize, sweepVarName);

%% --- Analysis 1: Grip Limit Behavior ---
% Find the yaw moment at the maximum lateral acceleration limits. This
% tells us the vehicle's handling balance (understeer/oversteer) at the
% absolute limit of grip.

% Pre-allocate memory for results
grip.Ay_left = zeros(datasize, sweepVarRange);
grip.Ay_right = zeros(datasize, sweepVarRange);
grip.M_left = zeros(datasize, sweepVarRange);
grip.M_right = zeros(datasize, sweepVarRange);

for i = 1:datasize
    for j = 1:sweepVarRange
        Ayi = data(i).Ay(:, :, :, j);
        Mi = data(i).M(:, :, :, j);
        

        [min_Ay, idx_left] = min(Ayi, [], 'all', 'linear');
        [max_Ay, idx_right] = max(Ayi, [], 'all', 'linear');
        
        grip.Ay_left(i, j) = min_Ay;
        grip.M_left(i, j) = Mi(idx_left);
        
        grip.Ay_right(i, j) = max_Ay;
        grip.M_right(i, j) = Mi(idx_right);
    end
end

% Calculate more meaningful combined metrics
grip.Ay_absAvg = (abs(grip.Ay_left) + abs(grip.Ay_right)) / 2;
grip.M_asymmetry = grip.M_left + grip.M_right; % Should be ~0 for symmetric balance
grip.M_balance_magnitude = (abs(grip.M_left) + abs(grip.M_right)) / 2; % Avg magnitude of balance


%% --- Analysis 2: Steady-State Limit Balance ---
% Find the maximum lateral G the car can achieve in a steady-state turn
% (where the inherent yaw moment is zero).

% Pre-allocate
limitBalance.Ay_left = zeros(datasize, sweepVarRange);
limitBalance.Ay_right = zeros(datasize, sweepVarRange);

for i = 1:datasize
    for j = 1:sweepVarRange
        intersections = [];
        % Iterate through each body slip angle isoline to find its
        % intersection with the Mz = 0 axis.
        for k = 1:size(data(i).Ay, 1)
            SA_isoline_x = data(i).Ay(k, :, :, j);
            SA_isoline_y = data(i).M(k, :, :, j);
            
            % Reshape to a 2xN array for the intersection function
            SA_isoline = [SA_isoline_x(:)'; SA_isoline_y(:)'];
            M0_line = [-10 10; 0 0]; % A long horizontal line at Mz = 0
            
            [~, intersection_points] = GetPolyLineIntersection(SA_isoline, M0_line);
            if ~isempty(intersection_points)
                intersections = [intersections; intersection_points'];
            end
        end
        
        % The limit balance is the min/max of all found intersection points
        if ~isempty(intersections)
            limitBalance.Ay_left(i, j) = min(intersections(:, 1));
            limitBalance.Ay_right(i, j) = max(intersections(:, 1));
        end
    end
end
% Corrected calculation for average absolute G
limitBalance.Ay_absAvg = (abs(limitBalance.Ay_left) + abs(limitBalance.Ay_right)) / 2;


%% --- Analysis 3: Local Behavior @ Basis Point ---
% Analyze the vehicle's stability (dMz/dSA) and control (dMz/dDelta)
% by calculating numerical gradients around a defined basis point.

% Pre-allocate
basis.Ay = zeros(datasize, sweepVarRange);
basis.M = zeros(datasize, sweepVarRange);
stability.average = zeros(datasize, sweepVarRange);
control.average = zeros(datasize, sweepVarRange);

for i = 1:datasize
    % Find the nearest indices for the basis point for THIS dataset
    [~, sa_idx] = min(abs(data(i).SA - basis.SA));
    [~, delta_idx] = min(abs(data(i).Delta - basis.Delta));
    [~, sx_idx] = min(abs(data(i).SX - basis.SX));
    
    % Check for edge cases to prevent index out of bounds errors
    if sa_idx == 1 || sa_idx == length(data(i).SA) || delta_idx == 1 || delta_idx == length(data(i).Delta)
        warning('Basis point is at the edge of the data grid for dataset %d. Stability/Control results may be inaccurate.', i);
        continue; % Skip stability/control calculation for this dataset
    end
    
    for j = 1:sweepVarRange
        % Extract Ay and Mz at the basis point
        basis.Ay(i, j) = data(i).Ay(sa_idx, delta_idx, sx_idx, j);
        basis.M(i, j) = data(i).M(sa_idx, delta_idx, sx_idx, j);
        
        % --- Stability (dMz/dSA) ---
        Mz_sa_minus = data(i).M(sa_idx-1, delta_idx, sx_idx, j);
        Mz_sa_plus = data(i).M(sa_idx+1, delta_idx, sx_idx, j);
        dSA = data(i).SA(sa_idx+1) - data(i).SA(sa_idx-1);
        stability.average(i, j) = (Mz_sa_plus - Mz_sa_minus) / dSA;
        
        % --- Control (dMz/dDelta) ---
        Mz_delta_minus = data(i).M(sa_idx, delta_idx-1, sx_idx, j);
        Mz_delta_plus = data(i).M(sa_idx, delta_idx+1, sx_idx, j);
        dDelta = data(i).Delta(delta_idx+1) - data(i).Delta(delta_idx-1);
        control.average(i, j) = (Mz_delta_plus - Mz_delta_minus) / dDelta;
    end
end


%% --- Plotting ---

% SUMMARY PLOTS
figure('Name', 'Analysis Summary Plots');
tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
% FIX: Use the predefined datanames for the legend
legend_labels = datanames;

% Plot: Vehicle Balance at Grip Limit
nexttile; hold on; grid on;
plot(sweepVarValue, grip.M_right, '-o', 'LineWidth', 1.5);
xlabel(sweepVarName);
ylabel('Yaw Moment @ Left Grip Limit [lb*ft]');
title('Yaw Moment at Grip Limit');
legend(legend_labels, 'Location', 'best', 'Interpreter', 'none');
yline(0, 'k--', 'HandleVisibility', 'off');

% FIX: Zoom in on the data by setting dynamic Y-limits
min_val = min(grip.M_right, [], 'all');
max_val = max(grip.M_right, [], 'all');
buffer = (max_val - min_val) * 0.1; % 10% buffer
if buffer == 0; buffer = 1; end % Add a small buffer if all values are the same
ylim([min_val - buffer, max_val + buffer]);


% Plot: Steady-State Grip Limit
nexttile; hold on; grid on;
plot(sweepVarValue, limitBalance.Ay_absAvg, '-o', 'LineWidth', 1.5);
xlabel(sweepVarName);
ylabel('Avg. Abs. Lateral Accel. [G]');
title('Steady-State Grip Limit (at Mz=0)');
legend(legend_labels, 'Location', 'best', 'Interpreter', 'none');

% Plot: Stability @ Basis
nexttile; hold on; grid on;
plot(sweepVarValue, stability.average, '-o', 'LineWidth', 1.5);
xlabel(sweepVarName);
ylabel('Stability (dMz/dSA) [lb*ft/deg]');
title(sprintf('Stability @ SA=%.1f, Delta=%.1f', basis.SA, basis.Delta));
legend(legend_labels, 'Location', 'best', 'Interpreter', 'none');
% FIX: Hide the yline from the legend to remove the rogue "data1" entry
yline(0, 'k--', 'HandleVisibility', 'off'); % Stability boundary

% Plot: Control @ Basis
nexttile; hold on; grid on;
plot(sweepVarValue, control.average, '-o', 'LineWidth', 1.5);
xlabel(sweepVarName);
ylabel('Control (dMz/dDelta) [lb*ft/deg]');
title(sprintf('Control @ SA=%.1f, Delta=%.1f', basis.SA, basis.Delta));
legend(legend_labels, 'Location', 'best', 'Interpreter', 'none');







