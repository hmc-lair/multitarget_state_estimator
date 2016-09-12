a = zeros(4,1);
parfor i = 1:4
    a(i) = i;
end

save('test.mat','a')