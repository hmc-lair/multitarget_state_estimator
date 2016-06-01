function resampled = resample(p, w)
% Resample particles based on weight based on low variance sampler
% 
%     N_part = size(p, 1);
%     r = rand()* inv(N_part);
%     c = w(1);
%     i = 1;
%     resampled = zeros(size(p));
% 
%     for m = 1:N_part
%         U = r + (m-1) * inv(N_part);
% 
%         while U > c
%             i = i+1;
%             c = c + w(i)
%         end
% 
%         resampled(i,:) = p(m,:);
% 
%     end
%% Try 2
%     N = size(p,1);
%     maxW = max(w);
%     
%     index = randi(N, 1);
%     
%     beta = 0;
%     resampled = zeros(size(p));
%     
%     for i=1:N
%         beta = beta + rand() * 2*maxW; % (gleichverteilt)
%         while beta > w(index)
%             beta = beta - w(index);
%             index = mod(index+1, N)+1;
%         end
%         resampled(i,:) = p(index,:);
%     end

    w_tot = sum(w);
    N = size(p, 1);
    
    for i = 1:N
        r = rand()*w_tot;
        j = 1;
        w_sum = w(1);
        
        while w_sum < r
            j = j+1;
            w_sum = w_sum + w(j);
        end
        
        resampled(i,:) = p(j, :);
    
end
