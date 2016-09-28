% % Get d90 vs. att_lin_len and numsharks from T Matrix
% addpath('/Users/cherieho/multitarget_state_estimator/fishSim')
% 
% [xsim,ysim,tsim]=fishSim_7(100,25, 1e3, 1e6, 1e9); % Simulated 100 Sharks, 25m att line

function [x_90, d_90] = tMatrix_d90(xsim,ysim)
%% Get d90 from T Matrix given x and y trajectories
tic
x_increment = 0.5;
y_increment = 0.5;
[T_x, T_y] = transitionMatrix(xsim,ysim,x_increment, y_increment); % T Matrix

%% SS Prob
nBins_y = length(T_y);
p_int_y = 1/nBins_y * ones(1,nBins_y);
p_fin_y = getProbFromTMatrix(T_y,p_int_y,100000,y_increment);

nBins_x = length(T_x);
p_int_x = 1/nBins_x * ones(1,nBins_x);
p_fin_x = getProbFromTMatrix(T_x,p_int_x,100000,x_increment);

%% Probability x axis
max_vert_dist = 10;
hist_edges_y = -max_vert_dist:y_increment:max_vert_dist-y_increment;

max_hor_dist = 35;
hist_edges_x = -max_hor_dist:x_increment:max_hor_dist-x_increment;

%% Plot Figure
% 
% figure('Visible','off')

% plot(hist_edges_x,p_fin_x,'-o','DisplayName','Probability from T Matrix')
% [fhist,xhist] = hist(xsim(:),hist_edges_x);
% plot(xhist, fhist/(sum(fhist)),'-o','DisplayName','Probability from Histogram')

% hold on
% plot(hist_edges_x, p_fin_x,'x','DisplayName','Distance Along line')
title('Steady State Probability for Distance From Line')
plot(hist_edges_y, p_fin_y,'.','DisplayName','Probability from T Matrix')
hold on
[fhist_y,xhist_y] = hist(ysim(:),hist_edges_y);
plot(xhist_y, fhist_y/(sum(fhist_y)),'-o','DisplayName','Probability from Histogram')
% hold off
xlabel('Distance (m)')
ylabel('Probability')
legend('show')
% saveas(gcf,sprintf('ss_prob_xinc_%d.png',x_increment))

%% Find d_90 (90th percentile, one sided)
cu_sum_y = cumsum(p_fin_y);
d_90 = hist_edges_y(find(cu_sum_y > 0.95,1)) - hist_edges_y(find(cu_sum_y > 0.5,1))

cu_sum_x = cumsum(p_fin_x);
x_90 = hist_edges_x(find(cu_sum_x > 0.95,1)) - hist_edges_x(find(cu_sum_x > 0.5,1))
toc
end
