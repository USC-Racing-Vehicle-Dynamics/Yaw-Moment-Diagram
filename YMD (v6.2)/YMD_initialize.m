%% Function: Initialize

% Initialize the program by setting default parameter values

function isInit = YMD_initialize

%% Set Input Parameters

cfg = readMatlabConfig('SCR25');
param.g = 32.1740;                    % Gravity [ft/s^2]

%===| VEHICLE BODY |======================================================
                                                    
param.W = cfg.mass.dry_mass.value + cfg.mass.driver_mass.value + cfg.mass.fuel_mass.value;  % Vehicle mass [lb]             
param.fwd = cfg.mass.y_loc*100;                              % Front weight distribution [%]
param.l = cfg.dimensions.wheelbase.value;                % Wheelbase [in]               
param.t_F = cfg.frontSuspension.geom.track_width.value;  % Front track width [in]       
param.t_R = cfg.rearSuspension.geom.track_width.value;   % Rear track width [in]         
param.h = cfg.mass.z_loc.value;                          % CG height [in]                
param.z_RF = cfg.frontSuspension.geom.static_roll_center.value;  % Front roll center height [in]
param.z_RR = cfg.rearSuspension.geom.static_roll_center.value;   % Rear roll center height [in]
param.V.mph = cfg.simulation_params.YMD.velocity.value;                           
param.V.fts = 1.46667 * param.V.mph;         
param.V.kph = 1.60934 * param.V.mph;  

%===| TIRE |==============================================================

% Tire FY and MZ Models
param.tireData.FY = load(cfg.tire_params.model.Fy_model); 
param.tireData.MZ = load(cfg.tire_params.model.Mz_model);

param.IA.rad = deg2rad(cfg.frontSuspension.geom.static_IA.value);            
param.IP_f.psi = cfg.tire_params.inflation_pres.value;                  
param.IP_r.psi = cfg.tire_params.inflation_pres.value;                  
param.IP_f.pa = param.IP_f.psi * 6894.76; 
param.IP_r.pa = param.IP_r.psi * 6894.76;

param.ackermann = cfg.steering.ackermann.value;                
param.toe_f = cfg.frontSuspension.geom.static_toe.value;                             
param.toe_r = cfg.rearSuspension.geom.static_toe.value;                             
param.tireData.forceScale = cfg.simulation_params.tire_model.scaling_factor;      

%===| SUSPENSION |========================================================

param.tire_k = cfg.tire_params.tire_stiffness.value;                     % Tire spring rate [lb/in]      
param.f_spring_k = cfg.frontSuspension.stiffness.spring_rate.value;      % Front spring stiffness [lb/in]
param.r_spring_k = cfg.rearSuspension.stiffness.spring_rate.value;       % Rear spring stiffness [lb/in] 
param.f_arb_k = cfg.frontSuspension.stiffness.arb_stiffness.value;       % Front ARB stiffness[lb/in]    
param.r_arb_k = cfg.rearSuspension.stiffness.arb_stiffness.value;        % Rear ARB stiffness [lb/in]    

%===| AERO |==============================================================

param.C_L = cfg.aero_params.Cl;                 % Coefficent of lift           
param.CoP = cfg.aero_params.CoP;                % Center of pressure [%]

%% Assign Data and Complete Initialization

assignin("base", 'param', param);
assignin("base", "cfg", cfg);

isInit = 1;

end