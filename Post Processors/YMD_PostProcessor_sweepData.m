%% Yaw Moment Diagram: Post Processor

%% Clear

clear, clc, close all;

%% Load Data

cd ..
addpath('YMD Sweep Results');

%data(1) = load('YMD Sweep Results/YMD_sweepCoP_20mph_FARB500.mat');
data(1) = load('YMD Sweep Results/YMD_sweepCoP_40mph_expanded.mat');
%data(3) = load('YMD Sweep Results/YMD_sweepCoP_60mph_FARB500.mat');

% Number of data sets
datasize = length(data);

%% Sweep Information

sweepVarName = data(1).sweptParameter.name; % Sweep parameter name
sweepVarValue = data(1).sweptParameter.value; % Sweep parameter value
sweepVarRange = length(data(1).sweptParameter.value); % # Sweep parameter range

%% Grip Analysis

% Lateral accelerations at grip [G]
grip.Ay_left = zeros(datasize, sweepVarRange);
grip.Ay_right = zeros(datasize, sweepVarRange);

% Yaw Moment at grip [lb*ft]
grip.M_left = zeros(datasize, sweepVarRange);
grip.M_right = zeros(datasize, sweepVarRange);

for i = 1: datasize

    for j = 1: sweepVarRange

        grip.Ay_left(i, j) = min(data(i).Ay(:, :, :, j), [], "all");
        grip.Ay_right(i, j) = max(data(i).Ay(:, :, :, j), [], "all");

        Mi = data(i).M(:, :, :, j);
        Ayi = data(i).Ay(:, :, :, j);

        grip.M_left(i, j) = Mi(Ayi == grip.Ay_left(i, j));
        grip.M_right(i, j) = Mi(Ayi == grip.Ay_right(i, j));

    end

end

% Absolute average lateral acceleration [G]
grip.Ay_absAvg = (abs(grip.Ay_left) + abs(grip.Ay_right))/2;

% Absolute average yaw moment [lb*ft]
grip.M_avg = (grip.M_left + grip.M_right)/2;

%% Limit Balance Analysis

addpath('YMD (v6.2)');

for i = 1: datasize

    for j = 1: sweepVarRange

        intersection = [];

        for k = 1: size(data(i).Ay(:, :, :, j), 1)

            SA_isoline_x = data(i).Ay(k, :, :, j);
            SA_isoline_y = data(i).M(k, :, :, j);

            SA_isoline = [SA_isoline_x; SA_isoline_y];

            M0_line = [-5 5; 0 0];

            [~, intersection(k, :)] = GetPolyLineIntersection(SA_isoline, M0_line);

        end


    % Find limit balance accelerations [G]
    limitBalance.Ay_right(i, j) = max(intersection(:, 1)); 
    limitBalance.Ay_left(i, j) = min(intersection(:, 1));
    limitBalance.Ay_absAvg(i, j) = (limitBalance.Ay_right(i, j) - limitBalance.Ay_left(i, j)) / 2;

    end    

end

%% Lateral Acceleration & Yaw Moment @ Basis Points 

% Define basis inputs
basis.SA = 4;
basis.Delta = 4;
basis.SX = 0;

% Basis indices
SA_index(i) = find(data(i).SA == basis.SA);
Delta_index(i) = find(data(i).Delta == basis.Delta);
SX_index(i) = find(data(i).SX == basis.SX);

% Basis lateral acceleration & yaw moment
basis.Ay = zeros(datasize, sweepVarRange);
basis.M = zeros(datasize, sweepVarRange);

for i = 1: datasize

    % Find basis indices
    SA_index(i) = find(data(i).SA == basis.SA);
    Delta_index(i) = find(data(i).Delta == basis.Delta);
    SX_index(i) = find(data(i).SX == basis.SX);
    
    for j = 1: sweepVarRange
    
        % Find basis lateral acceleration [G] & yaw moment [lb*ft]
        basis.Ay(i, j) = data(i).Ay(SA_index(i), Delta_index(i), SX_index(i), j);
        basis.M(i, j) = data(i).M(SA_index(i), Delta_index(i), SX_index(i), j);
    
    end

end

%% Stability & Control @ Basis Points

% Yaw moment at points around basis
basis_left.M = zeros(datasize, sweepVarRange);
basis_right.M = zeros(datasize, sweepVarRange);
basis_upper.M = zeros(datasize, sweepVarRange);
basis_lower.M = zeros(datasize, sweepVarRange);

for i = 1: datasize

    for j = 1: sweepVarRange
    
        % Find yaw moment at points around basis [lb*ft]
        basis_left.M(i, j) = data(i).M(SA_index(i)-1, Delta_index(i), SX_index(i), j);
        basis_right.M(i, j) = data(i).M(SA_index(i)+1, Delta_index(i), SX_index(i), j);
        basis_upper.M(i, j) = data(i).M(SA_index(i), Delta_index(i)+1, SX_index(i), j);
        basis_lower.M(i, j) = data(i).M(SA_index(i), Delta_index(i)-1, SX_index(i), j);
    
        % Compute stability: d(yaw moment)/d(body slip angle) [lb*ft/deg]
        stability.left(i, j) = (basis_left.M(i, j) - basis.M(i, j)) / (data(i).SA(SA_index(i)-1) - data(i).SA(SA_index(i)));
        stability.right(i, j) = (basis_right.M(i, j) - basis.M(i, j)) / (data(i).SA(SA_index(i)+1) - data(i).SA(SA_index(i)));
        stability.average(i, j) = (stability.left(i, j) + stability.right(i, j)) / 2;
        
        % Compute control: d(yaw moment)/d(steering angle) [lb*ft/deg]
        control.upper(i, j) = (basis_upper.M(i, j) - basis.M(i, j)) / (data(i).Delta(Delta_index(i)+1) - data(i).Delta(Delta_index(i)));
        control.lower(i, j) = (basis_lower.M(i, j) - basis.M(i, j)) / (data(i).Delta(Delta_index(i)-1) - data(i).Delta(Delta_index(i)));
        control.average(i, j) = (control.upper(i, j) + control.lower(i, j)) / 2;

    end

end

%% Plotting

figure; 
tiledlayout(2, 2);

% Grip lateral acceleration
nexttile; hold on;
plot(sweepVarValue, grip.M_right, '-o');
xlabel('Front Center of Pressure [%]'); 
ylabel('Average Yaw Moment [lb*ft]'); 
title('Grip Analysis');
legend('20 mph', '40 mph', '60 mph', 'Location', 'best');

% Limit balance lateral acceleration
nexttile; hold on;
plot(sweepVarValue, limitBalance.Ay_absAvg, '-o');
xlabel('Front Center of Pressure [%]'); 
ylabel('Absolue Average Lateral Acceleration [G]'); 
title('Limit Balance Analysis');
legend('20 mph', '40 mph', '60 mph', 'Location', 'best');

% Stability @ basis
nexttile; hold on;
plot(sweepVarValue, stability.average, '-o');
xlabel(sweepVarName); 
ylabel('Average Stability [lb*ft/deg]'); 
title('Basis Analysis: Stability');

% Control @ basis
nexttile; hold on;
plot(sweepVarValue, control.average, '-o');
xlabel(sweepVarName); 
ylabel('Average Control [lb*ft/deg]'); 
title('Basis Analysis: Control');