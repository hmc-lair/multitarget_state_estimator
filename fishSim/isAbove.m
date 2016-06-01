function above = isAbove(point_x, point_y, line_start, line_end)
% Determine if point is below or above the line
% line_start format: [x, y]
% line_end format: [x, y]

    x1 = line_start(1);
    y1 = line_start(2);
    x2 = line_end(1);
    y2 = line_end(2);
    slope = (y2-y1)/(x2-x1);
    
    y_int = slope * -x1 + y1;
    
    act_y = slope * point_x + y_int;
    
    
    above = 1;
    if point_y < act_y
        above = -1;
    end

end