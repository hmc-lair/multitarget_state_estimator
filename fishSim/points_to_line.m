function line_error = points_to_line(x_sharks, y_sharks, line_start, line_end)
% Returns list of distance to line for a list of points.

    line_error = zeros(1,size(x_sharks, 2));
    for s=1:size(x_sharks, 2)
        line_error(s) = point_to_line(x_sharks(s), y_sharks(s), line_start, line_end);
    end

end