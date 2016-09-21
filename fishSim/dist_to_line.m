function distance = dist_to_line(px, py, line_start, line_end)
% px and py: Point
% x1 and y1: Segment Start, x2 and y2: Segment End

% Calculate distance from point to line. Assumes line is infinitely long.


a = [line_start 0] - [line_end 0];
b = [px py 0] - [line_end 0];
distance = norm(cross(a,b))/norm(a);
% v = line_end - line_start;
% w = [px py] - line_start;
% 
% c1 = dot(v, w);
% 
% 
% distance = 0;
% 
% if c1 <= 0
%     dist_shark = dist(px, py, line_start(1), line_start(2));
% 
% else
%     c2 = dot(v,v);
%     if c2 <= c1
%         dist_shark = dist(px, py, line_end(1), line_end(2));
%     
%     else
%         b = c1/c2;
%         Pb = line_start + b * v;
%         dist_shark = dist(px, py, Pb(1), Pb(2));
%     end
% end
% 
% distance = dist_shark;
end