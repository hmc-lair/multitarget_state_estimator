% Use to experiment with different robot motion planning and associated PF
% error

clf 
% ts_pf = size(x_robots,2);
ts_pf = 1000;
LINE_START = [-50 0];
LINE_END = [50 0];
N_fish = size(x,2);
N_tag = N_fish;

[act_error, est_error, error, numshark_est, x_robots, y_robots, numtag_range, seg_len] = ...
    att_pf(x, y, t, N_tag, LINE_START, LINE_END, ts_pf, false)

subplot(2,2,1);
hold on
plot(x_robots',y_robots','x');
plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)], 'black');
xlabel('x (m)')
ylabel('y (m)')
title({'5 Robots Repulsed by Robots, Attracted to Line, Range: 50 m, 75/75 Tagged ','Robot Trajectory'});
hold off

subplot(2,2,2)
plot(numtag_range, 'x')
title('Number of tags within robot range')
xlabel('Timestep (s)')
ylabel('Number of Tags')

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
% 
% x_graph = x_robots';
% y_graph = y_robots';
% for i = 1: ts_pf
%     hold on
%     plot(x_graph(i,:), y_graph(i,:), '.');
%     pause(0.0001)
%     hold off
% end