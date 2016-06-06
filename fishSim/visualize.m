%% Visualize fish trajectories from fishSim_7
clf
load fishSimData.mat 

for time=1:maxTime;
%     loop over fish to plot
    arrowSize = 1.5;
    fig = figure(1);
    clf;
    hold on;
    for f=1:N_fish
       plot(x(time,f),y(time,f),'o'); 
       plot([x(time,f) x(time,f)+cos(t(time,f))*arrowSize],[y(time,f) y(time,f)+sin(t(time,f))*arrowSize]); 
    end
    

    % Plot attraction line
    plot([LINE_START(1), LINE_END(1)],[LINE_START(2), LINE_END(2)])
    scale = 0.5;
    axis(scale*[-width width -width width]);
  
    pause(0.0001); 
end