muhat_list = zeros(15,1);
sigmahat_list = zeros(15,1);

for i = 1:15
    N_fish = i*10;
    distance = [];
    
    for j = 1:3
        run fishSim_7.m
        load fishSimData.mat

        x_sharks = x(1001:end, :);
        y_sharks = y(1001:end, :);

        for ts = 1:size(x_sharks,1)
            sum_shark_dist = totalSharkDistance(x_sharks(ts,:), y_sharks(ts,:), LINE_START, LINE_END);
            distance = [distance, sum_shark_dist];
        end
    end
    
%     sum_dist = sum(M,2);
%     B = reshape(sum_dist, 1, []);
    % Replicate to negative distances
%     B = [-B, B];
%     h = histogram(distance);
    [muhat, sigmahat] = normfit(distance);
    muhat_list(i) = muhat;
    sigmahat_list(i)= sigmahat;
    
    disp(i)
end
% 
num_sharks = linspace(10,150,15);
plot(num_sharks, sigmahat_list, 'x')
xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')