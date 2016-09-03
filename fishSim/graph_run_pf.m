% Plot Performance of attraction line PF
% subplot(2,2,1)
% hold on
% plot(act_error_list(:,1), '.')
% plot(est_error_list, '.')
% legend('Actual Line', '40', '70', '100')
% title(sprintf('Comparison of Sum of Distance to Act and Est Line for %d Sharks with sigma=1 and uni(0,5)', N_fish));
% hold off

clf

subplot(2,1,1)
plot(error_list, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2/numshark)))')
legend('Actual Line', '40 Tagged', '70', '100')

subplot(2,1,2)
hold on
plot([0 ts_pf], [N_fish N_fish]);
plot(numshark_est_list, '.');
% ylim([0 200]);
legend('Actual','40 Tagged', '70', '100')
title('Comparison of Actual and Estimated Number of Sharks')
xlabel('Number of Steps')
hold off

% 
% subplot(2,2,3)
% hold on
% plot([0 ts_pf], [N_fish N_fish]);
% plot(seg_len_est, '.');
% % ylim([0 200]);
% legend('Actual','40 Tagged', '70', '100')
% title('Comparison of Actual and Estimated Segment Length')
% xlabel('Number of Steps')
% hold off