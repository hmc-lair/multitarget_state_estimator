% Plot Performance of attraction line PF
clf
load d90x90fit.mat

false_knownline_filename = 'pf_line_n100_L40_tagged1.mat'
load(false_knownline_filename)

false_str =  'm=%-d';
fig_row = 3;
fig_col = 1;
ts = 0:1/30:ts_pf/30-1/30;
subplot(fig_row,fig_col,1)
hold on
plot(error_list, '.');
plot([0 ts_pf], [0.1 0.1]);
title({'Performance Error', '(\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2)/numshark)'});
xlabel('Number of Timesteps');
ylabel('Error (m/shark)');
legendCell = [cellstr(num2str(tag_list', false_str))];
ylim([0 0.5]);
legend(legendCell);


subplot(fig_row,fig_col,2)
hold on
% plot([0 ts_pf], [N_fish N_fish]);
load(false_knownline_filename);
plot(numshark_est_list - N_fish, '.');
plot([0 ts_pf], [0 0]);
ylim([-50 50])
legendCell = [cellstr(num2str(tag_list', false_str))];
legend(legendCell);
title({'Number of Sharks Error'});
ylabel('Number of Sharks');
xlabel('Number of Timesteps');
hold off


subplot(fig_row,fig_col,3)
hold on
load(false_knownline_filename);
plot(seglen_list - seg_length, '.');
plot([0 ts_pf], [0 0]);
legendCell = [cellstr(num2str(tag_list', false_str))];
legend(legendCell);
title({'Attraction Line Length Error'});
ylabel('Attraction Line Length (m)');
xlabel('Number of Timesteps');
ylim([-10 10])
hold off
