% Genetic Algorithm on Histogram Difference

clear
clc
close all

[x,fval] = ga(@findGains,4,[],[],[],[],[0,0,0,0],[]) % variables 2 and 3 are integers
opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});