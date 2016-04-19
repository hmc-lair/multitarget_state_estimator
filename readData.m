% M = csvread('testError.txt');
% 
% x = M(1:2:end,:);  % odd matrix
% y = M(2:2:end,:);  % odd matrix

M = csvread('50Tracked.txt');
L = csvread('10Tracked.txt');
t = linspace(1,1000,1000);
Fs = 1;
N = 1000;
% Frequency increment (in hertz per sample):
dF = Fs/N;

% Frequency domain:
f = -Fs/2:dF:Fs/2-dF; % in hertz

shark1_x_50 = M(:,1) - 8;
shark1_x_10 = L(:,1) - 8;
shark2_x = M(:,3) -8;
mean_x_50 = M(:,5)-8;
mean_x_10 = L(:,5)-8;

shark1_y = M(:,2)-8;
shark2_y = M(:,4)-8;
mean_y_50 = M(:,6)-8;
mean_x_10 = L(:,6)-8;

% % plot(t, shark1_x_50);
% % hold on
% % plot(t, shark1_x_10);
% % legend('50', '10');
% 
out = fft(shark1_x_50);
plot(f, abs(out)/N)
subplot(3,1,1)
plot(t, shark1_x);
hold on
plot(t, shark2_x);
plot(t, mean_x);
legend('shark1_x', 'shark2_x', 'mean_x');
xlabel('Time (s)')
ylabel('x Position (m)')
hold off

subplot(3,1,2)
plot(t, shark1_y);
hold on
plot(t, shark2_y);
plot(t, mean_y);
legend('shark1_y', 'shark2_y', 'mean_y');
hold off

subplot(3,1,3)
out = fft(shark1_x);
stem(abs(out)/N);