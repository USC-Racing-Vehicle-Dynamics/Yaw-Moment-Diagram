%% Function: Update Parameters
% Update a user specified vehicle parameter in data tab
function YMD_updateParameters
    
paramField = evalin('base', 'paramField');
param =  evalin('base', 'param');
paramUnit = evalin('base', 'paramUnit');
rangeField = evalin('base', 'rangeField');

% Mass [lb]
param.W = paramField.W.Value;            
       
% Front weight distribution [%]
param.fwd = paramField.fwd.Value;                  

% Wheelbase [in]
param.l = paramField.l.Value;                  

% Front track width [in]
param.t_F = paramField.t_F.Value;                  

% Rear track width [in]
param.t_R =paramField.t_R.Value;                  

% CG height [in]
param.h = paramField.h.Value;                  

% Front roll center height [in]
param.z_RF = paramField.z_RF.Value;                  

% Rear roll center height [in]
param.z_RR = paramField.z_RR.Value;                  

% Ackermann [%]
param.ackermann = paramField.ackermann.Value;                  

% Front toe [deg]
param.toe_f = paramField.toe_f.Value;                  

% Rear toe [deg]
param.toe_r = paramField.toe_r.Value;                  

% Tire spring rate [lb/in]
param.tire_k = paramField.tire_k.Value;                  

% Front spring stiffness [lb/in]
param.f_spring_k = paramField.f_spring_k.Value;                  

% Rear spring stiffness [lb/in]
param.r_spring_k = paramField.r_spring_k.Value;                  

% Front ARB stiffness [lb/in]
param.f_arb_k = paramField.f_arb_k.Value;                  

% Rear ARB stiffness [lb/in]
param.r_arb_k = paramField.r_arb_k.Value;                  

% Coefficient of lift
param.C_L = paramField.C_L.Value;                  

% Center of pressure [%]
param.CoP = paramField.CoP.Value;                  

% Velocity [mph]/[kph]/[ft/s]
switch paramUnit.V.Value

    case 'mph'
        param.V.mph = paramField.V.Value;
        param.V.fts = 1.46667 * param.V.mph;
        param.V.kph = 1.60934 * param.V.mph;

    case 'fts'
        param.V.fts = paramField.V.Value;
        param.V.mph = param.V.fts / 1.46667;
        param.V.kph = 1.60934 * param.V.mph;

    case 'kph'
        param.V.kph = paramField.V.Value;
        param.V.mph = param.V.kph / 1.60934;
        param.V.fts = 1.46667 * param.V.mph;
        
end

% Slip angle data
SA_deg.lowerLimit = rangeField.SAField1.Value;
SA_deg.upperLimit = rangeField.SAField2.Value;
SA_deg.dataPts = rangeField.SAField3.Value;
SA_deg.range = linspace(SA_deg.lowerLimit, SA_deg.upperLimit, SA_deg.dataPts);
SA_rad_range = deg2rad(SA_deg.range);

% Steering angle data
Delta_deg.lowerLimit = rangeField.deltaField1.Value;
Delta_deg.upperLimit = rangeField.deltaField2.Value;
Delta_deg.dataPts = rangeField.deltaField3.Value;
Delta_deg.range = linspace(Delta_deg.lowerLimit, Delta_deg.upperLimit, Delta_deg.dataPts);
Delta_rad_range = deg2rad(Delta_deg.range);

% Slip ratio data
SX_deg.lowerLimit = rangeField.SXField1.Value;
SX_deg.upperLimit = rangeField.SXField2.Value;
SX_deg.dataPts = rangeField.SXField3.Value;
SX_deg.range = linspace(SX_deg.lowerLimit, SX_deg.upperLimit, SX_deg.dataPts);
SX_rad_range = deg2rad(SX_deg.range);

%% Assign Data to Base Workspace

assignin('base', 'param', param);
assignin('base', 'SA_deg', SA_deg);
assignin('base', 'SA_rad_range', SA_rad_range);
assignin('base', 'Delta_deg', Delta_deg);
assignin('base', 'Delta_rad_range', Delta_rad_range);
assignin('base', 'SX_deg', SX_deg);
assignin('base', 'SX_rad_range', SX_rad_range);

end