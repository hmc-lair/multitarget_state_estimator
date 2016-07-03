% Function to find attraction and repulsion gains with GA

function [performance] = findGains(att_gains)
disp(att_gains)
K_att = att_gains(1);
K_temp_att = att_gains(2);
K_rep = att_gains(3);
K_con = att_gains(4);
% Get Simulation Data
tic
N_trial = 3;
N_fish = 112;
parfor j=1:N_trial
    [x1,y1,t1] = fishSim_7(N_fish,25, K_att, K_temp_att,K_rep, K_con);
    x_sim(:,:,j) = x1;
    y_sim(:,:,j) = y1;
    t_sim(:,:,j) = t1;
end
toc

% Build Histogram
max_vert_dist = 10;
increment = 0.1;
hist_edges = [-max_vert_dist:increment:max_vert_dist] ;

[fhist,xhist] = hist(y_sim(:),hist_edges);
norm_sim = fhist/(sum(fhist));
% norm_act = fhist_act/(sum(fhist_act));

load('norm_act.mat')

performance = sum(abs((norm_sim - norm_act).*hist_edges));

% T_sim = transitionMatrix(x_sim, y_sim, 0.05);
% T_act = transitionMatrix(xRot, yRot, 0.05);
% load('T_act.mat')
% T_diff = abs(T_act - T_sim); % Get Difference
% 
% diff = sum(T_diff(:))

end


