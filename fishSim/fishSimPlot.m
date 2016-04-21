x_mean = mean(x,2);
y_mean = mean(y,2);

subplot(2,1,1)
plot(x_mean);
subplot(2,1,2)
plot(y_mean);

x_av = mean(x_mean)
y_av = mean(y_mean)