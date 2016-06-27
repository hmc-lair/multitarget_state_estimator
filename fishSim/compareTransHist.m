% Compare histogram with probability from Transition Matrix

% T = transitionMatrix(x,y,0.05)
% p = zeros(401,1);
% p(199:203) = 0.2;
% p_fin = getProbFromTMatrix(T,p,100000);
clf
max_vert_dist = 10;
increment = 0.01;
edges = [-max_vert_dist:increment:-increment, ...
    increment:increment:max_vert_dist]';
hist_edges = -max_vert_dist:increment:max_vert_dist;
hold on
plot(edges,p_fin,'.','DisplayName','Probability from T Matrix')
% y_sim_1 = y_sim(:,:,1);
[fhist,xhist] = hist(ysim(:),hist_edges);
delta_x = xhist(2) - xhist(1);
% A=sum(fhist);
b2 = plot(xhist, fhist/(sum(fhist)),'.','DisplayName','Probability from Histogram')


% [fhist,xhist] = hist(distLine(:),edges);
% delta_x = xhist(2) - xhist(1);
% % A=sum(fhist);
% b2 = plot(xhist, fhist/(sum(fhist)),'o', ...
%     'DisplayName','Probability from Actual Data',...
%     'Color', 'Green')

title(sprintf('Comparing Transition Matrix probability and From Histogram with %i Sharks', N_fish))
hold off
legend('show')
xlabel('Distance From Attraction Line')
ylabel('Probability')


savefig(sprintf('compHistT_%i',N_fish))