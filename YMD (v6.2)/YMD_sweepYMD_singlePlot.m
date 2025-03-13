%% Function: Make Single YMD Plot for Sweep

% Make single plot within YMD_makeYMDSweep.m function 
% for one certain value of the swept parameter

function [AxSweepData, AySweepData, MSweepData] = YMD_sweepYMD_singlePlot(param, sweptParam, sweep, sweptParamIndex)

%% Program Setup

YMDSweepPlots = evalin('base', 'YMDSweepPlots');

% Assign current value to swept parameter
switch sweptParam.ValueIndex

    case 1 % Vehicle mass
        param.W = sweep.range(sweptParamIndex);

    case 2 % Front weight distribution
        param.fwd = sweep.range(sweptParamIndex)/100;

    case 3 % Wheelbase
        param.l = sweep.range(sweptParamIndex)/12;

    case 4 % Front Track Width
        param.t_F = sweep.range(sweptParamIndex)/12;

    case 5 % Rear Track Width
        param.t_R = sweep.range(sweptParamIndex)/12;

    case 6 % CG Height
        param.h = sweep.range(sweptParamIndex)/12;

    case 7 % Front Roll Center Height
        param.z_RF = sweep.range(sweptParamIndex)/12;

    case 8 % Rear Roll Center Height
        param.z_RR = sweep.range(sweptParamIndex)/12;

    case 9 % Ackermann
        param.ackermann = sweep.range(sweptParamIndex)/100;

    case 10 % Front Toe
        param.toe_f = deg2rad(sweep.range(sweptParamIndex));

    case 11 % Rear Toe
        param.toe_r = deg2rad(sweep.range(sweptParamIndex));

    case 12 % Tire Spring Rate
        param.tire_k = sweep.range(sweptParamIndex)*12;

    case 13 % Front Spring Stiffness
        param.f_spring_k = sweep.range(sweptParamIndex)*12;

    case 14 % Rear Spring Stiffness
        param.r_spring_k = sweep.range(sweptParamIndex)*12;

    case 15 % Front ARB Stiffness
        param.f_arb_k = sweep.range(sweptParamIndex)*12;

    case 16 % Rear ARB Stiffness
        param.r_arb_k = sweep.range(sweptParamIndex)*12;

    case 17 % Coefficient of Lift
        param.C_L = sweep.range(sweptParamIndex)*12;

    case 18 % Center of Pressure
        param.CoP = sweep.range(sweptParamIndex)/100;

    case 19 % Velocity [mph]
        param.V.mph = sweep.range(sweptParamIndex);
        param.V.fts = 1.46667 * param.V.mph;    
        param.V.kph = 1.60934 * param.V.mph;

end

%% Calculate Intermediate Parameters

%===| VEHICLE BODY |==================================================

%--------*
% Masses |
%--------*
W_F = param.W * param.fwd;            % Front total mass [lb]
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
h_s = (param.h * param.W - h_u * W_u)/W_s;                              % CG height of sprung mass [ft]
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
DF = param.C_L * A * param.V.mph^2 * rho_air/2;

% Front and rear downforces [lb]
f_DF = DF * param.CoP;
r_DF = DF * (1 - param.CoP);

% Front and rear downforces [lb]
% [f_DF, r_DF] = aeromap_func_v2(front_RH, rear_RH, V_fts);

%===| MISCANLLANEOUS |================================================

% Static tire normal loads (excluding transfer) [lb]
FZ_lf_s = (param.W * param.fwd + f_DF/2)/2;
FZ_rf_s = (param.W * param.fwd + f_DF/2)/2;
FZ_lr_s = (param.W * (1 - param.fwd) + r_DF/2)/2;
FZ_rr_s = (param.W * (1 - param.fwd) + r_DF/2)/2;

%% Roll Rate Calculation

K_WF_arb = 2 * param.f_arb_k * (f_MR_arb)^2;              % Front wheel rate contributed by ARB [lbf/ft]
K_WF = param.f_spring_k * (f_MR_spring)^2 + K_WF_arb;   % Front wheel rate [lbf/ft] 
K_RF = (K_WF * param.tire_k)/(K_WF + param.tire_k);           % Front ride rate [lbf/ft]
K_F = param.t_F^2 * K_RF/2;                             % Front roll rate [lbf*ft/rad]             
K_F_s = K_F - (param.l - a_s) * W_s * h2/param.l;               % Front roll rate of sprung mass [lbf*ft/rad]

K_WR_arb = 2 * param.r_arb_k * (r_MR_arb)^2;
K_WR = param.r_spring_k * (r_MR_spring)^2 + K_WR_arb;   % same for rear
K_RR = (K_WR * param.tire_k)/(K_WR + param.tire_k);               
K_R = param.t_R^2 * K_RR/2;
K_R_s = K_R - a_s * W_s * h2/param.l;

K_phi = K_F + K_R;                              % Total roll rate [lbf*ft/rad]
roll_grad = rad2deg(-W_s*h2/(K_phi - W_s*h2));  % Current roll gradient [deg/g]

f_load_sensitivity = W_s*(h2*K_F_s/(K_phi - W_s*h2) + (param.l - a_s)*param.z_RF/param.l)/param.t_F + W_uF*z_WF/param.t_F;    % Front lateral load transfer per g [lbf/g]
r_load_sensitivity = W_s*(h2*K_R_s/(K_phi - W_s*h2) + a_s*param.z_RR/param.l)/param.t_R + W_uR*z_WR/param.t_R;          % Rear lateral load transfer per g [lbf/g]

current_TLLTD = f_load_sensitivity/(f_load_sensitivity + r_load_sensitivity);      % get TLLTD

%% Generate YMD Data

% Obtain slip and steering angle information from base
SX = evalin('base', 'SX_rad_range');
SA = evalin('base', 'SA_rad_range');
Delta = evalin('base', 'Delta_rad_range');

% Spaces to store angular velocity & yaw moment
AxSweepData = zeros(length(SA), length(Delta), length(SX));
AySweepData = zeros(length(SA), length(Delta));
MSweepData = zeros(length(SA), length(Delta));

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
    
            % Lateral acceleration (initially set to 0) [~g]
            Ay = 0;
  
            % Slip angles on each tire [rad]
            alpha_lf = Vy/Vx - delta_lf + param.toe_f;
            alpha_rf = Vy/Vx - delta_rf - param.toe_f;
            alpha_lr = Vy/Vx + param.toe_r;
            alpha_rr = Vy/Vx - param.toe_r;

            % Load trandfers on front/rear axles [lbf]
            dFz_f = f_load_sensitivity*Ay;
            dFz_r = r_load_sensitivity*Ay;

            % Normal loads on each tire [N]
            FZ_lf = (FZ_lf_s + dFz_f)*4.448;
            FZ_rf = (FZ_rf_s - dFz_f)*4.448;
            FZ_lr = (FZ_lr_s + dFz_r)*4.448;
            FZ_rr = (FZ_rr_s - dFz_r)*4.448;

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

            % Lateral acceleration [g]
            Ay = (FY_lf*cos(delta_lf) + FY_lr + FY_rf*cos(delta_rf) + FY_rr)/param.W;

            % Total alignment torque [lbf*ft]
            MZ = MZ_lf + MZ_rf + MZ_lr + MZ_rr;
    
    
            AxSweepData(x, y, z) = Ax;
            AySweepData(x, y, z) = Ay;       
            MSweepData(x, y, z) = (FY_lf*cos(delta_lf) + FY_rf*cos(delta_rf))*a + ...
                (FY_rf*sin(delta_rf) - FY_lf*sin(delta_lf))*param.t_F/2 - (FY_lr + FY_rr)*b + MZ;
    
        end
    
    end

end

%% Plot by Rearranging Data

YMDSweepAxes = evalin('base', 'YMDSweepAxes');

% Plot slip angle isolines
for y = 1: length(Delta)

    for z = 1: length(SX)

        Ay_SALine = squeeze(AySweepData(1: length(SA), y, z));
        M_SALine = squeeze(MSweepData(1: length(SA), y, z));
        Ax_SALine = squeeze(AxSweepData(1: length(SA), y, z));

        YMDSweepPlot.SA = plot3(YMDSweepAxes, Ay_SALine, M_SALine, Ax_SALine, '-r');
        hold(YMDSweepAxes, 'on');

        % Data tip setup
        dt1 = YMDSweepPlot.SA.DataTipTemplate;
        dt1.DataTipRows(1) = dataTipTextRow('Slip Angle', rad2deg(SA)); 
        dt1.DataTipRows(2) = dataTipTextRow('Steering Angle', rad2deg(Delta(y) * ones(size(1: length(SA)))));
        dt1.DataTipRows(3) = dataTipTextRow('Slip Ratio', SX(z) * ones(size(1: length(SA)))); 
        dt1.DataTipRows(4) = dataTipTextRow('X Accel', Ax_SALine); 
        dt1.DataTipRows(5) = dataTipTextRow('Y Accel', Ay_SALine); 
        dt1.DataTipRows(6) = dataTipTextRow('Yaw Moment', M_SALine);

        % Combine all plots
        YMDSweepPlots{sweptParamIndex, 1} = [YMDSweepPlots{sweptParamIndex, 1}; YMDSweepPlot.SA];

    end
    
end

% Plot steering angle isolines
for x = 1: length(SA)

    for z = 1: length(SX)

        Ay_deltaLine = squeeze(AySweepData(x, 1: length(Delta), z));
        M_deltaLine = squeeze(MSweepData(x, 1: length(Delta), z));
        Ax_deltaLine = squeeze(AxSweepData(x, 1: length(Delta), z));

        YMDSweepPlot.delta = plot3(YMDSweepAxes, Ay_deltaLine, M_deltaLine, Ax_deltaLine, '-b');

        % Data tip setup
        dt2 = YMDSweepPlot.delta.DataTipTemplate;
        dt2.DataTipRows(1) = dataTipTextRow('Slip Angle', rad2deg(SA(x) * ones(size(1: length(Delta))))); 
        dt2.DataTipRows(2) = dataTipTextRow('Steering Angle', rad2deg(Delta));
        dt2.DataTipRows(3) = dataTipTextRow('Slip Ratio', SX(z) * ones(size(1: length(Delta)))); 
        dt2.DataTipRows(4) = dataTipTextRow('X Accel', Ax_deltaLine); 
        dt2.DataTipRows(5) = dataTipTextRow('Y Accel', Ay_deltaLine); 
        dt2.DataTipRows(6) = dataTipTextRow('Yaw Moment', M_deltaLine);

        % Combine all plots
        YMDSweepPlots{sweptParamIndex, 2} = [YMDSweepPlots{sweptParamIndex, 2}; YMDSweepPlot.delta];

    end

end

% Plot slip ratio isolines
for x = 1: length(SA)

    for y = 1: length(Delta)

        Ay_SXLine = squeeze(AySweepData(x, y, 1: length(SX)));
        M_SXLine = squeeze(MSweepData(x, y, 1: length(SX)));
        Ax_SXLine = squeeze(AxSweepData(x, y, 1: length(SX)));

        YMDSweepPlot.SX = plot3(YMDSweepAxes, Ay_SXLine, M_SXLine, Ax_SXLine, '-k'); 

        % Data tip setup
        dt3 = YMDSweepPlot.SX.DataTipTemplate;
        dt3.DataTipRows(1) = dataTipTextRow('Slip Angle', rad2deg(SA(x) * ones(size(1: length(SX))))); 
        dt3.DataTipRows(2) = dataTipTextRow('Steering Angle', rad2deg(Delta(y) * ones(size(1: length(SX)))));
        dt3.DataTipRows(3) = dataTipTextRow('Slip Ratio', SX); 
        dt3.DataTipRows(4) = dataTipTextRow('X Accel', Ax_deltaLine); 
        dt3.DataTipRows(5) = dataTipTextRow('Y Accel', Ay_deltaLine); 
        dt3.DataTipRows(6) = dataTipTextRow('Yaw Moment', M_deltaLine); 

        % Combine all plots
        YMDSweepPlots{sweptParamIndex, 3} = [YMDSweepPlots{sweptParamIndex, 3}; YMDSweepPlot.SX];

    end

end

assignin('base', 'YMDSweepPlots', YMDSweepPlots);

% End of function

end