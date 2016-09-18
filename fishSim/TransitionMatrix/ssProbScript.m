error_list = [];
nTrial = 5;

for i = 1:nTrial
    nTag_list = [1:10]*5;
    [xsim,ysim,tsim]=fishSim_7(50,25, 1e3, 1e6, 1e9);
    
    [time, error] = ssProbOverTime(xsim,ysim, nTag_list);
    error_list_50sharks_25m = cat(3, error_list, error)
end

for i = 1:nTrial
    nTag_list = [1:10]*10;
    [xsim,ysim,tsim]=fishSim_7(100,50, 1e3, 1e6, 1e9);
    
    [time, error] = ssProbOverTime(xsim,ysim, nTag_list);
    error_list_100sharks_50m = cat(3, error_list, error)
end

save('error2.mat','error_list_50sharks_25m','error_list_100sharks_50m','nTag_list','time')