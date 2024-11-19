%% Function: Export Data
% Export data to a .mat file
function YMD_exportData

%% Obtain Data

Ay_betaLines = evalin('base', 'Ay_betaLines');
M_betaLines = evalin('base', 'M_betaLines');
exportField = evalin('base', 'exportField');

%% Save as .mat File

% Lateral acceleration data file
fileName1 = strcat(get(exportField.field1, 'value'), '.mat');
save(fileName1, "Ay_betaLines");

% Yaw moment data file
fileName2 = strcat(get(exportField.field2, 'value'), '.mat');
save(fileName2, "M_betaLines");

end

