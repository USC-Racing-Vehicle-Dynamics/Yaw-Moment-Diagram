%% Function: Export Data
% Export data to a .mat file
function YMD_exportData(prompt)

% Obtain vehicle parameters & YMD inputs
param = evalin('base', 'param');
SA = evalin('base', 'SA_deg.range');
Delta = evalin('base', 'Delta_deg.range');
SX = evalin('base', 'SX_deg.range');

% Obtain YMD data
switch prompt
   
    case 1 % Export data (single plot)

        Ax = evalin('base', 'AxData');
        Ay = evalin('base', 'AyData');
        M = evalin('base', 'MData');

        cd ..
        folderName = 'YMD Results';
        status = mkdir(folderName);
        
        % Save as .mat File
        exportField = evalin('base', 'editFields.export_field1');
        fileName = get(exportField, 'value');
        save(folderName + "/" + fileName + ".mat", 'param', 'SA', 'Delta', 'SX', 'Ax', 'Ay', 'M');

        cd 'YMD (v6.2)'

    case 2 % Export figure (single plot)

        YMD = evalin('base', 'panels.YMDPlotArea');

        cd ..
        folderName = 'YMD Results';
        status = mkdir(folderName);
        
        % Save as .fig
        exportField = evalin('base', 'editFields.export_field2');
        figName = get(exportField, 'value');
        exportgraphics(YMD, folderName + "/" + figName + ".jpg");

        cd 'YMD (v6.2)'
    
    case 3 % Export data (sweep plot)

        Ax = evalin('base', 'AxSweepData');
        Ay = evalin('base', 'AySweepData');
        M = evalin('base', 'MSweepData');
        sweptParameter = evalin('base', 'sweptParamInfo');

        cd ..
        folderName = 'YMD Sweep Results';
        status = mkdir(folderName);
        
        % Save as .mat File
        exportField = evalin('base', 'editFields.exportSweep');
        fileName = get(exportField, 'value');
        save(folderName + "/" + fileName + ".mat", 'param', 'sweptParameter', 'SA', 'Delta', 'SX', 'Ax', 'Ay', 'M');

        cd 'YMD (v6.2)'

end

end

