%generate a matrix of random numbers of dimension msize x msize
rmatrix=rand(msize);
%create a unique output name based on the node hostname, process id#,
%and msize and write the random matrix to it
[~,hname]=system('hostname');
fname=num2str(msize);
process=num2str(pid);
fname=strcat(hname,'.',process,'.',fname,'.csv');
csvwrite(fname,rmatrix);
quit