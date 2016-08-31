% % Get d90 vs. att_lin_len and numsharks from T Matrix
% addpath('/Users/cherieho/multitarget_state_estimator/fishSim')
% 
% [xsim,ysim,tsim]=fishSim_7(100,25, 1e3, 1e6, 1e9); % Simulated 100 Sharks, 25m att line

function [d_90] = tMatrix_d90(xsim,ysim)
 % Get d90 from T Matrix given x and y trajectories
increment = 0.25;
T = transitionMatrix(xsim,ysim,increment); % T Matrix

% SS Prob
nBins = length(T);
p_int = 1/nBins * ones(1,nBins);
p_fin = getProbFromTMatrix(T,p_int,100000,increment);

% Probability x axis
max_vert_dist = 15;
hist_edges = -max_vert_dist:increment:max_vert_dist-increment;

% Find d_90 (90th percentile, one sided)
cu_sum = cumsum(p_fin);
d_90 = hist_edges(find(cu_sum > 0.98,1));

end
