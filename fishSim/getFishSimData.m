% Get multiple fish simulation data in mat file

% Constants
TS_PF = 1000;
N_fish = 100;
N_sim = 20;
seg_length = 50;
x_fish_sim = zeros(TS_PF, N_fish, N_sim);
y_fish_sim = zeros(TS_PF, N_fish, N_sim);

parfor i = 1:N_sim
    [x_fish_sim(:,:,i),y_fish_sim(:,:,i), ~] = ...
        fishSim_7(N_fish,seg_length, 1e3, 1e6, 1e9);
end

save('fishSim.mat','x_fish_sim','y_fish_sim','seg_length','N_fish','N_sim')
    