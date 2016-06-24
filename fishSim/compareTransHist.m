% Compare histogram with probability from Transition Matrix

% T = transitionMatrix(x,y,0.05)
% p = zeros(401,1);
% p(199:203) = 0.2;
% p_fin = getProbFromTMatrix(T,p,100000);
clf
max_vert_dist = 10;
increment = 0.05;
edges = -max_vert_dist:increment:max_vert_dist;
hold on
plot(edges,p_fin,'.','DisplayName','Probability from T Matrix')
y_sim_1 = y_sim(:,:,1);
[fhist,xhist] = hist(y_sim_1(:),edges);
delta_x = xhist(2) - xhist(1);
% A=sum(fhist);
b2 = plot(xhist, fhist/(sum(fhist)),'DisplayName','Probability from Histogram')


% [fhist,xhist] = hist(distLine(:),edges);
% delta_x = xhist(2) - xhist(1);
% % A=sum(fhist);
% b2 = plot(xhist, fhist/(sum(fhist)),'-.-', ...
%     'DisplayName','Probability from Actual Data',...
%     'Color','Black')

title('Comparing Transition Matrix probability and From Histogram')
hold off
legend('show')
xlabel('Distance From Attraction Line')
ylabel('Probability')