% Use to experiment with different robot motion planning and associated PF
% error

clf 
ts_pf = size(x_robots,2);
N_fish = size(x,2);

% [act_error, est_error, error, numshark_est, x_robots, y_robots] = ...
%     att_pf(x, y, t,[-25.5 0], [25.5 0], ts_pf, false)

subplot(2,2,[1 2]);
hold on
plot(x_robots',y_robots','x');
plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)], 'black');
xlabel('x (m)')
ylabel('y (m)')
title({'5 Robots Repulsed by Fish, Range: 10 m ','Robot Trajectory'});
hold off


subplot(2,2,3)
hold on
plot(error, '.')
plot([0 ts_pf], [0.1 0.1]);
title({'Performance Error', '(\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))'}) 
xlabel('Timestep (s)')

subplot(2,2,4)
hold on
plot([0 ts_pf], [N_fish N_fish]);
plot(numshark_est, '.');
legend('Actual', 'Estimated')
ylim([0 200]);
title({'Comparison of Actual and','Estimated Number of Sharks'})
xlabel('Timestep (s)')
hold off