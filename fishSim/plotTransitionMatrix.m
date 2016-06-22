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
a1 = plot(x_sharks, y_sharks,'.')
xLine = linspace(-15, 15, 100);
yLine = -0.2168*xLin+0.113;

actual_start = [-11.67, 2.642];
actual_end = [11.97, -2.482];
a2 = plot([actual_start(1), actual_end(1)],[actual_start(2), actual_end(2)],...
    'LineWidth', 1, 'Color','Black');
% hi = dist(actual_start(1), actual_start(2),actual_end(1), actual_end(2))
for diff = state
    xLine = linspace(-15, 15, 100);
    yLine = -0.2168*xLin+0.113+diff;
    plot(xLine,yLine,'.','Color','Black','MarkerSize',1)
end
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
