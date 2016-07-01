% % Graphs histogram from fishSimData.mat and actual data. Used to compare
% % gain.
% clf
% % load fishSimData.mat
% % load Data/distLine_actual.mat distLine
% 
% % Get fish simulation data
% N_trial = 5;
% N_fish = 100;
% x_sim = zeros(10000,N_fish, N_trial); y_sim = zeros(10000,N_fish,N_trial); t_sim = zeros(10000,N_fish,N_trial);
% 
% tic
% parfor j=1:N_trial
%     [x1,y1,t1] = fishSim_7(N_fish,25);
%     x_sim(:,:,j) = x1;
%     y_sim(:,:,j) = y1;
%     t_sim(:,:,j) = t1;
% end
% toc
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

% Calculate +/- distance
tic
% parfor i = 1: N_resized
%     is_above = isAbove(x_resized(i), y_resized(i), LINE_START, LINE_END);
%     dist_list(i) = is_above * point_to_line(x_resized(i), y_resized(i), LINE_START, LINE_END);
% end
toc
% Build Histogram
figure
   
h1 = histogram(dist_list, 100);
hold on
h2 = histogram(distLine, 100);
h1.Normalization = 'probability';
h1.BinWidth = 0.05;
h2.Normalization = 'probability';
h2.BinWidth = 0.05;
legend('Simulation', 'Actual')
xlabel('Distance to Attraction Line')
ylabel('Number of Occurences')
title(sprintf('Histogram of Shark Distance to Att Line (Katt=%d and Krep=%d)',K_att, K_rep));
hold off
