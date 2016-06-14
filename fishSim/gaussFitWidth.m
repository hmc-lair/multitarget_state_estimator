muhat_list = zeros(6,1);
sigmahat_list = zeros(6,1);
N_trial = 5;
fish_num_list = linspace(25,200,6);
clf

for i = 1:size(muhat_list,1)
    N_fish = fish_num_list(i);
    length = [];
    
    for j = 1:N_trial
        [x,y] = fishSim_7(N_fish);
        length_trial = getBandwidth(x,y);
        length = [length; length_trial];      
        disp(j)
    end
    
    
    hist(length);
    [muhat, sigmahat] = normfit(length);
    muhat_list(i) = muhat;
    sigmahat_list(i)= sigmahat;
    
    disp(i)
end

num_sharks = fish_num_list;
subplot(2,1,1)
plot(num_sharks, muhat_list, 'x');
title('Gaussian fit of School Length') 
ylabel('Mean from Gaussian Fit')
subplot(2,1,2)
plot(num_sharks, sigmahat_list, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')