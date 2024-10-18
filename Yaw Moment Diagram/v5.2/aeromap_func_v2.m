function [f_DF,r_DF] = aeromap_func_v2(front_RH,rear_RH,velocity)
%Ride heights are in ft convereted to inches, velocity in ft/s converted to m/s, output is in lbf. as the aeromap is
%only for positive values, if RH are above 0, the current nominal value, it
%just takes the upper most value and uses velocity to get value

%% UNIT CONVERSIONS
velocity = velocity/3.28; %from ft/s to m/s
front_RH = front_RH*12; %from ft to in
rear_RH = rear_RH*12;
%% CHECKS 
%we need to ensure we are within the allowed range
if front_RH>0
    front_RH = 0;
end

if rear_RH>0
    rear_RH = 0;
end

if front_RH<-1.2
    front_RH = -1.2;
end

if rear_RH<-1.2
    rear_RH = -1.2;
end
%% DATA DUMP
%get the data fromt CFD

%RH data points
d_frh = [0 -0.4 -0.8 -1.2]; %in inches
d_rrh = [0 -0.4 -0.8 -1.2];

%DF in lbf for given RH
frontDF = [29.29928392  28.79015397 25.77346926 22.96878569;
           33.86783051  32.71584643	28.83757135	23.37558987;
           38.41231684	37.34239081	32.9983646	29.02513123;
           37.51904192	38.23864914	35.25052723	33.63028828];

rearDF = [41.69955486	45.38541805	41.87498595	39.55442414;
          38.61837585	43.20291778	37.93898737	34.28875334;
          37.02759979	40.15650196	35.15529795	33.17611684;
          33.62302481	34.9709346	31.26484274	32.56116606];

%% Get Cd
rho = 1.225; % kg/m^3
v = 15.64; % m/s
A = 1; % m^2

%get coff. values array
C_front_array = frontDF./(0.5*rho*v^2*A);
C_rear_array = rearDF./(0.5*rho*v^2*A);

%% Calculated DF

%interpolate coeff. given RH values
C_front = interp2(d_rrh,d_frh,C_front_array,rear_RH, front_RH,'linear');
C_rear = interp2(d_rrh,d_frh,C_rear_array,rear_RH,front_RH,'linear');

%calcualte DF
f_DF = (0.5)*C_front*rho*(velocity^2)*A;
r_DF = (0.5)*C_rear*rho*(velocity^2)*A;

end


