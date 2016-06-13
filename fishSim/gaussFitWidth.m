muhat_list = zeros(20,1);
sigmahat_list = zeros(20,1);
N_trial = 5;
clf

for i = 1:size(muhat_list,1)
    N_fish = i*10;
    area = [];
    
    for j = 1:N_trial
        [x,y] = fishSim_7(N_fish);
        area_trial = getBandwidth(x,y);
        area = [area; area_trial];      
        disp(j)
    end
    
    
    hist(area);
    [muhat, sigmahat] = normfit(area);
    muhat_list(i) = muhat;
    sigmahat_list(i)= sigmahat;
    
    disp(i)
end

num_sharks = linspace(10,200,20);
subplot(2,1,1)
plot(num_sharks, muhat_list, 'x');
title('Gaussian fit of School Area') 
ylabel('Mean from Gaussian Fit')
subplot(2,1,2)
plot(num_sharks, sigmahat_list, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')