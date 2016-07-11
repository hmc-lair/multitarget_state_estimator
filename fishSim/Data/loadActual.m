load Data/distLine_actual.mat

distLine = distLine([3 5:6 8:62  66:77 79 81 83:85 87:112], :)';
x_sharks = x([3 5:6 8:62 66:77 79 81 83:85 87:112], :)';
y_sharks = y([3 5:6 8:62 66:77 79 81 83:85 87:112], :)';
t_sharks = t([3 5:6 8:62 66:77 79 81 83:85 87:112], :)';

len = size(x_sharks,2);
weird = [2 4 7 9 12 14 19 57 60 61 75];
norm = setdiff([1:len],weird);

x_sharks = x_sharks(1:873,norm);
y_sharks = y_sharks(1:873,norm);
t_sharks = t_sharks(1:873,norm);
distLine = distLine(1:873,norm);

% Rotate Data
rotAngle = 0.213503;
xRot     = x_sharks*cos(rotAngle) - y_sharks*sin(rotAngle);
yRot     = x_sharks*sin(rotAngle) + y_sharks*cos(rotAngle);
plot(xRot,yRot,'.');
axis([-15 15 -15 15])





