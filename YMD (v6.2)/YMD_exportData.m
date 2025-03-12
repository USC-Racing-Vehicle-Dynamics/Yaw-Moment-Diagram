%% Function: Export Data
% Export data to a .mat file
function YMD_exportData(prompt)

% Obtain vehicle parameters & YMD inputs
param = evalin('base', 'param');
SA = evalin('base', 'SA');
Delta = evalin('base', 'Delta');
SX = evalin('base', 'SX');

% Obtain YMD data
switch prompt

    % From single plot
    case 1
        Ax = evalin('base', 'AxData');
        Ay = evalin('base', 'AyData');
        M = evalin('base', 'MData');

        exportField = evalin('base', 'exportField');
        folderName = 'YMD Results';

    % From sweep plot
    case 2
        Ax = evalin('base', 'AxSweepData');
        Ay = evalin('base', 'AySweepData');
        M = evalin('base', 'MSweepData');
        exportField = evalin('base', 'exportField_sweep');

        folderName = 'YMD Sweep Results';

end

cd ..
status = mkdir(folderName);

% Save as .mat File
fileName = get(exportField.field, 'value');
save(folderName + "/" + fileName + ".mat", 'param', 'SA', 'Delta', 'SX', 'Ax', 'Ay', 'M');

end

