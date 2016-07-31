processors=32
clusterHost='gordon.sdsc.edu'
ppn=16
username='hocherie'
account='TG-TRA120022'
queue='normal'
time='00:59:00'
DataLocation='/Users/cherieho/multitarget_state_estimator/fishSim/test_comet'
RemoteDataLocation='/home/hocherie/matlab/data'
keyfile='/Users/cherieho/.ssh/id_rsa'
matlabRoot='/opt/matlab/2016a'
cluster = getCluster(username,account,clusterHost,ppn,queue,time,DataLocation, ...
     RemoteDataLocation,keyfile,matlabRoot);
j = createCommunicatingJob(cluster);
j.AttachedFiles={'testparfor2.m'};
set(j,'NumWorkersRange',[1 processors]);
set(j,'Name','Test');

t = createTask(j,@testparfor2,1,{processors});
submit(j);
wait(j);
pause(30);
o=j.fetchOutputs;
o{:}