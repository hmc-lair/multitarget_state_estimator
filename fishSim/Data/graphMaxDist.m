 set(0,'DefaultAxesFontSize',10)
 set(0,'DefaultLineMarkerSize',12)
%  
subplot(2,1,1)
num_sharks = linspace(10, 150, 15);
plot(num_sharks, muhat_list,'x')
xlabel('Number of Sharks')
ylabel('Mean from Gaussian Fit')
title('Gaussian Fit of Max Distance: Mu and Sigma for varying num_sharks')

subplot(2,1,2)
num_sharks = linspace(10, 150, 15);
plot(num_sharks, sigmahat_list,'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')