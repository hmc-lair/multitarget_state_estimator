% Plot Performance of attraction line PF
clf
load d90_fit.mat

subplot(2,2,1)
plot(error_list, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2)/numshark)')
xlabel('Number of Steps')
ylabel('Error (m/shark)')
legendCell = [cellstr(num2str(tag_list', 'm=%-d'))]
legend(legendCell)

subplot(2,2,2)
hold on
plot([0 ts_pf], [N_fish N_fish]);
plot(numshark_est_list, '.');
% ylim([0 200]);
legendCell = ['Actual'; cellstr(num2str(tag_list', 'm=%-d'))]
legend(legendCell)
title('Comparison of Actual and Estimated Number of Sharks')
ylabel('Number of Sharks')
xlabel('Number of Steps')
hold off

% 
subplot(2,2,3)
hold on
plot([0 ts_pf], [seg_length, seg_length]);
plot(seglen_list, '.');
% ylim([0 200]);
legendCell = ['Actual'; cellstr(num2str(tag_list', 'm=%-d'))]
legend(legendCell)
title('Comparison of Actual and Estimated Attraction Line Length')
ylabel('Attraction Line Length (m)')
xlabel('Number of Steps')
hold off

subplot(2,2,4)
d90_model = d90_fit(N_fish, seg_length);
hold on
plot([0 ts_pf], [d90_model, d90_model]);
plot(d90_list_act, '.');
plot(d90_list_est, '-');
legendCell = ['Model '; cellstr(num2str(tag_list', '%-d (Actual Line)'));cellstr(num2str(tag_list', '%-d (Estimated Line)'))]
legend(legendCell)
title('Estimated d90')'
ylabel('90th Percentile Distance from Estimated Line (m)')
xlabel('Number of Steps')
hold off
