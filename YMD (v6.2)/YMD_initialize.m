%% Function: Initialize

% Initialize the program by setting default parameter values

function isInit = YMD_initialize

%% Set Input Parameters

%===| PHYSICAL CONSTANTS |================================================

param.g = 32.1740;                    % Gravity [ft/s^2]

%===| VEHICLE BODY |======================================================
                                                    
%--------*
% Masses |
%--------*
param.W = 650;                        % Vehicle mass [lb]             
param.fwd = 48;                       % Front weight distribution [%]

%-----------------------*
% Peripheral Dimensions |
%-----------------------*
param.l = 60.5;                       % Wheelbase [in]               
param.t_F = 48;                       % Front track width [in]       
param.t_R = 48;                       % Rear track width [in]         

%-----------------------------*
% CG/Roll Center/Ride Heights |
%-----------------------------*
param.h = 12.5;                       % CG height [in]                
param.z_RF = 2.78;                    % Front roll center height [in]
param.z_RR = 4.17;                    % Rear roll center height [in]

%-----------------------------------*
% Vehicle Speed (assuming constant) |
%-----------------------------------*
param.V.mph = 40;                           
param.V.fts = 1.46667 * param.V.mph;         
param.V.kph = 1.60934 * param.V.mph;  

%===| TIRE |==============================================================

% Tire FY and MZ Models
param.tireData.FY = load('Fitted Data/43075_R20_16x7.5_FY03.mat'); 
param.tireData.MZ = load('Fitted Data/43075_R20_16x7.5_MZ0.mat');

% Inclination angle [rad]
param.IA.rad = deg2rad(0);            

% Inflation pressure (front & rear)
param.IP_f.psi = 11;                  
param.IP_r.psi = 11;                  
param.IP_f.pa = param.IP_f.psi * 6894.76; 
param.IP_r.pa = param.IP_r.psi * 6894.76;

% Ackermann [%]
param.ackermann = 110;                

% Toe (front & rear) [deg]
param.toe_f = 0.5;                             
param.toe_r = 0.5;                             

% Tire force scale
param.tireData.forceScale = 0.8;      

%===| SUSPENSION |========================================================

%-------------*
% Stiffnesses |
%-------------*
param.tire_k = 500;           % Tire spring rate [lb/in]      
param.f_spring_k = 250;       % Front spring stiffness [lb/in]
param.r_spring_k = 250;       % Rear spring stiffness [lb/in] 
param.f_arb_k = 596.11;       % Front ARB stiffness[lb/in]    
param.r_arb_k = 0;       % Rear ARB stiffness [lb/in]    

% ARB Backup values (keep commented)
% f_arb_backup = [819.65 667.92 596.11 552.97 537.85 319.674];
% r_arb_backup = [573.35 386.86 278.52 0];

%===| AERO |==============================================================

param.C_L = 3.5;              % Coefficent of lift           
param.CoP = 50;               % Center of pressure [%]

%% Assign Data and Complete Initialization

assignin("base", 'param', param);

isInit = 1;

end