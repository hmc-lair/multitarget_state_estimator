K_att = 1e10;
K_temp_att = 1e3;
K_rep = 1e6;
tic
[xsim,ysim, tsim] = fishSim_7(112, 30, K_att, K_temp_att, K_rep);
psi_90 = prctile(xsim(:),95) - mean(xsim(:));
rho_90 = prctile(ysim(:),95) - mean(ysim(:));
disp(['---Psi_90------Rho_90'])
disp([psi_90, rho_90])
plot(xsim,ysim,'.')
title(sprintf('K_{att} %g, K_{hab} %g, K_{rep} %g', K_att, K_temp_att, K_rep))
% Histogram
toc
