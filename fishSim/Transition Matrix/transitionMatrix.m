% Generate Transition Matrix Based on Simulation Data
% States are distance away from line
% Structure based on Kevin Smith's code


function T = transitionMatrix(x, y, increment)
% x: (ts, shark, N_trial)
% y: (ts, shark, N_trial) y location data
% increment: increment between states (distance from line)

%% For Simulation Data
N_trial = size(x,3);

% Set up states
max_vert_dist = 10;
y_edges = [-max_vert_dist:increment:max_vert_dist] ;
N_ybins = length(y_edges)-1;
T = zeros(N_ybins, N_ybins,N_trial); % Initialize Transition Matrix

for trial = 1:N_trial
    x1 = x(:,:,trial);
    y1 = y(:,:,trial);
    ts_len = size(x1,1); % Number of ts
    ns = size(x1,2);
    vert_dist = y1;

    Y_node = discretize(vert_dist,y_edges); % Y Location to discretized index

    node = Y_node;

    %% Compute transition matrix
    for ts = 1 : ts_len - 1
        for shark = 1:ns
            old_node = node(ts, shark);
            new_node = node(ts+1, shark);
            T(old_node, new_node, trial) = T(old_node, new_node,trial) + 1;
        end
    end
end

T = sum(T,3); % Sum Instances from multiple trials

% Normalize transition matrix

for from = 1:N_ybins
    
    sum_from = sum(T(from,:));
    
    if sum_from ~= 0
        T(from,:) = T(from,:)/sum_from;
    end

end
    
end

    


