dfunction [x90_list, yRot, seg_len] = measureEdgeDistance(x_sharks, y_sharks, line_start, line_end)
% Finds width of line given line and leftmost and rightmost fish

rotAngle = atan2((line_end(2)-line_start(2)),(line_end(1)-line_start(1)));

xRot     = x_sharks*cos(rotAngle) - y_sharks*sin(rotAngle);
yRot     = x_sharks*sin(rotAngle) + y_sharks*cos(rotAngle);

leftmost = min(xRot(:));
rightmost = max(xRot(:));
topmost = max(yRot(:));
bottommost = min(yRot(:));

% dist_x = rightmost - leftmost;
x90_list = prctile(xRot,95) - prctile(xRot,50);
% x90_list = abs((xRot - mean(xRot)))';
yRot = yRot';
seg_len = rightmost - leftmost;

end