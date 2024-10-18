%% Function: Update Parameters
% Update a user specified vehicle parameter in data tab
function YMD_updateParameters
    
paramField = evalin('base', 'paramField');
param =  evalin('base', 'param');
paramUnit = evalin('base', 'paramUnit');

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

assignin('base', 'param', param);

end