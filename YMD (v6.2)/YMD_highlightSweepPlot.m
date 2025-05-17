%% Function: Highlight Sweep Plot

% Choose a plot corresponding to a certain value of swept parameter
% to be highlighted

function YMD_highlightSweepPlot

YMDSweepPlots = evalin('base', 'YMDSweepPlots');
sweep = evalin('base', 'sweep');
sweptParamList = evalin("base", 'sweptParamList');

sweptParamValue = str2double(sweptParamList.Value);
sweptParamIndex = find(abs(sweep.range - sweptParamValue) < 1e-2);

for i = 1: length(sweep.range)

    if i == sweptParamIndex

        set(YMDSweepPlots{i, 1}, 'color', 'r');
        set(YMDSweepPlots{i, 2}, 'color', 'b');
        set(YMDSweepPlots{i, 3}, 'color', 'k');
        uistack(YMDSweepPlots{i, 1}, 'top');
        uistack(YMDSweepPlots{i, 2}, 'top');
        uistack(YMDSweepPlots{i, 3}, 'top');

    else

        set(YMDSweepPlots{i, 1}, 'color', [0 0 0 0.1]);
        set(YMDSweepPlots{i, 2}, 'color', [0 0 0 0.1]);
        set(YMDSweepPlots{i, 3}, 'color', [0 0 0 0.1]);

    end

end

% End of function

end