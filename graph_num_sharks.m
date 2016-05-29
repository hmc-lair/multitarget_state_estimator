i = 9;
string = strcat('att_numsharks_', num2str(i*10), 'Sharks.txt');
M = csvread(string, 0);

plot(M)
