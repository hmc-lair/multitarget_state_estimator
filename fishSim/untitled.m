weird_num = zeros(900,1);
for i = 1:900
    weird_num(i) = length(find(yRot(i,:)>5.6306));
end

