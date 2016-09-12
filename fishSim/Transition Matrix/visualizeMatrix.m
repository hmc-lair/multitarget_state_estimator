imagesc(T);            %# Create a colored plot of the matrix values
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

textStrings = num2str(T(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding

for i = 1:N^2
    if strcmp(textStrings(i), '0.00')
        textStrings(i) = [];
    end
end
[x,y] = meshgrid(1:N);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(T(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:5,...                         %# Change the axes tick marks
        'XTickLabel',{'A','B','C','D','E'},...  %#   and tick labels
        'YTick',1:5,...
        'YTickLabel',{'A','B','C','D','E'},...
        'TickLength',[0 0]);