% Plot smoothed velocity and acceleration
function [acc_filt] = filtAcc(x, y)
ts = 1/30;

disp_x = diff(x);
disp_y = diff(y);
v = sqrt(disp_x.^2 + disp_y.^2)/ts;
acc = diff(v)/ts;
Nsmooth = 10;
a = 1;
b = 1/Nsmooth * ones(1,Nsmooth);
acc_smooth = filter(b,a,acc);

[b_but, a_but] = butter(6,0.1);
acc_filt = filter(b_but, a_but, acc);

% hold on
% plot(acc_smooth,'.')
% plot(acc_filt(:,10),'.')
% hold off

end
