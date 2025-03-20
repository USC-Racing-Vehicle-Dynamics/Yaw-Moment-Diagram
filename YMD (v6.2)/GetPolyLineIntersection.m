
function [isIntersected, interPoint] = GetPolyLineIntersection(polyLine1, polyLine2)
    interPoint = [nan nan nan];
    isIntersected = false;

    %%Check data of polyline1
    %%Must be 2 rows data
    %%Row 1 is X data
    %%Row 2 is Y data
    [m, n1] = size(polyLine1);
    if m ~= 2 || n1 < 2 
        return;
    end
    n1 = n1 - 1;

    %%Check data of polyline2
    [m, n2] = size(polyLine2);
    if m ~= 2 || n2 < 2
        return;
    end
    n2 = n2 - 1;

    for i = 1 : n1
        x1 = polyLine1(1, i);
        y1 = polyLine1(2, i);
        x2 = polyLine1(1, i+1);
        y2 = polyLine1(2, i+1);
        line1= [x1, y1, x2, y2];
        for j = 1 : n2
            x1 = polyLine2(1, j);
            y1 = polyLine2(2, j);
            x2 = polyLine2(1, j+1);
            y2 = polyLine2(2, j+1);
            line2= [x1, y1, x2, y2];
            [isIntersected, interPoint] = GetLineIntersection(line1, line2);
            if isIntersected == true
                return;
            end
        end

    end

end

function [isIntersected, interPoint] = GetLineIntersection(line1, line2)

    interPoint = [nan nan nan];
    isIntersected = false;

    %%Check data
    [m, n] = size(line1);
    if m ~= 1 || n ~= 4 
        return;
    end

    [m, n] = size(line2);
    if m ~= 1 || n ~= 4
        return;
    end
    a = [line1(1), line1(2), 0];
    b = [line1(3), line1(4), 0];
    c = [line2(1), line2(2), 0];
    d = [line2(3), line2(4), 0];
    s1 = AreaTriangle(a, b, c);
    s2 = AreaTriangle(a, b, d);
    if s1*s2 >= 0
        return;     %%Has no intersection
    end
    s1 = AreaTriangle(c, d, a);
    s2 = AreaTriangle(c, d, b);
    if s1*s2 >= 0
        return;     %%Has no intersection
    end

    t = s1 /( s1 - s2);
    interPoint = a + (b - a) * t;
    isIntersected = true;
      
    
end

function [s] = AreaTriangle(a, b, c)
    r1 = b - a;
    r2 = c - a;
    s3 = cross(r1, r2) / 2.0;
    s = s3(3);
end