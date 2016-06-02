

threshold = 0.5;
N_trial = 5;
settling_time = zeros(N_trial, 10);

for i_fish = 1:10
    for trial = 1:N_trial
        N_fish = i_fish * 10;
        run fishSim_7.m
        load fishSimData.mat
        run att_pf.m
        
        time = find(error < threshold, 1);
        if isempty(time)
            time = 1000;
        end
        
        settling_time(trial, i_fish) = time;

    end
    disp(i_fish)
end