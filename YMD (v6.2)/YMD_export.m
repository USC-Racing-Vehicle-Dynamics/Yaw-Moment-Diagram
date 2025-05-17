%% Function: Export Data
% Export data to a .mat file
function YMD_export(prompt)

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

        Ax = evalin('base', 'AxData_sweep');
        Ay = evalin('base', 'AyData_sweep');
        M = evalin('base', 'MData_sweep');
        sweptParameter = evalin('base', 'sweptParamInfo');

        cd ..
        folderName = 'YMD Sweep Results';
        status = mkdir(folderName);
        
        % Save as .mat File
        exportField = evalin('base', 'editFields.exportSweepDataName');
        fileName = get(exportField, 'value');
        save(folderName + "/" + fileName + ".mat", 'param', 'sweptParameter', 'SA', 'Delta', 'SX', 'Ax', 'Ay', 'M');

        cd 'YMD (v6.2)'
    
    case 4 % Export figure (sweep plot)

        YMD = evalin('base', 'panels.YMDSweepArea');

        cd ..
        folderName = 'YMD Sweep Results';
        status = mkdir(folderName);
        
        % Save as .fig
        exportField = evalin('base', 'editFields.exportSweepFigName');
        figName = get(exportField, 'value');
        exportgraphics(YMD, folderName + "/" + figName + ".jpg");

        cd 'YMD (v6.2)'

    case 5 % Export data (GGV plot)

        Ax = evalin('base', 'AxData_GGV');
        Ay = evalin('base', 'AyData_GGV');
        V = evalin('base', 'V.range');

        cd ..
        folderName = 'GGV Results';
        status = mkdir(folderName);

        % Save as .mat File
        exportField = evalin('base', 'editFields.exportGGVDataName');
        fileName = get(exportField, 'value');
        save(folderName + "/" + fileName + ".mat", 'param', 'SA', 'Delta', 'SX', 'Ax', 'Ay', 'V');

        cd 'YMD (v6.2)'

    case 6 % Export figure (GGV plot)

        YMD = evalin('base', 'panels.GGVArea');

        cd ..
        folderName = 'GGV Results';
        status = mkdir(folderName);
        
        % Save as .fig
        exportField = evalin('base', 'editFields.exportGGVFigName');
        figName = get(exportField, 'value');
        exportgraphics(YMD, folderName + "/" + figName + ".jpg");

        cd 'YMD (v6.2)'
        
end

end

