% Gauss Fit MaxDist for attraction line PF
seg_list = 100;
numshark_list = [10, 30, 50, 70, 100, 150, 200];
% numshark_list = [5, 10];
TS_PF = 1000;

seg_list_len = size(seg_list,2);
numshark_len = size(numshark_list,2);
muhat_list_hor_dist = zeros(seg_list_len,numshark_len);
sigmahat_list_hor_dist = zeros(seg_list_len,numshark_len);
N_trial = 10;
clf

tic
for i = 1:seg_list_len
    seg_length = seg_list(i);
    LINE_START = [-seg_length/2 0];
    LINE_END = [seg_length/2 0];
    
    
    for j = 1:numshark_len
        N_fish = numshark_list(j)
        
        edge_distance_list = zeros(N_trial, N_fish, TS_PF);
        parfor k = 1:N_trial
            [x,y,t] = fishSim_7(N_fish,seg_length, 1e3, 1e6, 1e9);
            for ts = 1:TS_PF
                edge_distance_list(k,:,ts) = ...
                    measureEdgeDistance(x(i,:), y(i,:), LINE_START, LINE_END);
            end
        end
       
        [muhat_hor_dist, sigmahat_hor_dist] = normfit(edge_distance_list(:));
        muhat_list_hor_dist(i,j) = muhat_hor_dist
        sigmahat_list_hor_dist(i,j)= sigmahat_hor_dist;
    
    end
    
    disp(i)
end

save('gaussFitHorDist.mat','numshark_list', 'seg_list','muhat_list_hor_dist',...
    'sigmahat_list_hor_dist')
toc

% figure
% subplot(2,1,1)
% plot(numshark_list, muhat_list_hor_dist, 'x');
% title('Gaussian fit of Horizontal Distance') 
% ylabel('Mean from Gaussian Fit')
% legend(cellstr(num2str([10 20 30 50 70 100 200]')))
% subplot(2,1,2)
% plot(numshark_list, sigmahat_list_hor_dist, 'x')
% xlabel('Number of Sharks')
% ylabel('Sigma from Gaussian Fit')
% legend(cellstr(num2str([10 20 30 50 70 100 200]')))
