% Genetic Algorithm on Histogram Difference

clear
clc
close all

opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
[x,fval] = ga(@findGains,2,[],[],[],[],[],[],[],opts); % variables 2 and 3 are integers
