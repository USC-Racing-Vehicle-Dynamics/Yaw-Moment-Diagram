%% Function: Export Data
% Export data to a .mat file
function YMD_exportData(prompt)

% Obtain data
switch prompt

    case 1
        Ay = evalin('base', 'Ay_SALines');
        M = evalin('base', 'M_SALines');
        exportField = evalin('base', 'exportField');

    case 2
        Ay = evalin('base', 'AySweepData');
        M = evalin('base', 'MSweepData');
        exportField = evalin('base', 'exportField');

end

% Save as .mat File
% Lateral acceleration data file
fileName1 = strcat(get(exportField.field1, 'value'), '.mat');
save(fileName1, "Ay");

% Yaw moment data file
fileName2 = strcat(get(exportField.field2, 'value'), '.mat');
save(fileName2, "M");

end

