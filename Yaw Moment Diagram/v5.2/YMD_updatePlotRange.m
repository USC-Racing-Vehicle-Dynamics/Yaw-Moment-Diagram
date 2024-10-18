%% Function: Update Plot Range
% Clip YMD data based on range sliders 
function YMD_updatePlotRange
    
    rangeSlider.beta = evalin('base', 'rangeSlider.beta');
    rangeSlider.delta = evalin('base', 'rangeSlider.delta');

    betaVal = get(rangeSlider.beta, 'value');
    deltaVal = get(rangeSlider.delta, 'value');
    
    Beta.lowerLimit = deg2rad(round(betaVal(1)));
    Beta.upperLimit = deg2rad(round(betaVal(2)));
    Delta.lowerLimit = deg2rad(round(deltaVal(1)));
    Delta.upperLimit = deg2rad(round(deltaVal(2))); 
    
    % Number of data points for each isoline entry
    numDataPts = evalin('base', 'numDataPts');
    Beta.range = linspace(Beta.lowerLimit, Beta.upperLimit, numDataPts);
    Delta.range = linspace(Delta.lowerLimit, Delta.upperLimit, numDataPts);

    assignin('base', 'Beta', Beta);
    assignin('base', 'Delta', Delta);

    YMD_makeSinglePlot;

end