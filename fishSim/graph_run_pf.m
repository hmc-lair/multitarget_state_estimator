% Plot Performance of attraction line PF
clf
load d90x90fit_additional.mat

true_knownline_filename = 'pf_line_n100_L40_nprop_5_round'
false_knownline_filename = 'C:\Users\hocheire\multitarget_state_estimator\fishSim\Data\9-21Decoupled\pf_line_n100_L40_nprop_5_1000ts.mat'
true_str =  'm=%-d (Rounded)';
false_str =  'm=%-d (Floor)';
load(false_knownline_filename)

subplot(3,2,1)
hold on
plot([0 ts_pf], [0.1 0.1])
load(false_knownline_filename)
plot(error_list, 'x')
load(true_knownline_filename)
plot(error_list, '.')
title({'Performance Error', '(\Sigma sqrt((dist\_act\_i - dist\_est\_i)^2)/numshark)'})
xlabel('Number of Steps')
ylabel('Error (m/shark)')
legendCell = ['Benchmark'; cellstr(num2str(tag_list', true_str)); cellstr(num2str(tag_list',false_str))]
ylim([0 0.5])
legend(legendCell)
xlim([0 500])


subplot(3,2,2)
hold on
plot([0 ts_pf], [N_fish N_fish]);
load(false_knownline_filename)
plot(numshark_est_list, 'x');
load(true_knownline_filename)
plot(numshark_est_list, '.');
% ylim([0 200]);
legendCell = ['Benchmark'; cellstr(num2str(tag_list', true_str)); cellstr(num2str(tag_list',false_str))]
legend(legendCell)
title({'Comparison of Actual and', 'Estimated Number of Sharks'})
ylabel('Number of Sharks')
xlabel('Number of Steps')
hold off
xlim([0 500])


subplot(3,2,3)
hold on
plot([0 ts_pf], [seg_length, seg_length]);
load(false_knownline_filename)
plot(seglen_list, 'x');
load(true_knownline_filename)
plot(seglen_list, '.');
% ylim([0 200]);
legendCell = ['Benchmark'; cellstr(num2str(tag_list', true_str)); cellstr(num2str(tag_list',false_str))]
legend(legendCell)
title({'Comparison of Actual and', 'Estimated Attraction Line Length'})
ylabel('Attraction Line Length (m)')
xlabel('Number of Steps')
hold off
xlim([0 500])

subplot(3,2,4)
x90_model = d90_fit(N_fish, seg_length);
hold on
plot([0 ts_pf], [x90_model, x90_model]);
load(false_knownline_filename)
plot(d90_list_act, 'x');
load(true_knownline_filename)
plot(d90_list_act, '.');
legendCell = ['Benchmark'; cellstr(num2str(tag_list', true_str)); cellstr(num2str(tag_list',false_str))]
legend(legendCell)
ylim([x90_model-1 x90_model+1])
title('Estimated d90 \rho_{90}')'
ylabel('\rho_{90} (m)')
xlabel('Number of Steps')
hold off
xlim([0 500])

subplot(3,2,5)
x90_model = x90_fit(N_fish, seg_length);
hold on
plot([0 ts_pf], [x90_model, x90_model]);
load(false_knownline_filename)
plot(x90_list_act, 'x');
load(true_knownline_filename)
plot(x90_list_act, '.');
legendCell = ['Benchmark'; cellstr(num2str(tag_list', true_str)); cellstr(num2str(tag_list',false_str))]
legend(legendCell)
title('Estimated \phi_{90}')'
ylabel('\phi_{90} (m)')
xlabel('Number of Steps')
hold off
xlim([0 500])