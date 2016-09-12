function [x90, d90, seg_len] = measureEdgeDistance(x_sharks, y_sharks, line_start, line_end)
% Finds width of line given line and leftmost and rightmost fish

rotAngle = atan2((line_end(2)-line_start(2)),(line_end(1)-line_start(1)));

xRot     = x_sharks*cos(rotAngle) - y_sharks*sin(rotAngle);
yRot     = x_sharks*sin(rotAngle) + y_sharks*cos(rotAngle);

leftmost = min(xRot(:));
rightmost = max(xRot(:));
topmost = max(yRot(:));
bottommost = min(yRot(:));

% dist_x = rightmost - leftmost;
x90 = prctile(xRot,90) - prctile(xRot,50);
d90 = prctile(yRot,90);
seg_len = rightmost - leftmost;

end