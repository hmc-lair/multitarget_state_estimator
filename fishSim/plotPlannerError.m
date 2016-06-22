% Use to experiment with different robot motion planning and plots 
% associated PF error

clf 

% ts_pf = size(x_robots,2);
ts_pf = 1000;
LINE_START = [-50 0];
LINE_END = [50 0];
N_fish = 100;
% LINE_START = [-10 2.28];
% LINE_END = [15 -3.139];
% N_fish = 112;
N_tag = N_fish;
% ts_pf = 33;


[act_error, est_error, error, numshark_est, x_robots, y_robots, numtag_range, segment_len] = ...
    att_pf(x, y, t, N_tag, LINE_START, LINE_END, ts_pf, false)

subplot(3,2,[1 2]);
hold on
plot(x_robots',y_robots','x');
plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)], 'black');
xlabel('x (m)')
ylabel('y (m)')

caption = sprintf('%d Robots Repulsed by Robot, Attracted to Line, Range: %d m, %d/%d Tagged \n Robot Trajectory',...
    N_robots, 100,N_tag, N_fish);
title(caption);
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
 

subplot(3,2,6)
hold on
plot([0 ts_pf], [act_len act_len]);
plot(segment_len, '.');
legend('Actual', 'Estimated')
title({'Comparison of Actual and','Estimated Number segment length'})
xlabel('Timestep (s)')
hold off

