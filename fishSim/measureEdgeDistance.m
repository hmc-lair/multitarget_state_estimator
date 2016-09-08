function dist = measureEdgeDistance(x_sharks, y_sharks, line_start, line_end)
% Finds width of line given line and leftmost and rightmost fish

rotAngle = atan2((line_end(2)-line_start(2)),(line_end(1)-line_start(1)));

xRot     = x_sharks*cos(rotAngle) - y_sharks*sin(rotAngle);
% yRot     = x_sharks*sin(rotAngle) + y_sharks*cos(rotAngle);

leftmost = min(xRot(:));
rightmost = max(xRot(:));

dist = rightmost - leftmost;