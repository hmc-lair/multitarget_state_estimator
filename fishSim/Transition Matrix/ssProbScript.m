[xsim,ysim,tsim]=fishSim_7(100,25, 1e3, 1e6, 1e9);
nTag_list = [1:10]*10;
% nTag_list = [10, 100];
error = ssProbOverTime(xsim,ysim, nTag_list);

save('error.mat','error')