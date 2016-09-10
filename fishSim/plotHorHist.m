% Graphs histogram from fishSimData.mat and actual data. Used to compare
% gain.
clf
load Data/FishSim/fishSim_100Sharks_25m.mat
TS_PF = 1000;
% N_fish = 100;
% seg_length = 50;
% N_sim = 20;
line_start = [-seg_length/2,0];
line_end = [seg_length/2,0];

edge_distance_list = zeros(TS_PF, N_fish, N_sim);

% Calculate Edge Distance
for i = 1:N_sim
    for j = 1:TS_PF
        edge_distance_list(j,:,i) = measureEdgeDistance(x_fish_sim(j,:,i), y_fish_sim(j,:,i), line_start, line_end);
    end
end

% Actual Data
% for i = 1:size(xRot,1)
%         edge_distance_list(i,:) = measureEdgeDistance(xRot(i,:), yRot(i,:), line_start, line_end);
% end


figure
   
h1 = histogram(edge_distance_list(:), 50);
% hold on
% h2 = histogram(distLine, 500);
% h1.Normalization = 'probability';
% h1.BinWidth = 0.05;
% h2.Normalization = 'probability';
% h2.BinWidth = 0.05;
% legend('Simulation', 'Actual')
title(sprintf('Distance along line for %d Sharks and %d m attraction line', N_fish, seg_length))
xlabel('Distance along Attraction Line(m)')
ylabel('Number of Occurences')
% hold off
