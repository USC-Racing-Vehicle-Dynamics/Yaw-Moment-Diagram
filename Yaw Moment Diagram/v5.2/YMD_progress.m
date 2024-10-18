%% Function: Progress
% Display a progress window when another function is running, 
% and close the window when that function ends
function YMD_progress(prompt)
    
%---------------------------*
% Progress Dialog: Progress |
%---------------------------*
fig = uifigure;

switch prompt

    case 1 % Make single plot
    
        progress = uiprogressdlg(fig,'Title','YMD Single Plot','Indeterminate','on');
        progress.Message = 'Plotting...';
        drawnow
    
        YMD_updateParameters;
        YMD_makeSinglePlot;
    
    case 2 % Make sweep plot

        progress = uiprogressdlg(fig,'Title','YMD Sweep Plot','Indeterminate','on');
        progress.Message = 'Plotting...';
        drawnow
    
        YMD_makeSweepPlot;

    case 3 % Adjust plot ranges (single plot)

        progress = uiprogressdlg(fig,'Title','YMD Single Plot','Indeterminate','on');
        progress.Message = 'Adjusting Plot Ranges...';
        drawnow
    
        YMD_updatePlotRange;

    case 4 % Switch highlighted plot (sweep plot)

        progress = uiprogressdlg(fig,'Title','YMD Sweep Plot','Indeterminate','on');
        progress.Message = 'Switching Highlighted Plot...';
        drawnow
    
        YMD_highlightSweepPlot;

    case 5 % Export data (sweep plot)

        progress = uiprogressdlg(fig,'Title','YMD Single Plot','Indeterminate','on');
        progress.Message = 'Exporting Data...';
        drawnow
    
        YMD_exportData;

end

close(fig)

end