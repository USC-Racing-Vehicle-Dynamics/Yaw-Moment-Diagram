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

    % Export from single plot
    case 1
        Ax = evalin('base', 'AxData');
        Ay = evalin('base', 'AyData');
        M = evalin('base', 'MData');

        cd ..
        folderName = 'YMD Results';
        status = mkdir(folderName);
        
        % Save as .mat File
        exportField = evalin('base', 'exportField');
        fileName = get(exportField.field, 'value');
        save(folderName + "/" + fileName + ".mat", 'param', 'SA', 'Delta', 'SX', 'Ax', 'Ay', 'M');

    % Export from sweep plot
    case 2

        Ax = evalin('base', 'AxSweepData');
        Ay = evalin('base', 'AySweepData');
        M = evalin('base', 'MSweepData');
        sweptParameter = evalin('base', 'sweptParamInfo');

        cd ..
        folderName = 'YMD Sweep Results';
        status = mkdir(folderName);
        
        % Save as .mat File
        exportField = evalin('base', 'exportField_sweep');
        fileName = get(exportField.field, 'value');
        save(folderName + "/" + fileName + ".mat", 'param', 'sweptParameter', 'SA', 'Delta', 'SX', 'Ax', 'Ay', 'M');

end

end

