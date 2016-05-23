NUM_TRIALS = 5;

x_mean_accum = zeros(5000,1);

y_mean_accum = zeros(5000,1);
x_av = zeros(5000,1);
y_av = zeros(5000,1);


for num_tags = linspace(10,50,3)
    x_mean_accum = zeros(5000,1);
    y_mean_accum = zeros(5000,1);
    for j=1:NUM_TRIALS
        [x_mean, y_mean] = fishSim_7(num_tags);
        x_mean_accum = x_mean + x_mean_accum;
        y_mean_accum = y_mean + y_mean_accum;
    end
    x_av_tag = x_mean_accum./NUM_TRIALS;
    y_av_tag = y_mean_accum./NUM_TRIALS;
    x_av = [x_av x_av_tag];
    y_av = [y_av y_av_tag];
end


clf
figure
subplot(2,1,1)
plot(x_av(:,2:end));
ylabel('x Distance from Attraction Point (m)')
legend('10','30','50')
title('Mean Position of Tagged sharks Over Time (50 Sharks in Total)')
subplot(2,1,2)
plot(y_av(:,2:end));
xlabel('Time (s)')
ylabel('y Distance from Attraction Point (m)')
legend('10','30','50')

    