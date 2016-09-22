% Plot Performance of attraction line PF
clf
load d90x90fit.mat

true_knownline_filename = '9-18/accumXandY/pf_line_false_pf200.mat'
false_knownline_filename = '9-18/accumXandY/pf_line_falseknownline_n100_n40.mat'

true_knownline_filename = 'pf_line.mat'
% false_knownline_filename = 'pf_line.mat'
load(false_knownline_filename)

subplot(3,2,1)
hold on
plot([0 ts_pf], [0.1 0.1])
load(false_knownline_filename)
plot(error_list, '.')
load(true_knownline_filename)
plot(error_list, '.')
title({'Performance Error', '(\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2)/numshark)'})
xlabel('Number of Steps')
ylabel('Error (m/shark)')
legendCell = ['Benchmark'; cellstr(num2str(tag_list', 'm=%-d (Unknown Line)')); cellstr(num2str(tag_list', 'm=%-d (Known Line)'))]
ylim([0 0.5])
legend(legendCell)


subplot(3,2,2)
hold on
plot([0 ts_pf], [N_fish N_fish]);
load(false_knownline_filename)
plot(numshark_est_list, '.');
load(true_knownline_filename)
plot(numshark_est_list, '.');
% ylim([0 200]);
legendCell = ['Actual'; cellstr(num2str(tag_list', 'm=%-d (Unknown Line)')); cellstr(num2str(tag_list', 'm=%-d (Known Line)'))]
legend(legendCell)
title({'Comparison of Actual and', 'Estimated Number of Sharks'})
ylabel('Number of Sharks')
xlabel('Number of Steps')
hold off


subplot(3,2,3)
hold on
plot([0 ts_pf], [seg_length, seg_length]);
load(false_knownline_filename)
plot(seglen_list, '.');
load(true_knownline_filename)
plot(seglen_list, '.');
% ylim([0 200]);
legendCell = ['Actual'; cellstr(num2str(tag_list', 'm=%-d (Unknown Line)')); cellstr(num2str(tag_list', 'm=%-d (Known Line)'))]
legend(legendCell)
title({'Comparison of Actual and', 'Estimated Attraction Line Length'})
ylabel('Attraction Line Length (m)')
xlabel('Number of Steps')
hold off

subplot(3,2,4)
x90_model = d90_fit(N_fish, seg_length);
hold on
plot([0 ts_pf], [x90_model, x90_model]);
load(false_knownline_filename)
plot(d90_list_act, '.');
load(true_knownline_filename)
plot(d90_list_act, '.');
legendCell = ['Model '; cellstr(num2str(tag_list', 'm=%-d (Unknown Line)')); cellstr(num2str(tag_list', 'm=%-d (Known Line)'))]
legend(legendCell)
ylim([x90_model-1 x90_model+1])
title('Estimated d90 \rho_{90}')'
ylabel('\rho_{90} (m)')
xlabel('Number of Steps')
hold off

subplot(3,2,5)
x90_model = x90_fit(N_fish, seg_length);
hold on
plot([0 ts_pf], [x90_model, x90_model]);
load(false_knownline_filename)
plot(x90_list_act, '.');
load(true_knownline_filename)
plot(x90_list_act, '.');
legendCell = ['Model '; cellstr(num2str(tag_list', 'm=%-d (Unknown Line)')); cellstr(num2str(tag_list', 'm=%-d (Known Line)'))]
legend(legendCell)
title('Estimated \phi_{90}')'
ylabel('\phi_{90} (m)')
xlabel('Number of Steps')
hold off
