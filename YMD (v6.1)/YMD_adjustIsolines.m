%% Function: Adjust Plot Isolines
% Hide/show the isolines of YMD single plot
function YMD_adjustIsolines

YMDAxes = evalin('base', 'YMDAxes');
lineSelect = evalin('base', 'lineSelect');
lines = get(YMDAxes, 'Children');

% Hide/show slip angle isolines
if lineSelect.SALine.Value

    for i = 1: length(lines)
        if isequal(lines(i).Color, [1 0 0])
            lines(i).Visible = 'on';
        end
    end

else

    for i = 1: length(lines)
        if isequal(lines(i).Color, [1 0 0])
            lines(i).Visible = 'off';
        end
    end

end

% Hide/show steering angle isolines
if lineSelect.deltaLine.Value

    for i = 1: length(lines)
        if isequal(lines(i).Color, [0 0 1])
            lines(i).Visible = 'on';
        end
    end

else

    for i = 1: length(lines)
        if isequal(lines(i).Color, [0 0 1])
            lines(i).Visible = 'off';
        end
    end

end

% Hide/show slip ratio isolines
if lineSelect.SXLine.Value

    for i = 1: length(lines)
        if isequal(lines(i).Color, [0 0 0])
            lines(i).Visible = 'on';
        end
    end

else

    for i = 1: length(lines)
        if isequal(lines(i).Color, [0 0 0])
            lines(i).Visible = 'off';
        end
    end

end

% End of function

end