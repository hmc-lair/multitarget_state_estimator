% Gauss Fit MaxDist for attraction line PF
seg_list = [10 20 30 50 70 100 200];
numshark_list = [10 30 50 80 100 200];
TS_PF = 1000;

seg_list_len = size(seg_list,2);
numshark_len = size(numshark_list,2);
muhat_list_hor_dist = zeros(seg_list_len,numshark_len);
sigmahat_list_hor_dist = zeros(seg_list_len,numshark_len);
muhat_list_d90 = zeros(seg_list_len,numshark_len);
sigmahat_list_d90 = zeros(seg_list_len,numshark_len);
N_trial = 3;
clf

tic
parfor i = 1:seg_list_len
    seg_length = seg_list(i);
    LINE_START = [-seg_length/2 0];
    LINE_END = [seg_length/2 0];
    
    
    for j = 1:numshark_len
        N_fish = numshark_list(j)
        
        edge_distance_list = zeros(N_trial, N_fish, TS_PF);
        d90_list = zeros(N_trial, N_fish, TS_PF);
        for k = 1:N_trial
            [x,y,t] = fishSim_7(N_fish,seg_length, 1e3, 1e6, 1e9);
            for ts = 1:TS_PF
                [edge_distance_list(k,:,ts), d90_list(k,:,ts)] = ...
                    measureEdgeDistance(x(i,:), y(i,:), LINE_START, LINE_END);
            end
        end
       
        [muhat_hor_dist, sigmahat_hor_dist] = normfit(edge_distance_list(:));
        muhat_list_hor_dist(i,j) = muhat_hor_dist
        sigmahat_list_hor_dist(i,j)= sigmahat_hor_dist;
        
        [muhat_ver_dist, sigmahat_ver_dist] = normfit(d90_list(:));
        muhat_list_d90(i,j) = muhat_ver_dist
        sigmahat_list_d90(i,j)= sigmahat_ver_dist;
    
    end
    
    disp(i)
end

save('gaussFitHorDist.mat','numshark_list', 'seg_list','muhat_list_hor_dist',...
    'sigmahat_list_hor_dist', 'muhat_list_d90','sigmahat_list_d90')
toc
% % 
% figure
% subplot(2,2,1)
% plot(numshark_list, muhat_list_hor_dist, 'x');
% title('Gaussian fit of Horizontal Distance for L = 100') 
% ylabel('Mean from Gaussian Fit (m)')
% xlabel('Number of Sharks')
% legend(cellstr(num2str(numshark_list', 'N = %-d')))
% subplot(2,2,3)
% title('\sigma of Horizontal Distance for L = 100') 
% plot(numshark_list, sigmahat_list_hor_dist, 'x')
% xlabel('Number of Sharks')
% ylabel('Sigma from Gaussian Fit')
% subplot(2,2,2)
% plot(numshark_list, muhat_list_ver_dist, 'x');
% title('Gaussian fit of Vertical Distance for L = 100') 
% ylabel('Mean from Gaussian Fit (m)')
% xlabel('Number of Sharks')
% legend(cellstr(num2str(numshark_list', 'N = %-d')))
% subplot(2,2,4)
% title('\sigma of Vertical Distance for L = 100') 
% plot(numshark_list, sigmahat_list_ver_dist, 'x')
% xlabel('Number of Sharks')
% ylabel('Sigma from Gaussian Fit')
% 
