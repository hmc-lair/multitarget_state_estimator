function [dist] = point_to_line( point_x, point_y, line_start, line_end  )
% Returns closest distance from point to line segment

pt = project_point_to_line_segment(line_start, line_end, [point_x, point_y]);

dist = sqrt((point_x - pt(1))^2 + (point_y - pt(2))^2);

end

