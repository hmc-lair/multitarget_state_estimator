load actual_tracks.mat ...
    x y t

x = x';
y = y';
t = t';
threshold = 0.1;

% Line endpoints from actual data (from Kim)
LINE_START = [-25 5.533];
LINE_END = [25 -5.3070];
N_tagged = 30;
N_fish = 112;

error = att_pf(x, y, t, N_tagged, LINE_START, LINE_END);

pf_perf = size(find(error < threshold),1)