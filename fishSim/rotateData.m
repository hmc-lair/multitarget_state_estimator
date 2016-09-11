clf
hold on
% plot(x_sharks,y_sharks,'.');
% rotate by 30 clockwise around (0,0)
% http://en.wikipedia.org/wiki/Rotation_matrix
rotAngle = 0.213503;
xRot     = x_sharks*cos(rotAngle) - y_sharks*sin(rotAngle);
yRot     = x_sharks*sin(rotAngle) + y_sharks*cos(rotAngle);
plot(xRot,yRot,'.');
axis([-15 15 -15 15])
hold off