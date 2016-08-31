% Compare histogram with probability from Transition Matrix

clf
max_vert_dist = 10;
increment = 0.5;

% Transition Matrix
T = transitionMatrix(x_sim,y_sim,increment);
% T = transitionMatrix(xRot,yRot,increment);
nBins = length(T);
p_int = 1/nBins * ones(1,nBins);
% p_int(10) = 1;
p_fin = getProbFromTMatrix(T,p_int,100000,increment); % T Mat: ss probabilities

% Plot ss probability
% edges = [-max_vert_dist:increment:-increment, ...
%     increment:increment:max_vert_dist]';
hist_edges = -max_vert_dist:increment:max_vert_dist-increment;

hold on
plot(hist_edges,p_fin,'-o','DisplayName','Probability from T Matrix')
[fhist,xhist] = hist(y_sim(:),hist_edges);

% Plot histogram from actual data

delta_x = xhist(2) - xhist(1);
b2 = plot(xhist, fhist/(sum(fhist)),'-o','DisplayName','Probability from Histogram')


% [fhist,xhist] = hist(distLine(:),edges);
% delta_x = xhist(2) - xhist(1);
% % A=sum(fhist);
% b2 = plot(xhist, fhist/(sum(fhist)),'o', ...
%     'DisplayName','Probability from Actual Data',...
%     'Color', 'Green')

% Graphing
title({'Comparing ss transition and histogram with 112 Sharks', 'Bin Size: 2m'})
hold off
legend('show')
xlabel('Distance From Attraction Line')
ylabel('Probability')

% savefig(sprintf('compHistT_%i',N_fish))