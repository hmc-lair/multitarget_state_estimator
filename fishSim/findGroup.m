% Find Isolated Fish Groups to find gains?4


%% Using DBSCAN Clustering Algorithm
for i = 1:873
P = [xRot(i,:);yRot(i,:)];
E = 0.25;
minPts = 2;
dbscan(P, E, minPts);
end