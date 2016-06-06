% Run att_pf and graph performance

%Variables
TS_PF = 200;
N_tag = 30;
[act_error, est_error, error, numshark_est] = att_pf(x, y, t, N_tag, LINE_START, LINE_END, TS_PF);
% Plot Performance of attraction line PF
subplot(3,1,1)
hold on
plot(act_error, '.')
plot(est_error, '.')
legend('Actual Line', 'Estimated Line')
title(sprintf('Comparison of Sum of Distance to Act and Est Line for %d Sharks with sigma=1 and randi=10', N_fish));
hold off

subplot(3,1,2)
plot(error, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))')

subplot(3,1,3)
hold on
plot([0 TS_PF], [N_fish N_fish]);
plot(numshark_est, '.');
ylim([0 200]);
legend('Actual', 'Estimated')
title('Comparison of Actual and Estimated Number of Sharks')
xlabel('Number of Steps')
hold off