% Find width of shark band
function area = getBandwidth(x,y)
N_ts = size(x,1);

left = zeros(N_ts, 1);
right = zeros(N_ts, 1);
top = zeros(N_ts, 1);
bot = zeros(N_ts, 1);

for i = 1:N_ts
    left(i) = min(x(i,:));
    right(i) = max(x(i,:));
    top(i) = max(y(i,:));
    bot(i) = min(y(i,:));
    
end

area = (right - left).*(top - bot);
% area = (top - bot);
% plot(width,'x')

end