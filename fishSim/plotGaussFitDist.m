figure

subplot(2,2,1)
plot(numshark_list, muhat_list_hor_dist, 'x');
title('Gaussian fit of Calculated Segment Length for L = 100') 
ylabel('Segment Length (m)')
xlabel('Number of Sharks')

subplot(2,2,3)
title('\sigma of Calculated Segment Length for L = 100') 
plot(numshark_list, sigmahat_list_hor_dist, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')

subplot(2,2,2)
plot(numshark_list, muhat_list_ver_dist, 'x');
title('Gaussian fit of Band Width for L = 100') 
ylabel('Band Width (m)')
xlabel('Number of Sharks')

subplot(2,2,4)
title('\sigma of Band Width for L = 100') 
plot(numshark_list, sigmahat_list_ver_dist, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')

