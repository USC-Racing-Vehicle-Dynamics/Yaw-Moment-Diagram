%% Function: Progress

% Display a progress window when another function is running, 
% and close the window when that function ends

function YMD_progress(prompt)
    
%---------------------------*
% Progress Dialog: Progress |
%---------------------------*
fig = uifigure;

switch prompt

    case 1 % Make single YMD plot
    
        progress = uiprogressdlg(fig,'Title','YMD Single Plot','Indeterminate','on');
        progress.Message = 'Plotting...';
        drawnow
    
        YMD_updateParameters;
        YMD_makeYMD;
    
    case 2 % Make YMD sweep plot

        progress = uiprogressdlg(fig,'Title','YMD Sweep Plot');
        progress.Message = 'Start Plotting...';
        drawnow
    
        YMD_updateParameters;
        YMD_makeYMDSweep(progress);

    case 3 % Adjust plot views (single plot)

        progress = uiprogressdlg(fig,'Title','YMD Single Plot','Indeterminate','on');
        progress.Message = 'Adjusting Plot View...';
        drawnow
    
        YMD_adjustPlotView;

    case 4 % Adjust isolines (single plot)

        progress = uiprogressdlg(fig,'Title','YMD Single Plot','Indeterminate','on');
        progress.Message = 'Adjusting Isolines...';
        drawnow
    
        YMD_adjustIsolines;

    case 5 % Switch highlighted plot (sweep plot)

        progress = uiprogressdlg(fig,'Title','YMD Sweep Plot','Indeterminate','on');
        progress.Message = 'Switching Highlighted Plot...';
        drawnow
    
        YMD_highlightSweepPlot;

    case 6 % Export data (single plot)

        progress = uiprogressdlg(fig,'Title','YMD Single Plot','Indeterminate','on');
        progress.Message = 'Exporting Data...';
        drawnow
    
        YMD_exportData;

    case 7 % Make GGV diagram

        progress = uiprogressdlg(fig,'Title','GGV Diagram');
        progress.Message = 'Start Plotting...';
        drawnow
    
        YMD_updateParameters;
        YMD_makeGGV(progress);

end

close(fig);

% End of function

end