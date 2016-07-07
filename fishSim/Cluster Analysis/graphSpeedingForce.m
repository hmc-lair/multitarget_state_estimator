
function [av_speedF] = graphSpeedingForce(x_cluster, y_cluster, t_cluster)
% Look at speeding force from 2 fish interactions
% Based on "Inferring the structure and dynamics of interactions in
% schooling fish" by Y. Katz
ns = size(x_cluster,2);
ts_total = size(x_cluster,1);
ts = 1/30;

x_focal = x_cluster(:,1); % Focal Fish Orig x,y
y_focal = y_cluster(:,1);
t_focal = t_cluster(:,1);

% Centralize on one fish
x_nb = x_cluster(:,2:end) - x_focal;
y_nb = y_cluster(:,2:end) - y_focal;
t_nb = t_cluster(:,2:end) - t_focal;

t_nb = arrayfun(@angleDiff,t_nb);

x_cent = [zeros(ts_total,1), x_nb]; % x,y,t of fish with focal fish at center
y_cent = [zeros(ts_total,1), x_nb];
t_cent = [zeros(ts_total,1), x_nb];

% Velocity and Acceleration of focal fish
disp_x = diff(x_focal);
disp_y = diff(y_focal);
v = sqrt(disp_x.^2 + disp_y.^2)/ts;
a = diff(v)/ts;

% Make Grid
max_dist = 1;
increment = 0.1;
edges = [-max_dist:increment:max_dist] ;
N_xbins = length(edges);
N_ybins = length(edges);
N_bins = N_xbins^2;

x_nodes = discretize(x_nb,edges);
y_nodes = N_ybins - discretize(y_nb,edges);

speed_force = cell(N_xbins,N_ybins);

for i = 1:ts_total-2
    xnode_i = x_nodes(i+2);
    ynode_i = y_nodes(i+2);
    speed_force{ynode_i, xnode_i} = [speed_force{ynode_i, xnode_i} , a(i)];
end

plot(x_nb,y_nb,'.')

av_speedF = cellfun(@nanmean, speed_force);
imagesc(edges, edges, av_speedF)
colorbar
end


