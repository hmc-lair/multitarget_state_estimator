
function [av_speedF] = graphForce(x_cluster, y_cluster, t_cluster)
% Look at speeding force from 2 fish interactions
% Based on "Inferring the structure and dynamics of interactions in
% schooling fish" by Y. Katz
ns = size(x_cluster,2);
ts_total = size(x_cluster,1);
ts = 1/30;

% Make Grid
max_dist = 1;
increment = 0.1;
edges = [-max_dist:increment:max_dist] ;
N_xbins = length(edges);
N_ybins = length(edges);
N_bins = N_xbins^2;
speed_force = cell(N_xbins,N_ybins); % Initialize 

for fish = 1:ns % Loop through different fish as focal
    x_focal = x_cluster(:,fish); % Focal Fish Orig x,y
    y_focal = y_cluster(:,fish);
    t_focal = t_cluster(:,fish);

    % Calculate neighboring fish state if focal is at center
    x_nb = x_cluster(:,[1:fish-1, fish+1:end]) - x_focal;
    y_nb = y_cluster(:,[1:fish-1, fish+1:end]) - y_focal;
    t_nb = t_cluster(:,[1:fish-1, fish+1:end]) - t_focal;
    t_nb = arrayfun(@angleDiff,t_nb); 

    % Velocity and Acceleration of focal fish
    disp_x = diff(x_focal);
    disp_y = diff(y_focal);
    v = sqrt(disp_x.^2 + disp_y.^2)/ts;
    a = diff(v)/ts;
    
    % Turning force
    w = diff(t_focal)/ts;
    tf = diff(w)/ts;

    x_nodes = discretize(x_nb,edges);
    y_nodes = N_ybins - discretize(y_nb,edges);

    for i = 1:ts_total-2 % Append acceleration to corresponding node
        xnode_i = x_nodes(i+2);
        ynode_i = y_nodes(i+2);
%         speed_force{ynode_i, xnode_i} = [speed_force{ynode_i, xnode_i} , a(i)]; % Speed Force
        speed_force{ynode_i, xnode_i} = [speed_force{ynode_i, xnode_i} , tf(i)]; % Turning Force
    end
%     for i = 1:ts_total % Fish Density
%         xnode_i = x_nodes(i);
%         ynode_i = y_nodes(i);
%         speed_force{ynode_i, xnode_i} = [speed_force{ynode_i, xnode_i} , 1];
%     end

end

plot(x_nb,y_nb,'.')

av_speedF = cellfun(@sum, speed_force);
imagesc(edges, edges, av_speedF)
title('Speed Force')
xlabel('x Distance from focal fish (m)')
ylabel('y Distance from focal fish (m)')
colorbar
end


