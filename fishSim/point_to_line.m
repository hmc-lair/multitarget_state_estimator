function [dist] = point_to_line( point_x, point_y, line_start, line_end  )
%POINT_TO_LINE Summary of this function goes here
%   Detailed explanation goes here

x0 = point_x;
y0 = point_y;
x1 = line_start(1);
y1 = line_start(2);
x2 = line_end(1);
y2 = line_end(2);

num = abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1);
den = sqrt( (y2-y1)^2 + (x2 - x1)^2);

dist = num/den
end

