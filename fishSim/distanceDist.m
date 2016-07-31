% Graphs histogram from fishSimData.mat and actual data. Used to compare
% gain.
% clf

% Get fish simulation data

% function [x_sim, y_sim, t_sim] = distanceDist(N_fish, N_trial)
N_trial = 3;
N_fish = 112;
fishSim_ts = 5000;
x_sim = zeros(fishSim_ts,N_fish, N_trial); y_sim = zeros(fishSim_ts,N_fish,N_trial); t_sim = zeros(fishSim_ts,N_fish,N_trial);
parfor j=1:N_trial
    [x1,y1,t1] = fishSim_7(N_fish,25, 1e3, 1e6, 1e9);
%     [x1,y1,t1] = fishSim_7(N_fish,25, 1.873e-5, 1.49e-5, 0.0313);
    x_sim(:,:,j) = x1;
    y_sim(:,:,j) = y1;
    t_sim(:,:,j) = t1;
end
ts = size(x_sim,1);

% Resize vectors to fit histogram
x_resized = reshape(x_sim, [N_trial*ts*N_fish, 1]);
y_resized = reshape(y_sim, [N_trial*ts*N_fish, 1]);
N_resized = size(x_resized, 1);

dist_list = zeros(N_resized, 1);
dist_list = y_resized;
seg_length = 25;

LINE_START = [-seg_length/2 0];
LINE_END = [seg_length/2 0];

% Build Histogram
figure
max_vert_dist = 10;
increment = 1;
hist_edges = [-max_vert_dist:increment:max_vert_dist] ;

[fhist,xhist] = hist(dist_list(:),hist_edges);
[fhist_act,xhist_act] = hist(distLine(:),hist_edges);

norm_sim = fhist/(sum(fhist));
norm_act = fhist_act/(sum(fhist_act));

hold on
plot(xhist, norm_sim, '.','DisplayName', 'Simulation');
plot(xhist_act, norm_act,'.','DisplayName','Actual')
hold off 
h1 = histogram(dist_list, hist_edges);
hold on
h2 = histogram(distLine, hist_edges);
h1.Normalization = 'probability';
h1.BinWidth = 0.2;
h2.Normalization = 'probability';
h2.BinWidth = 0.2;
legend('Simulation', 'Actual')
xlabel('Distance to Attraction Line')
ylabel('Number of Occurences')
title('Histogram of Shark Distance to Att Line');
hold off
