function [index_range, x_range, y_range] = getNearbyTags(robots, range, x_tagged, y_tagged)
% Get index and distance of tagged sharks of robots that are within "range"

N_tag = size(x_tagged, 2);
N_robots = size(robots,1);

index_range = [];
x_range = [];
y_range = [];

x_robots = robots(:,1);
y_robots = robots(:,2);


for i = 1:N_tag
    for j = 1:N_robots 
       distance = dist(x_robots(j), y_robots(j), x_tagged(i), y_tagged(i));

       if distance < range % within range
           index_range = [index_range, i];
           x_range = [x_range, x_tagged(i)];
           y_range = [y_range, y_tagged(i)];
       end
    end
end

% Remove repeating index
[index_range, ia, ic] = unique(index_range);

x_range = x_range(ia);
y_range = y_range(ia);
   
