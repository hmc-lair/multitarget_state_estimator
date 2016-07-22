% Plot velocity and acceleration
ts = 1/30;

disp_x = diff(x_sharks(:,1));
disp_y = diff(y_sharks(:,1));
v = sqrt(disp_x.^2 + disp_y.^2)/ts;