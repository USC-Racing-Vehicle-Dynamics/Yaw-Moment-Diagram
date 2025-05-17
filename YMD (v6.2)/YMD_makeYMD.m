%% Function: Make Single YMD Plot

% Make one YMD plot based on user specified parameter values in data tab

function YMD_makeYMD

%% Setup

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

%% Calculate Intermediate Parameters

%===| VEHICLE BODY |==================================================

%--------*
% Masses |
%--------*
W_F = param.W*param.fwd;            % Front total mass [lb]
W_R = param.W - W_F;          % Rear total mass [lb]
W_uF = 48.24;           % Front unsprung mass [lb]
W_uR = 47.56;           % Rear unsprung mass [lb]
W_u = W_uF + W_uR;      % Total unsprung mass [lb]
W_s = param.W - W_u;          % Total sprung mass [lb]
W_sF = W_F - W_uF;      % Front sprung mass [lb]              
W_sR = W_R - W_uR;      % Rear sprung mass [lb]

%-----------------------*
% Peripheral Dimensions |
%-----------------------*
a = param.l*(1 - param.fwd);                    % Distance between front axle and CG [ft]
b = param.l*param.fwd;                          % Distance between rear axle and CG [ft]
Izz = (param.W/param.g)*((a + b)^2 + param.t_F^2)/12; % Moment of inertia

%-----------------------------*
% CG/Roll Center/Ride Heights |
%-----------------------------*
h_u = 8/12;                                             % CG height of unsprung mass [ft]
h_s = (param.h*param.W - h_u*W_u)/W_s;                              % CG height of sprung mass [ft]
H = param.h - (param.z_RF + (param.z_RR - param.z_RF)*a/param.l);                     % CG height above roll axis [ft]
% Assume x-position of sprung mass CG
% is the same as total CG
a_s = a;                                                % x-position of sprung mass CG [ft]
theta = atan((param.z_RR - param.z_RF)/param.l);                          % Inclination angle of roll axis
h2 = (h_s - (param.z_RF + (param.z_RR - param.z_RF)*a_s/param.l))*cos(theta);   % Distance between sprung mass CG and roll axis (orthogonal) [ft]
% Assume the heights of front and rear unsprung masses
% are the same as the total unsprung mass
z_WF = h_u;                                             % CG height of front unsprung mass [ft]
z_WR = h_u;                                             % CG height of rear unsprung mass [ft]
front_RH = -0.6;                                        % Front ride height [ft]
rear_RH = -0.6;                                         % Rear ride height [ft]
  
%===| SUSPENSION |====================================================

%---------------*
% Motion ratios |
%---------------*
f_MR_spring = 1.02;
r_MR_spring = 1.18;
f_MR_arb = .2;               % spring / wheel [deg/deg]      
r_MR_arb = .35;

%===| AERO |==========================================================

% Frontal area [ft^2]
A = 0.96;

% Air density [lb/ft^3]
rho_air = 0.0763;

% Total downforce
DF = param.C_L*A*param.V.mph^2*rho_air/2;

% Front and rear downforces [lb]
f_DF = DF*param.CoP;
r_DF = DF*(1 - param.CoP);

% Front and rear downforces [lb]
% [f_DF, r_DF] = aeromap_func_v2(front_RH, rear_RH, V_fts);

%===| MISCANLLANEOUS |================================================

% Static tire normal loads (excluding transfer) [lb]
FZ_lf_s = (param.W * param.fwd + f_DF/2)/2;
FZ_rf_s = (param.W * param.fwd + f_DF/2)/2;
FZ_lr_s = (param.W * (1 - param.fwd) + r_DF/2)/2;
FZ_rr_s = (param.W * (1 - param.fwd) + r_DF/2)/2;

%% Roll Rate Calculation

K_WF_arb = 2*param.f_arb_k*(f_MR_arb)^2;              % Front wheel rate contributed by ARB [lbf/ft]
K_WF = param.f_spring_k*(f_MR_spring)^2 + K_WF_arb;   % Front wheel rate [lbf/ft] 
K_RF = (K_WF*param.tire_k)/(K_WF + param.tire_k);           % Front ride rate [lbf/ft]
K_F = param.t_F^2*K_RF/2;                             % Front roll rate [lbf*ft/rad]             
K_F_s = K_F - (param.l - a_s)*W_s*h2/param.l;               % Front roll rate of sprung mass [lbf*ft/rad]

K_WR_arb = 2*param.r_arb_k*(r_MR_arb)^2;
K_WR = param.r_spring_k * (r_MR_spring)^2 + K_WR_arb;   % same for rear
K_RR = (K_WR*param.tire_k)/(K_WR + param.tire_k);               
K_R = param.t_R^2*K_RR/2;
K_R_s = K_R - a_s*W_s*h2/param.l;

K_phi = K_F + K_R;                              % Total roll rate [lbf*ft/rad]
roll_grad = rad2deg(-W_s*h2/(K_phi - W_s*h2));  % Current roll gradient [deg/g]

f_load_sensitivity = W_s*(h2*K_F_s/(K_phi - W_s*h2) + ...
    (param.l - a_s)*param.z_RF/param.l)/param.t_F + W_uF*z_WF/param.t_F; % Front lateral load transfer per g [lbf/g]
r_load_sensitivity = W_s*(h2*K_R_s/(K_phi - W_s*h2) + ...
    a_s*param.z_RR/param.l)/param.t_R + W_uR*z_WR/param.t_R; % Rear lateral load transfer per g [lbf/g]

current_TLLTD = f_load_sensitivity/(f_load_sensitivity + r_load_sensitivity);      % get TLLTD

% Find maximum lateral acceleration [G]
Ay_max_f = min(FZ_lf_s, FZ_rf_s) / f_load_sensitivity;
Ay_max_r = min(FZ_lr_s, FZ_rr_s) / r_load_sensitivity;
Ay_max = min(Ay_max_f, Ay_max_r) - 1e-6;

%% Plot Yaw Moment Diagram

% Obtain wheel inputs from base
SX = evalin('base', 'SX_rad_range');
SA = evalin('base', 'SA_rad_range');
Delta = evalin('base', 'Delta_rad_range');

% Spaces to store data
AxData = zeros(length(SA), length(Delta), length(SX));
AyData = zeros(length(SA), length(Delta), length(SX));
MData = zeros(length(SA), length(Delta), length(SX));

% Spaces to store left & right front steering angles
delta_lf_space1 = zeros(length(Delta), 1);
delta_rf_space1 = zeros(length(Delta), 1);

% Calculate Ackermann geometry effect on front steering angles
for i = 1: length(Delta)

    % Steering angle [rad]
    delta = Delta(i);

    % Solve for the Ackermann steering angles
    [delta_lf_space1(i), delta_rf_space1(i)] = AckermannSolver(param.ackermann, delta, param.t_F, param.l);

end

% Data acquisition
for z = 1: length(SX)

    sx = SX(z);

    for x = 1: length(SA)
    
        % Body slip angle [rad]
        beta = SA(x);
        
        % Longitudinal and lateral speeds
        Vx = param.V.fts * cos(beta);
        Vy = param.V.fts * sin(beta);
    
        for y = 1: length(Delta)
        
            % Steering angles split on each front tire [rad]
            delta_lf = delta_lf_space1(y);
            delta_rf = delta_rf_space1(y);

            % Yaw rate (initial guess as 0) [rad/s]
            r_guess = 0;
            r = [];

            % Lateral acceleration (initial guess as 0) [G]
            Ay_guess = 0;
            Ay = [];
            
            % Loop to find steady-state lateral acceleration
            while isempty(Ay) || abs(Ay_guess - Ay) > 1e-3

                if ~isempty(r)

                    r_guess = r;
                    Ay_guess = Ay;

                end

                % Slip angles on each tire [rad]
                alpha_lf = (Vy + r_guess*a)/(Vx - r_guess*param.t_F/2) - delta_lf + param.toe_f;
                alpha_rf = (Vy + r_guess*a)/(Vx + r_guess*param.t_F/2) - delta_rf - param.toe_f;
                alpha_lr = (Vy - r_guess*b)/(Vx - r_guess*param.t_R/2) + param.toe_r;
                alpha_rr = (Vy - r_guess*b)/(Vx + r_guess*param.t_R/2) - param.toe_r;
                
                % Load trandfers on front/rear axles [lb]
                if abs(Ay_guess) > Ay_max
    
                    dFz_f = f_load_sensitivity * sign(Ay_guess) * Ay_max;
                    dFz_r = r_load_sensitivity * sign(Ay_guess) * Ay_max;
    
                else
    
                    dFz_f = f_load_sensitivity * Ay_guess;
                    dFz_r = r_load_sensitivity * Ay_guess;
    
                end
                
                % Normal loads on each tire [N]
                FZ_lf = (FZ_lf_s + dFz_f) * 4.448;
                FZ_rf = (FZ_rf_s - dFz_f) * 4.448;
                FZ_lr = (FZ_lr_s + dFz_r) * 4.448;
                FZ_rr = (FZ_rr_s - dFz_r) * 4.448;
                
                % Lateral forces on each tire
                [fx_lf, fy_lf] = magicformula(param.tireData.FY.mfparams, sx, alpha_lf, FZ_lf, param.IP_f.pa, param.IA.rad);
                [~, ~, mz_lf] = magicformula(param.tireData.MZ.mfparams, sx, alpha_lf, FZ_lf, param.IP_f.pa, param.IA.rad);
                FX_lf = param.tireData.forceScale * fx_lf / 4.448;
                FY_lf = param.tireData.forceScale * fy_lf / 4.448;
                MZ_lf = param.tireData.forceScale * mz_lf * 0.737562;
                
                [fx_rf, fy_rf] = magicformula(param.tireData.FY.mfparams, sx, alpha_rf, FZ_rf, param.IP_f.pa, param.IA.rad);
                [~, ~, mz_rf] = magicformula(param.tireData.MZ.mfparams, sx, alpha_rf, FZ_rf, param.IP_f.pa, param.IA.rad);
                FX_rf = param.tireData.forceScale * fx_rf / 4.448;
                FY_rf = param.tireData.forceScale * fy_rf / 4.448;
                MZ_rf = param.tireData.forceScale * mz_rf * 0.737562;
                
                [fx_lr, fy_lr] = magicformula(param.tireData.FY.mfparams, sx, alpha_lr, FZ_lr, param.IP_r.pa, param.IA.rad);
                [~, ~, mz_lr] = magicformula(param.tireData.MZ.mfparams, sx, alpha_lr, FZ_lr, param.IP_r.pa, param.IA.rad);
                FX_lr = param.tireData.forceScale * fx_lr / 4.448;
                FY_lr = param.tireData.forceScale * fy_lr / 4.448;
                MZ_lr = param.tireData.forceScale * mz_lr * 0.737562;
                
                [fx_rr, fy_rr] = magicformula(param.tireData.FY.mfparams, sx, alpha_rr, FZ_rr, param.IP_r.pa, param.IA.rad);
                [~, ~, mz_rr] = magicformula(param.tireData.MZ.mfparams, sx, alpha_rr, FZ_rr, param.IP_r.pa, param.IA.rad);
                FX_rr = param.tireData.forceScale * fx_rr / 4.448;
                FY_rr = param.tireData.forceScale * fy_rr / 4.448;
                MZ_rr = param.tireData.forceScale * mz_rr * 0.737562;
                
                % Longitudinal acceleration [G]
                Ax = (FX_lf*cos(delta_lf) + FX_lr + FX_rf*cos(delta_rf) + FX_rr)/param.W;
                
                % Lateral acceleration [G]
                Ay = (FY_lf*cos(delta_lf) + FY_lr + FY_rf*cos(delta_rf) + FY_rr)/param.W;   
                
                % New yaw rate (M_total = Izz*r?)
                r = Ay/Vx;
                
                % Total alignment torque [lbf*ft]
                MZ = MZ_lf + MZ_rf + MZ_lr + MZ_rr;

            end
            
            AxData(x, y, z) = Ax;
            AyData(x, y, z) = Ay;       
            MData(x, y, z) = (FY_lf*cos(delta_lf) + FY_rf*cos(delta_rf))*a + ...
                (FY_rf*sin(delta_rf) - FY_lf*sin(delta_lf))*param.t_F/2 - (FY_lr + FY_rr)*b + MZ;
        
        end
    
    end

end

% Export data
assignin('base', 'AxData', AxData);
assignin('base', 'AyData', AyData);
assignin('base', 'MData', MData);

%% Plot by Rearranging Data

YMDAxes = evalin('base', 'YMDAxes');

% Clear axes
cla(YMDAxes);

% Plot slip angle variation lines
for y = 1: length(Delta)

    for z = 1: length(SX)

        Ay_SALine = squeeze(AyData(1: length(SA), y, z));
        M_SALine = squeeze(MData(1: length(SA), y, z));
        Ax_SALine = squeeze(AxData(1: length(SA), y, z));

        YMDPlot.SA = plot3(YMDAxes, Ay_SALine, M_SALine, Ax_SALine, '-r');
        hold(YMDAxes, 'on');

        % Data tip setup
        dt1 = YMDPlot.SA.DataTipTemplate;
        dt1.DataTipRows(1) = dataTipTextRow('Slip Angle', rad2deg(SA)); 
        dt1.DataTipRows(2) = dataTipTextRow('Steering Angle', rad2deg(Delta(y) * ones(size(1: length(SA)))));
        dt1.DataTipRows(3) = dataTipTextRow('Slip Ratio', rad2deg(SX(z) * ones(size(1: length(SA))))); 
        dt1.DataTipRows(4) = dataTipTextRow('X Accel', Ax_SALine); 
        dt1.DataTipRows(5) = dataTipTextRow('Y Accel', Ay_SALine); 
        dt1.DataTipRows(6) = dataTipTextRow('Yaw Moment', M_SALine);

    end
    
end

% Plot steering angle variation lines
for x = 1: length(SA)

    for z = 1: length(SX)

        Ay_deltaLine = squeeze(AyData(x, 1: length(Delta), z));
        M_deltaLine = squeeze(MData(x, 1: length(Delta), z));
        Ax_deltaLine = squeeze(AxData(x, 1: length(Delta), z));

        YMDPlot.delta = plot3(YMDAxes, Ay_deltaLine, M_deltaLine, Ax_deltaLine, '-b');

        % Data tip setup
        dt2 = YMDPlot.delta.DataTipTemplate;
        dt2.DataTipRows(1) = dataTipTextRow('Slip Angle', rad2deg(SA(x) * ones(size(1: length(Delta))))); 
        dt2.DataTipRows(2) = dataTipTextRow('Steering Angle', rad2deg(Delta));
        dt2.DataTipRows(3) = dataTipTextRow('Slip Ratio', rad2deg(SX(z) * ones(size(1: length(Delta))))); 
        dt2.DataTipRows(4) = dataTipTextRow('X Accel', Ax_deltaLine); 
        dt2.DataTipRows(5) = dataTipTextRow('Y Accel', Ay_deltaLine); 
        dt2.DataTipRows(6) = dataTipTextRow('Yaw Moment', M_deltaLine);

    end

end

% Plot slip ratio variation lines
for x = 1: length(SA)

    for y = 1: length(Delta)

        Ay_SXLine = squeeze(AyData(x, y, 1: length(SX)));
        M_SXLine = squeeze(MData(x, y, 1: length(SX)));
        Ax_SXLine = squeeze(AxData(x, y, 1: length(SX)));

        YMDPlot.SX = plot3(YMDAxes, Ay_SXLine, M_SXLine, Ax_SXLine, '-k'); 

        % Data tip setup
        dt3 = YMDPlot.SX.DataTipTemplate;
        dt3.DataTipRows(1) = dataTipTextRow('Slip Angle', rad2deg(SA(x) * ones(size(1: length(SX))))); 
        dt3.DataTipRows(2) = dataTipTextRow('Steering Angle', rad2deg(Delta(y) * ones(size(1: length(SX)))));
        dt3.DataTipRows(3) = dataTipTextRow('Slip Ratio', rad2deg(SX)); 
        dt3.DataTipRows(4) = dataTipTextRow('X Accel', Ax_SXLine); 
        dt3.DataTipRows(5) = dataTipTextRow('Y Accel', Ay_SXLine); 
        dt3.DataTipRows(6) = dataTipTextRow('Yaw Moment', M_SXLine); 

    end

end

% Assign plot to base workspace
grid(YMDAxes, 'on');
xlabel(YMDAxes, 'x');
xlabel(YMDAxes, 'Lateral Acceleration [G]');
ylabel(YMDAxes, 'Yaw Moment [lb*ft]');
zlabel(YMDAxes, 'Longitudinal Acceleration [G]');
title(YMDAxes, 'Yaw Moment Diagram');
view(YMDAxes, [-1 -1 1]);
hold(YMDAxes, 'off');

% Adjust plot view & isolines based on user selection
YMD_adjustPlotView;
YMD_adjustIsolines;

% Switch to Single Plot tab
tabs = evalin("base", 'tabs');
tabGroup = evalin("base", 'tabGroup');
tabGroup.SelectedTab = tabs.YMD;

end