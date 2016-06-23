% Generate Transition Matrix Based on Simulation Data
% States are distance away from line
% Structure based on Kevin Smith's code


function T = transitionMatrix(x1, y1, increment)

%% For Simulation Data
ts_len = length(x1); % Number of ts
ns = size(x1,2);
vert_dist = y1;
% 
% for i = 1:ts_len
%     for j = 1:ns
% %         is_above = isAbove(x(i,j), y(i,j), [-25 0], [25 0]); 
% %         dist(i,j) = is_above * point_to_line(x(i,j), y(i,j), [-25 0], [25 0]);
%         vert_dist(i,j) = y(i,j);
%     end
% end

%% For Actual Data
% ts_len = length(x_rot); % Number of ts
% ns = size(x_rot,2);
% vert_dist = zeros(ts_len, ns);
% vert_dist = distLine;
% 
max_vert_dist = max(abs(vert_dist(:)))
max_vert_dist = 7;
y_edges = -max_vert_dist:increment:max_vert_dist; % Create hist bin edges
N_y = length(y_edges);
% N_y = 1; % Debug
Y_node = discretize(vert_dist,y_edges); % Location to discretized index


% x_edges = [-20:0.25:20];
% N_x = length(x_edges);
% X_node = discretize(x, x_edges);

node = Y_node;
% node = X_node; % Debug

%% Compute transition matrix (only for one shark)
T = zeros(N_y, N_y);


for ts = 1 : ts_len - 1
    for shark = 1:ns
        old_node = node(ts, shark);
        new_node = node(ts+1, shark);
        T(new_node, old_node) = T(new_node, old_node) + 1;
    end
end

% Normalize transition matrix

for from = 1:N_y
    sum_from = sum(T(:,from));
    T(:,from) = T(:,from)/sum(T(:,from));
    
    if sum_from == 0
        T(:,from) = zeros([1 N_y]);
    end
    
end

end


