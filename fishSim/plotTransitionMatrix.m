clf
state = [-7:1:7];
% Plot Grid with Simulated Shark Tracks
subplot(2,2,1)
hold on
h1 = plot(x,y,'.')
h2 = plot([-12.5 12.5], [0 0], 'LineWidth', 2, 'Color','Black')
grid on
set(gca,'ytick',state)
ax = gca;
ax.XGrid ='off'
title('Simulated Shark Trajectory: 112 Sharks, 25m Attraction Line')
xlabel('x (m)')
ylabel('y (m)')
hold off

% Plot Grid with Actual Shark Tracks
subplot(2,2,2)
% Attraction Line: y = -0.2168x + 0.113
hold on
a1 = plot(xRot, yRot,'.')
a2 = plot([-12.5 12.5], [0 0], 'LineWidth', 2, 'Color','Black')
grid on
set(gca,'ytick',state)
ax = gca;
ax.XGrid ='off'
xlabel('x (m)')
ylabel('y (m)')

title('Actual Shark Trajectory')
hold off

% Plot Stochastic Matrix
subplot(2,2,[3,4])
comp = T_sim - T_act;
% [X,Y] = meshgrid(1:71,1:71);
surfc(comp)
xlabel('To Node')
ylabel('From Node')
zlabel('Diff in Probability')
title({'Difference between simulated and actual transition matrix',...
    'Vertical Gap Between States: 0.25m'})
