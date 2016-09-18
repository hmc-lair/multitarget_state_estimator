% % Get d90 vs. att_lin_len and numsharks from T Matrix
% addpath('/Users/cherieho/multitarget_state_estimator/fishSim')
% 
% [xsim,ysim,tsim]=fishSim_7(100,25, 1e3, 1e6, 1e9); % Simulated 100 Sharks, 25m att line

function [x_90, d_90] = tMatrix_d90(xsim,ysim, x_increment)
 % Get d90 from T Matrix given x and y trajectories
% x_increment = 5;
y_increment = 1;
[T_x, T_y] = transitionMatrix(xsim,ysim,x_increment, y_increment); % T Matrix

% SS Prob
nBins_y = length(T_y);
p_int_y = 1/nBins_y * ones(1,nBins_y);
p_fin_y = getProbFromTMatrix(T_y,p_int_y,100000,y_increment);

nBins_x = length(T_x);
p_int_x = 1/nBins_x * ones(1,nBins_x);
p_fin_x = getProbFromTMatrix(T_x,p_int_x,100000,x_increment);

% Probability x axis
max_vert_dist = 10;
hist_edges_y = -max_vert_dist:y_increment:max_vert_dist-y_increment;

max_hor_dist = 30;
hist_edges_x = -max_hor_dist:x_increment:max_hor_dist-x_increment;

figure('Visible','off')
hold on
plot(hist_edges_x, p_fin_x,'x','DisplayName','Probability from T Matrix')

%  Histogram
[fhist,xhist] = hist(xsim(:),hist_edges_x);
delta_x = xhist(2) - xhist(1);
plot(xhist, fhist/(sum(fhist)),'-o','DisplayName','Probability from Histogram')

hold off
title('Steady State Probability')
legend('show')
xlabel('Distance from Center of line')
ylabel('Probability')

saveas(gcf,sprintf('ss_prob_xinc_%d.png',x_increment))

% Find d_90 (90th percentile, one sided)
cu_sum_y = cumsum(p_fin_y);
d_90 = hist_edges_y(find(cu_sum_y > 0.95,1));

cu_sum_x = cumsum(p_fin_x);
x_90 = hist_edges_x(find(cu_sum_x > 0.95,1));
end
