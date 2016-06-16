ts_pf = 3000;
N_tagged = 50;
seg_length = 50;
dens = 1;
N_tagged = seg_length * dens;

[act_error, est_error, error, dens_est] = att_pf(x, y, t, N_tagged, seg_length, ts_pf, false)

subplot(2,1,1)
hold on
plot(error,'.')
plot([0 ts_pf], [0.1 0.1])
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))');

subplot(2,1,2)
hold on
plot(dens_est,'x')
plot([0 ts_pf], [dens dens])
hold off