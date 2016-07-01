% Gets Amount of Tiles Covered over tile

max_vert_dist = 8;
max_hor_dist = 17;
increment = 1;
y_edges = [-max_vert_dist:increment:max_vert_dist] ; 
x_edges = [-max_hor_dist:increment:max_hor_dist] ;
N_ybins = length(y_edges)-1;
N_xbins = length(x_edges)-1;
N_bins = N_ybins * N_xbins;

N_ts = size(xsim,1);
N_fish = size(xsim,2);

coverage = zeros(N_bins, N_fish);

Y_node = discretize(ysim,y_edges); % Y Location to discretized index
X_node = discretize(xsim,x_edges); % X Location to discretized index

node = (Y_node - 1) * N_xbins + (X_node - 1);

tagged_fish = 11:25:112;
tagged_len = length(tagged_fish);
covered_tag = zeros(N_ts, tagged_len);

for ts = 1:N_ts
    for s = 1:N_fish
        coverage(node(ts,s),s) = 1;
    end
    for j = 1:tagged_len
        s_cov = tagged_fish(j);
        covered_tag(ts,j) = sum(any(coverage(:,1:s_cov),2));
    end
end
