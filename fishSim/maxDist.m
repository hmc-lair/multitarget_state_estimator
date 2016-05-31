% N_fish = 10;
N_trials = 5;

muhat_list = zeros(3,1);
sigmahat_list = zeros(3,1);

for i = 1:15;
    N_fish = i*10;
    max_dist = zeros(TS, N_trials);
    for j=1:N_trials
        run fishSim_7.m
        load fishSimData.mat
        x_sharks = x(1001:5000,:);
        y_sharks = y(1001:5000,:);
        TS = size(x_sharks,1);


        for ts=1:TS

            dist_list = zeros(N_fish, 1);
            for f=1:N_fish
                x_shark = x_sharks(ts,f);
                y_shark = y_sharks(ts,f);

                dist_list(f) = abs(point_to_line( x_shark, y_shark, LINE_START, LINE_END));

            end

            max_dist(ts,j) = max(dist_list);

        end

    end

    max_dist = reshape(max_dist, [TS*N_trials, 1]);

    [muhat, sigmahat] = normfit(max_dist);
    muhat_list(i) = muhat;
    sigmahat_list(i)= sigmahat;
    
end
