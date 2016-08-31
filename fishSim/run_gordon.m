processors=32
clusterHost='gordon.sdsc.edu'
ppn=16
username='hocherie'
account='TG-TRA120022'
queue='normal'
time='00:59:00'
DataLocation='/Users/cherieho/Desktop/test_comet'
RemoteDataLocation='/home/hocherie/matlab/data'
keyfile='/Users/cherieho/.ssh/id_rsa'
matlabRoot='/home/jpg/opt/matlab/2016a'
cluster = getCluster(username,account,clusterHost,ppn,queue,time,DataLocation, ...
     RemoteDataLocation,keyfile,matlabRoot);
j = createCommunicatingJob(cluster);
set(j,'NumWorkersRange',[1 processors]);
set(j,'Name','Test');

t = createTask(j,@ssProbScript,1,{});
submit(j);
wait(j);
pause(30);
o=j.fetchOutputs;
o{:}