function [x_smooth, y_smooth, t_smooth] = smoothTraj(x_raw, y_raw, t_raw)
% Smooth Trajectory over a 10 Frame window
a = 1;
b = 1/10 * ones(1,10);

x_smooth = filter(b,a,x_raw);
y_smooth = filter(b,a,y_raw);
t_smooth = filter(b,a,t_raw);

for i = 1:9
    x_smooth(1:9,:) = x_raw(1:9,:);
    y_smooth(1:9,:) = y_raw(1:9,:);
    t_smooth(1:9,:) = t_raw(1:9,:);
end

% hold on 
% plot(x_smooth(:,1),'.')
% plot(x_raw(:,1),'.')
% hold off

end