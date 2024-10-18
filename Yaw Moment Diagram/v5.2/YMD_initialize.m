%% Function: Initialize
% Initialize the program by setting default parameter values
function isInit = YMD_initialize

%% Set up & Export Input Parameters

%===| PHYSICAL CONSTANTS |================================================

param.g = 32.1740;                    % Gravity [ft/s^2]

%assignin("base", 'g', g);

%===| VEHICLE BODY |======================================================
                                                    
%--------*
% Masses |
%--------*
param.W = 650;                        % Vehicle mass [lb]             
param.fwd = 48;                       % Front weight distribution [%]

% assignin("base", 'W', W);
% assignin("base", 'fwd', fwd);

%-----------------------*
% Peripheral Dimensions |
%-----------------------*
param.l = 60.5;                       % Wheelbase [in]               
param.t_F = 48;                       % Front track width [in]       
param.t_R = 48;                       % Rear track width [in]         

% assignin("base", 'l', l);
% assignin("base", 't_F', t_F);
% assignin("base", 't_R', t_R);

%-----------------------------*
% CG/Roll Center/Ride Heights |
%-----------------------------*
param.h = 12.5;                       % CG height [in]                
param.z_RF = 2.78;                    % Front roll center height [in]
param.z_RR = 4.17;                    % Rear roll center height [in]

% assignin("base", 'h', h);
% assignin("base", 'z_RF', z_RF);
% assignin("base", 'z_RR', z_RR);

%-----------------------------------*
% Vehicle Speed (assuming constant) |
%-----------------------------------*
param.V.mph = 40;                     % Velocity [mph]            
param.V.fts = 1.46667*param.V.mph;          % Velocity [ft/s]      
param.V.kph = 1.60934*param.V.mph;          % Velocity [kph]    

% assignin("base", 'V_mph', V_mph);
% assignin("base", 'V_fts', V_fts);
% assignin("base", 'V_kph', V_kph);

%===| TIRE |==============================================================

IA_rad = deg2rad(0);            % Inclination angle [rad]

% Tire FY and MZ Models
tire_FY = load('Fitted Data/43075_R20_16x7.5_FY0.mat'); 
tire_MZ = load('Fitted Data/43075_R20_16x7.5_MZ0.mat');

IP_psi_f = 11;                  % Front inflation pressure [psi]
IP_psi_r = 11;                  % Rear inflation pressure [psi]
% IP_pa_f = IP_psi_f*6894.76;     % Front inflation pressure [Pa]
% IP_pa_r = IP_psi_r*6894.76;     % Rear inflation pressure [Pa]

param.ackermann = 110;                % Ackermann [%]                 
param.toe_f = 0.5;                    % Front toe [deg]               
param.toe_r = 0.5;                    % Rear toe [deg]               

tireForceScale = 0.8;           % Tire force scale

assignin("base", 'IA_rad', IA_rad);
assignin("base", 'tire_FY', tire_FY);
assignin("base", 'tire_MZ', tire_MZ);
assignin("base", 'IP_psi_f', IP_psi_f);
assignin("base", 'IP_psi_r', IP_psi_r);
% assignin("base", 'ackermann', ackermann);
% assignin("base", 'toe_f', toe_f);
% assignin("base", 'toe_r', toe_r);
assignin("base", 'tireForceScale', tireForceScale);

%===| SUSPENSION |========================================================

%-------------*
% Stiffnesses |
%-------------*
param.tire_k = 500;           % Tire spring rate [lb/in]      
param.f_spring_k = 250;       % Front spring stiffness [lb/in]
param.r_spring_k = 150;       % Rear spring stiffness [lb/in] 
param.f_arb_k = 596.11;       % Front ARB stiffness[lb/in]    
param.r_arb_k = 386.86;       % Rear ARB stiffness [lb/in]    

% ARB Backup values
% f_arb_backup = [819.65 667.92 596.11 552.97 537.85 319.674];
% r_arb_backup = [573.35 386.86 278.52 0];

% assignin("base", 'tire_k', tire_k);
% assignin("base", 'f_spring_k', f_spring_k);
% assignin("base", 'r_spring_k', r_spring_k);
% assignin("base", 'f_arb_k', f_arb_k);
% assignin("base", 'r_arb_k', r_arb_k);

%===| AERO |==============================================================

param.C_L = 3.5;              % Coefficent of lift           
param.CoP = 50;               % Center of pressure [%]       

%assignin("base", 'C_L', C_L);
assignin("base", 'param', param);

%% 

Beta.lowerLimit = deg2rad(-15);
Beta.upperLimit = deg2rad(15);

Delta.lowerLimit = deg2rad(-15);
Delta.upperLimit = deg2rad(15); 

% Number of data points for each isoline entry
numDataPts = 31;
Beta.range = linspace(Beta.lowerLimit, Beta.upperLimit, numDataPts);
Delta.range = linspace(Delta.lowerLimit, Delta.upperLimit, numDataPts);

assignin('base', 'numDataPts', numDataPts);
assignin('base', 'Beta', Beta);
assignin('base', 'Delta', Delta);

isInit = 1;
%return;

end