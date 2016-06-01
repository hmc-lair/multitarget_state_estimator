function total_error = totalSharkDistance(x_sharks, y_sharks, line_start, line_end)

    x1 = line_start(1);
    y1 = line_start(2);
    x2 = line_end(1);
    y2 = line_end(2);

    Z = 0;
    
    for s=1:size(x_sharks, 2)
        error = point_to_line(x_sharks(s), y_sharks(s), [x1, y1], [x2, y2]);
        Z = Z + error;
    end
    
    total_error = Z;
end