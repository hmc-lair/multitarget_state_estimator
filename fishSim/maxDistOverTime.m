%Plot Maximum Distance at Each Timestamp over Time

function [] = maxDistOverTime(x,y, N_tag, LINE_START, LINE_END)

TS = size(x,1);
N_fish = size(x,2);
max_dist = zeros(TS, 1);
random_tagged = randperm(N_fish, N_tag);

for ts=1:TS

    dist_list = zeros(N_tag, 1);
    for f=1:N_tag
        shark = random_tagged(f);
        x_shark = x(ts,shark);
        y_shark = y(ts,shark);

        dist_list(shark) = abs(point_to_line( x_shark, y_shark, LINE_START, LINE_END));

    end

    max_dist(ts) = max(dist_list);

end

hold on
plot(max_dist)

end