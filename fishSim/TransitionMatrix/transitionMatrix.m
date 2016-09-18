% Generate Transition Matrix Based on Simulation Data
% States are distance away from line
% Structure based on Kevin Smith's code

function [T_x,T_y] = transitionMatrix(x, y, x_increment, y_increment)
% x: (ts, shark, N_trial)
% y: (ts, shark, N_trial) y location data
% increment: increment between states (distance from line)

%% For Simulation Data
N_trial = size(x,3);

% Set up states
max_vert_dist = 10;
y_edges = [-max_vert_dist:y_increment:max_vert_dist] ;
N_ybins = length(y_edges)-1;
T_y = zeros(N_ybins, N_ybins,N_trial); % Initialize Transition Matrix

max_hor_dist = 35;
x_edges = [-max_hor_dist:x_increment:max_hor_dist];
N_xbins = length(x_edges)-1;
T_x = zeros(N_xbins, N_xbins,N_trial); % Initialize Transition Matrix



for trial = 1:N_trial
    x1 = x(:,:,trial);
    y1 = y(:,:,trial);
    ts_len = size(x1,1); % Number of ts
    ns = size(x1,2);
    vert_dist = y1;
    hor_dist = x1; 
    node_y = discretize(vert_dist,y_edges); % Y Location to discretized index
    node_x = discretize(hor_dist,x_edges); % X Location to discretized index

    %% Compute transition matrix
    for ts = 1 : ts_len - 1
        for shark = 1:ns
            old_node_Y = node_y(ts, shark);
            new_node_y = node_y(ts+1, shark);
            T_y(old_node_Y, new_node_y, trial) = T_y(old_node_Y, new_node_y,trial) + 1;
            
            old_node_x = node_x(ts, shark);
            new_node_x = node_x(ts+1, shark);
            T_x(old_node_x, new_node_x, trial) = T_x(old_node_x, new_node_x,trial) + 1;
        end
    end
end
% clf
% figure
% for i = 0:4
%     figure
%     for j = 1:12
%         subplot(4,3,j)
%         index = i*12 + j;
%         bar(T_x(index,:))
%         title(sprintf('From State: %d', index))
%         xlim([index-2,index+2])
%         set(gca, 'YScale', 'log') % this screws the bar series
%     end
%     saveas(gcf,sprintf('T_mat_%d.png',i))
% end

T_y = sum(T_y,3); % Sum Instances from multiple trials
T_x = sum(T_x,3); % Sum Instances from multiple trials
% Normalize transition matrix

for from_y = 1:N_ybins
    
    sum_from = sum(T_y(from_y,:));
    
    if sum_from ~= 0
        T_y(from_y,:) = T_y(from_y,:)/sum_from;
    end

end

for from_x = 1:N_xbins
    
    sum_from = sum(T_x(from_x,:));
    
    if sum_from ~= 0
        T_x(from_x,:) = T_x(from_x,:)/sum_from;
    end

end
    
end

    
