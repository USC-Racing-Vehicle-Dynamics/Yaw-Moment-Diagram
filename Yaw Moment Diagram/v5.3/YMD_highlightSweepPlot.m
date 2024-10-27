%% Function: Highlight Sweep Plot

% Choose a plot corresponding to a certain value of swept parameter
% to be highlighted

function YMD_highlightSweepPlot

YMDSweepPlots = evalin("base", 'YMDSweepPlots');
sweptParamSpace = evalin('base', 'sweptParamSpace');
sweptParamList = evalin("base", 'sweptParamList');

sweptParamValue = str2double(sweptParamList.Value);
sweptParamIndex = find(abs(sweptParamSpace - sweptParamValue) < 1e-2);

for i = 1: length(sweptParamSpace)

    if i == sweptParamIndex

        [YMDSweepPlots{i}(:, 1).Color] = deal('b');
        [YMDSweepPlots{i}(:, 2).Color] = deal('r');
        uistack(YMDSweepPlots{i}(:, 1), 'top');
        uistack(YMDSweepPlots{i}(:, 2), 'top');

    else

        [YMDSweepPlots{i}.Color] = deal([0.8 0.8 0.8 0.05]);

    end

end

end