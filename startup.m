% Repository Matlab_Murray_UtilitiesGeneral includes this startup.m file
% that needs to be copied to the home directory for Matlab at
% ~/Documents/MATLAB/
% At startup, MATLAB runs the startup.m script.

addpath(genpath('~/Desktop/gitRepsLocal/Matlab_Murray_ThermoUtils/'))
addpath(genpath('~/Desktop/gitRepsLocal/Matlab_Murray_UtilitiesGeneral/'))

[~,name] = system('hostname');

if ( contains(name,'nmMacBookProM5') )
    cd /Volumes/Caleb/
end