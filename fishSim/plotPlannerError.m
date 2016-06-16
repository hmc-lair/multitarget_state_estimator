% Use to experiment with different robot motion planning and associated PF
% error

clf 
ts_pf = size(x_robots,2);
N_fish = size(x,2);
act_len = 51;
dens = 1;

% [act_error, est_error, error, numshark_est, x_robots, y_robots] = ...
%     att_pf(x, y, t,[-25.5 0], [25.5 0], ts_pf, false)

subplot(3,2,[1,2]);
hold on
plot(x_robots',y_robots','x');
plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)], 'black');
xlabel('x (m)')
ylabel('y (m)')
title({'5 Robots Repulsed by Robot, Attracted to Line, Range: 10 m, 50/50 Tagged ','Robot Trajectory'});
hold off

subplot(3,2,3)
plot(numtag_range, 'x')
title('Number of tags within robot range')
xlabel('Timestep (s)')
ylabel('Number of Tags')

subplot(3,2,4)
hold on
plot(error, '.')
plot([0 ts_pf], [0.1 0.1]);
title({'Performance Error', '(\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))'}) 
xlabel('Timestep (s)')

subplot(3,2,5)
hold on
plot([0 ts_pf], [dens dens]);
plot(numshark_est, '.');
legend('Actual', 'Estimated')
title({'Comparison of Actual and','Estimated Shark Density'})
xlabel('Timestep (s)')
hold off

subplot(3,2,6)
hold on
plot([0 ts_pf], [act_len act_len]);
plot(segment_len, '.');
legend('Actual', 'Estimated')
title({'Comparison of Actual and','Estimated Segment Length'})
xlabel('Timestep (s)')
hold off