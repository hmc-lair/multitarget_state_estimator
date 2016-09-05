% Plot Performance of attraction line PF
% subplot(2,2,1)
% hold on
% plot(act_error_list(:,1), '.')
% plot(est_error_list, '.')
% legend('Actual Line', '40', '70', '100')
% title(sprintf('Comparison of Sum of Distance to Act and Est Line for %d Sharks with sigma=1 and uni(0,5)', N_fish));
% hold off

clf
load d90_fit.mat

subplot(2,2,1)
plot(error_list, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2)/numshark)')
xlabel('Number of Steps')
ylabel('Error (m/shark)')
legend('Actual Line', '80 Tagged', '100')

subplot(2,2,2)
hold on
plot([0 ts_pf], [N_fish N_fish]);
plot(numshark_est_list, '.');
% ylim([0 200]);
legend('Actual Line', '80 Tagged', '100')
title('Comparison of Actual and Estimated Number of Sharks')
ylabel('Number of Sharks')
xlabel('Number of Steps')
hold off

% 
% subplot(2,2,3)
% hold on
% plot([0 ts_pf], [seg_length, seg_length]);
% plot(seglen_list, '.');
% % ylim([0 200]);
% legend('Actual Line', '80 Tagged', '100')
% title('Comparison of Actual and Estimated Attraction Line Length')
% ylabel('Attraction Line Length (m)')
% xlabel('Number of Steps')
% hold off
% 
% subplot(2,2,4)
% d90_model = d90_fit(N_fish, seg_length);
% hold on
% plot([0 ts_pf], [d90_model, d90_model]);
% plot(d90_est_tag, '.');
% plot(d90_act_tag, '-');
% % ylim([0 200]);
% 
% legend('Model', '80 Tagged', '100')
% title('Estimated d90')'
% ylabel('90th Percentile Distance from Estimated Line (m)')
% xlabel('Number of Steps')
% hold off