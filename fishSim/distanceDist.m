% Graphs histogram from fishSimData.mat and actual data. Used to compare
% gain.
clf
load fishSimData.mat
load Data/distLine_actual.mat distLine

x_resized = reshape(x, [4000*N_fish, 1]);
y_resized = reshape(y, [4000*N_fish, 1]);
N_resized = size(x_resized, 1);

dist = zeros(N_resized, 1);

for i = 1: N_resized
    is_above = isAbove(x_resized(i), y_resized(i), LINE_START, LINE_END);
    dist(i) = is_above * point_to_line(x_resized(i), y_resized(i), LINE_START, LINE_END);
end

figure
   
h1 = histogram(dist, 500);
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
