clf 
muhat_list = zeros(10,1)
sigmahat_list = zeros(10,1)

for i = 1
    string = strcat(num2str(i*10), 'SharksDistFromLine.txt');
    M = csvread(string, 2, 0);
    sum_dist = sum(M,2);
    B = reshape(sum_dist, 1, []);
    % Replicate to negative distances
%     B = [-B, B];
    h = histogram(B);
    [muhat, sigmahat] = normfit(B);
    muhat_list(i) = muhat;
    sigmahat_list(i)= sigmahat;
end

num_sharks = linspace(10,150,15)';


plot(num_sharks, sigmahat_list, 'x')

xlabel('Number of Sharks')
ylabel('Sigma from Gaussian Fit')

% num_sharks = linspace(10,150,15);
% plot(num_sharks, sigmahat_list, 'x')
% xlabel('Number of Sharks')
% ylabel('Sigma from Gaussian Fit')
