%% Function: Adjust Plot View
% Change the view of YMD single plot by adjusting 3D view
function YMD_adjustPlotView

YMDAxes = evalin('base', 'YMDAxes');
viewSelect = evalin('base', 'viewSelect');

switch(viewSelect.ValueIndex)

    case 1 % XY view

        view(YMDAxes, [0 0 1]);

    case 2 % XZ view

        view(YMDAxes, [0 -1 0]);

    case 3 % YZ view

        view(YMDAxes, [1 0 0]);

    case 4 % Isometric view

        view(YMDAxes, [-1 -1 1]);

end

% End of function

end