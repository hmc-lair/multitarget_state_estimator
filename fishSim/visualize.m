%% Visualize fish trajectories from fishSim_7

function [] = visualize(x, y, t)
clf
% load fishSimData.mat 

maxTime = size(x,1);
N_fish = size(x,2);
<<<<<<< HEAD
for time=1:3:maxTime;
=======
for time=1:30:maxTime;
>>>>>>> master
%     loop over fish to plot
    arrowSize = 1.5;
    fig = figure(1);
%     clf;
    hold on;
<<<<<<< HEAD
    for f=1:N_fish
       plot(x(time,f),y(time,f),'.'); 
%        plot([x(time,f) x(time,f)+cos(t(time,f))*arrowSize],[y(time,f) y(time,f)+sin(t(time,f))*arrowSize]); 
=======
    parfor f=1:N_fish
       plot(x(time,f),y(time,f),'o'); 
       plot([x(time,f) x(time,f)+cos(t(time,f))*arrowSize],[y(time,f) y(time,f)+sin(t(time,f))*arrowSize]); 
>>>>>>> master
    end
    % Plot attraction line
%     plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)])
<<<<<<< HEAD
    width = 15;
=======
    width = 60;

>>>>>>> master
    scale = 0.5;
    axis(scale*[-width width -width width]);


  
    pause(0.0001); 
    disp(time)
end

end