N_trial = 5;
tag_list = linspace(10,100,10);
tag_size = size(tag_list, 2);
pf_perflist = zeros(N_trial, tag_size);

% run fishSim_7.m
j1 = 1;
trial = 1;

for j1 = 1:tag_size
    N_tagged = tag_list(j1) 
    for trial = 1:N_trial     
%         run att_pf.m
        error = att_pf(x, y, t, N_tagged);
        pf_perflist(trial, j1) = size(find(error < 0.5),1)
    end
    disp(j1)
end