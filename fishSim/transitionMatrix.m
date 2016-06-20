% Generate Transition Matrix Based on Simulation Data
% Structure based on Kevin Smith's code


% Constants
N = 10; % Number of nodes

% load fit_max_area.mat
% 90_area = fit_90_area(seg_len, ns);

% Discretize location to node number
ts_len = length(x); % Number of ts
max_dist = max(abs(y(:)));
edges = linspace(-max_dist, max_dist, N); % Create hist bin edges
Y_node = discretize(y(:,1),edges); % Location to discretized index

% Compute transition matrix (only for one shark)
T = zeros(N, N);

for ts = 1 : ts_len - 1
    old_node = Y_node(ts);
    new_node = Y_node(ts+1);
    T(new_node, old_node) = T(new_node, old_node) + 1;
end

% Normalize transition matrix

for from = 1:N
    T(:,from) = T(:,from)/sum(T(:,from));
end


