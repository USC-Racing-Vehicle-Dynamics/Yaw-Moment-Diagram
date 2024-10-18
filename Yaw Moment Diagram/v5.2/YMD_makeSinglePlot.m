%% Function: Make Single YMD Plot
% Make one YMD plot based on user specified parameter values in data tab
function YMD_makeSinglePlot

%% Setup

% Switch to Single Plot tab
tabGroup = evalin("base", 'tabGroup');
tab.singlePlot = evalin("base", 'tab.singlePlot');
tabGroup.SelectedTab = tab.singlePlot;

% Import structured parameters
param = evalin('base', 'param');
 
% Import non-structured parameters
IA_rad = evalin("base", 'IA_rad'); % Inclination angle [rad]

tire_FY = evalin("base", 'tire_FY'); % Tire FY Model
tire_MZ = evalin("base", 'tire_MZ'); % Tire FZ Model

IP_psi_f = evalin("base", 'IP_psi_f'); % Front inflation pressure [psi]        
IP_psi_r = evalin("base", 'IP_psi_r'); % Rear inflation pressure [psi]           
IP_pa_f = IP_psi_f*6894.76;
IP_pa_r = IP_psi_r*6894.76;

tireForceScale = evalin("base", 'tireForceScale');  % Tire force scale       

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

f_load_sensitivity = W_s*(h2*K_F_s/(K_phi - W_s*h2) + (param.l - a_s)*param.z_RF/param.l)/param.t_F + W_uF*z_WF/param.t_F;    % Front lateral load transfer per g [lbf/g]
r_load_sensitivity = W_s*(h2*K_R_s/(K_phi - W_s*h2) + a_s*param.z_RR/param.l)/param.t_R + W_uR*z_WR/param.t_R;          % Rear lateral load transfer per g [lbf/g]

current_TLLTD = f_load_sensitivity/(f_load_sensitivity + r_load_sensitivity);      % get TLLTD

%% Plot Yaw Moment Diagram

% Obtain slip and steering angle information from base
Beta = evalin('base', 'Beta');
Delta = evalin('base', 'Delta');

% Spaces to store angular velocity & yaw moment
Ay_betaLines = zeros(length(Beta.range), length(Delta.range));
M_betaLines = zeros(length(Beta.range), length(Delta.range));

% Spaces to store left & right front steering angles
delta_lf_space1 = zeros(length(Delta.range), 1);
delta_rf_space1 = zeros(length(Delta.range), 1);

% Calculate Ackermann geometry effect on front steering angles
for i = 1: length(Delta.range)

    % Steering angle [rad]
    delta = Delta.range(i);

    % Solve for the Ackermann steering angles
    [delta_lf_space1(i), delta_rf_space1(i)] = AckermannSolver(param.ackermann, delta, param.t_F, param.l);

end

for i = 1: length(Beta.range)

    % Body slip angle [rad]
    beta = Beta.range(i);

    % Longitudinal and lateral speeds
    Vx = param.V.fts*cos(beta);
    Vy = param.V.fts*sin(beta);

    for k = 1: length(Delta.range)

        % Steering angles split on each front tire [rad]
        delta_lf = delta_lf_space1(k);
        delta_rf = delta_rf_space1(k);

        % Yaw rate (initially set to 0) [rad/s]
        r = 0;
        r_new = 0;

        % Lateral acceleration (initially set to 0) [G]
        Ay = 0;

        while r_new == 0 || abs(r_new - r) > 1e-5

            % Update yaw rate
            r = r_new;

            % Slip angles on each tire [rad]
            alpha_lf = (Vy + r*a)/(Vx - r*param.t_F/2) - delta_lf + param.toe_f;
            alpha_rf = (Vy + r*a)/(Vx + r*param.t_F/2) - delta_rf - param.toe_f;
            alpha_lr = (Vy - r*b)/(Vx - r*param.t_R/2) + param.toe_r;
            alpha_rr = (Vy - r*b)/(Vx + r*param.t_R/2) - param.toe_r;

            % Load trandfers on front/rear axles [lbf]
            dFz_f = f_load_sensitivity*Ay;
            dFz_r = r_load_sensitivity*Ay;

            % Normal loads on each tire [N]
            FZ_lf = (FZ_lf_s + dFz_f)*4.448;
            FZ_rf = (FZ_rf_s - dFz_f)*4.448;
            FZ_lr = (FZ_lr_s + dFz_r)*4.448;
            FZ_rr = (FZ_rr_s - dFz_r)*4.448;

            % Lateral forces on each tire
            [~, fy_lf] = magicformula(tire_FY.mfparams, 0, alpha_lf, FZ_lf, IP_pa_f, IA_rad);
            [~, ~, mz_lf] = magicformula(tire_MZ.mfparams, 0, alpha_lf, FZ_lf, IP_pa_f, IA_rad);
            FY_lf = tireForceScale*fy_lf/4.448;
            MZ_lf = tireForceScale*mz_lf*0.737562;

            [~, fy_rf] = magicformula(tire_FY.mfparams, 0, alpha_rf, FZ_rf, IP_pa_f, IA_rad);
            [~, ~, mz_rf] = magicformula(tire_MZ.mfparams, 0, alpha_rf, FZ_rf, IP_pa_f, IA_rad);
            FY_rf = tireForceScale*fy_rf/4.448;
            MZ_rf = tireForceScale*mz_rf*0.737562;

            [~, fy_lr] = magicformula(tire_FY.mfparams, 0, alpha_lr, FZ_lr, IP_pa_r, IA_rad);
            [~, ~, mz_lr] = magicformula(tire_MZ.mfparams, 0, alpha_lr, FZ_lr, IP_pa_r, IA_rad);
            FY_lr = tireForceScale*fy_lr/4.448;
            MZ_lr = tireForceScale*mz_lr*0.737562;

            [~, fy_rr] = magicformula(tire_FY.mfparams, 0, alpha_rr, FZ_rr, IP_pa_r, IA_rad);
            [~, ~, mz_rr] = magicformula(tire_MZ.mfparams, 0, alpha_rr, FZ_rr, IP_pa_r, IA_rad);
            FY_rr = tireForceScale*fy_rr/4.448;
            MZ_rr = tireForceScale*mz_rr*0.737562;

            % Lateral acceleration [G]
            Ay = (FY_lf*cos(delta_lf) + FY_lr + FY_rf*cos(delta_rf) + FY_rr)/param.W;

            % New yaw rate (M_total = Izz*r?)
            r_new = Ay/Vx;

            % Total alignment torque [lbf*ft]
            MZ = MZ_lf + MZ_rf + MZ_lr + MZ_rr;

        end

        Ay_betaLines(i, k) = Ay;
        M_betaLines(i, k) = (FY_lf*cos(delta_lf) + FY_rf*cos(delta_rf))*a + (FY_rf*sin(delta_rf) - FY_lf*sin(delta_lf))*param.t_F/2 - (FY_lr + FY_rr)*b + MZ;

    end

end

Ay_deltaLines = Ay_betaLines';
M_deltaLines = M_betaLines';

% Export data
assignin('base', 'Beta', Beta);
assignin('base', 'Delta', Delta);
assignin('base', 'Ay_betaLines', Ay_betaLines);
assignin('base', 'M_betaLines', M_betaLines);
assignin('base', 'Ay_deltaLines', Ay_deltaLines);
assignin('base', 'M_deltaLines', M_deltaLines);

%% Plot with Specified Range

YMD = evalin('base', 'YMD');

for YMDIndex = 1: length(Beta.range)

    if Beta.range(YMDIndex) == Beta.lowerLimit

        Beta.lowerLimitIndex = YMDIndex;

    end

    if Beta.range(YMDIndex) == Beta.upperLimit

        Beta.upperLimitIndex = YMDIndex;

    end

    if Delta.range(YMDIndex) == Delta.lowerLimit

        Delta.lowerLimitIndex = YMDIndex;

    end

    if Delta.range(YMDIndex) == Delta.upperLimit

        Delta.upperLimitIndex = YMDIndex;

    end

end


for i = Beta.lowerLimitIndex: Beta.upperLimitIndex

    for j = Delta.lowerLimitIndex: Delta.upperLimitIndex

        x1 = Ay_betaLines(i, Delta.lowerLimitIndex: Delta.upperLimitIndex);
        y1 = M_betaLines(i, Delta.lowerLimitIndex: Delta.upperLimitIndex);

        x2 = Ay_deltaLines(j, Beta.lowerLimitIndex: Beta.upperLimitIndex);
        y2 = M_deltaLines(j, Beta.lowerLimitIndex: Beta.upperLimitIndex);

        p1 = plot(YMD, x1, y1, '-b'); hold(YMD, 'on');
        p2 = plot(YMD, x2, y2, '-r');

        dt1 = p1.DataTipTemplate; 
        dt1.DataTipRows(1) = dataTipTextRow('Slip Angle', rad2deg(Beta.range(i)*ones(size(x1)))); 
        dt1.DataTipRows(2) = dataTipTextRow('Steering Angle', rad2deg(Delta.range)); 
        dt1.DataTipRows(3) = dataTipTextRow('Lateral Accel', x1); 
        dt1.DataTipRows(4)= dataTipTextRow('Yaw Moment', y1); 

        dt2 = p2.DataTipTemplate;
        dt2.DataTipRows(1) = dataTipTextRow('Slip Angle', rad2deg(Beta.range));
        dt2.DataTipRows(2) = dataTipTextRow('Steering Angle', rad2deg(Delta.range(j)*ones(size(x2))));
        dt2.DataTipRows(3) = dataTipTextRow('Lateral Accel', x2);
        dt2.DataTipRows(4) = dataTipTextRow('Yaw Moment', y2);

    end

end

grid(YMD, 'on');
xlabel(YMD, 'x');
xlim(YMD, [-2.5, 2.5]);
ylim(YMD, [-4000, 4000]);
xlabel(YMD, 'Lateral Acceleration [G]');
ylabel(YMD, 'Yaw Moment [lb*ft]');
title(YMD, 'Yaw Moment Diagram');
hold(YMD, 'off');

% End function
end