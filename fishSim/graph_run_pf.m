% Plot Performance of attraction line PF
clf
load d90x90fit.mat

subplot(3,2,1)
plot(error_list, '.')
title('Performance Error (\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2)/numshark)')
xlabel('Number of Steps')
ylabel('Error (m/shark)')
legendCell = [cellstr(num2str(tag_list', 'm=%-d'))]
ylim([0 1])
legend(legendCell)

subplot(3,2,2)
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
% subplot(3,2,3)
% hold on
% plot([0 ts_pf], [seg_length, seg_length]);
% plot(seglen_list, '.');
% % ylim([0 200]);
% legendCell = ['Actual'; cellstr(num2str(tag_list', 'm=%-d'))]
% legend(legendCell)
% title('Comparison of Actual and Estimated Attraction Line Length')
% ylabel('Attraction Line Length (m)')
% xlabel('Number of Steps')
% hold off

subplot(3,2,3)
hold on
plot([0 ts_pf], [seg_length, seg_length]);
plot(seglen_list, '.');
% ylim([0 200]);
legendCell = ['Actual'; cellstr(num2str(tag_list', 'm=%-d'))]
legend(legendCell)
title('Comparison of Actual and Estimated Attraction Line Length')
ylabel('Attraction Line Length, estimated from furthest point (m)')
xlabel('Number of Steps')
hold off

subplot(3,2,4)
x90_model = d90_fit(N_fish, seg_length);
hold on
plot([0 ts_pf], [x90_model, x90_model]);
plot(d90_list_act, '.');
legendCell = ['Model '; cellstr(num2str(tag_list', '%-d (Actual Line)'));]
legend(legendCell)
title('Estimated d90 \rho_{90}')'
ylabel('\rho_{90} (m)')
xlabel('Number of Steps')
hold off

subplot(3,2,5)
x90_model = x90_fit(N_fish, seg_length);
hold on
plot([0 ts_pf], [x90_model, x90_model]);
plot(x90_list_act, '.');
legendCell = ['Model '; cellstr(num2str(tag_list', '%-d (Actual Line)'));]
legend(legendCell)
title('Estimated \phi_{90}')'
ylabel('\phi_{90} (m)')
xlabel('Number of Steps')
hold off
