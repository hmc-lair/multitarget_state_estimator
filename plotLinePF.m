load('line_pf_data.mat')
figure
plot(num_sharks, error_list_vary_sd, 'x', 'MarkerSize', 15)
hold on
plot(num_sharks, error_list_max_sd, '.', 'MarkerSize', 15)
hold off
legend('Varying sd', 'Max sd (from 100 Sharks)')