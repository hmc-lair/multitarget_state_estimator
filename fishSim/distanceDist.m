% Graphs histogram from fishSimData.mat and actual data. Used to compare
% gain.
clf
% load fishSimData.mat
% load Data/distLine_actual.mat distLine

% Get fish simulation data
N_trial = 5;
N_fish = 112;
x = zeros(2000,N_fish, N_trial); y = zeros(2000,N_fish,N_trial); t = zeros(2000,N_fish,N_trial);
parfor j=1:N_trial
    [x1,y1,t1] = fishSim_7(112,25);
    x(:,:,j) = x1;
    y(:,:,j) = y1;
    t(:,:,j) = t1;
end

% Resize vectors to fit histogram
x_resized = reshape(x, [N_trial*7000*N_fish, 1]);
y_resized = reshape(y, [N_trial*7000*N_fish, 1]);
N_resized = size(x_resized, 1);

dist_list = zeros(N_resized, 1);
seg_length = 25;

LINE_START = [-seg_length/2 0];
LINE_END = [seg_length/2 0];

% Calculate +/- distance
parfor i = 1: N_resized
    is_above = isAbove(x_resized(i), y_resized(i), LINE_START, LINE_END);
    dist_list(i) = is_above * point_to_line(x_resized(i), y_resized(i), LINE_START, LINE_END);
end

% Build Histogram
figure
   
h1 = histogram(dist_list, 500);
hold on
h2 = histogram(distLine, 500);
h1.Normalization = 'probability';
h1.BinWidth = 0.05;
h2.Normalization = 'probability';
h2.BinWidth = 0.05;
legend('Simulation', 'Actual')
xlabel('Distance to Attraction Line')
ylabel('Number of Occurences')
title(sprintf('Histogram of Shark Distance to Att Line (Katt=%d and Krep=%d)',K_att, K_rep));
hold off
