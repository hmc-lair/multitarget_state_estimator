% Plot Gaussian Fit
% 
figure
subplot(2,2,1)
plot(numshark_list(1:2:end), muhat_list_d90(:,1:2:end), 'x');
title({'Gaussian fit of 90th Percentile Max Dist', 'from Line (\rho_{90})'}) 
ylabel('\rho_{90} (m)')
xlabel('Number of Sharks')
legend(cellstr(num2str(seg_list(1:2:end)', 'L=%-d')))
subplot(2,2,3)
plot(numshark_list(1:2:end), sigmahat_list_d90(:,1:2:end), 'x')
xlabel('Number of Sharks')
ylabel('\sigma of \rho_{90}')
legend(cellstr(num2str(seg_list(1:2:end)', 'L=%-d')))

subplot(2,2,2)
plot(numshark_list(1:2:end), muhat_list_x90(:,1:2:end), 'x');
title({'Gaussian fit of 90th Percentile Distance','from Center along Line (\phi_{90})'});
ylabel('\phi_{90} (m)')
xlabel('Number of Sharks')
legend(cellstr(num2str(seg_list(1:2:end)', 'L=%-d')))
subplot(2,2,4)
plot(numshark_list(1:2:end), sigmahat_list_x90(:,1:2:end), 'x')
xlabel('Number of Sharks')
ylabel('\sigma of \phi_{90}')
legend(cellstr(num2str(seg_list(1:2:end)', 'L=%-d')))
