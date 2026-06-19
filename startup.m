% Repositories including Matlab_Murray_UtilitiesGeneral are available on
% github at https://github.com/docNathanM
% In order to make these available for use in Matlab, 
%  (1) the repositories need to be cloned to local folders, and 
%  (2) the local folders need to be placed on the Matlab path.
% This script is included in Matlab_Murray_UtilitiesGeneral as an example.
% Copy this file to the home directory for Matlab at
% ~/Documents/MATLAB/
% Then, modify the file as needed based on the location of the local 
% repositories.
% At startup, MATLAB runs the startup.m script automatically.

addpath(genpath('/Volumes/Caleb/32 Methods/32.02 Matlab_Murray_gitRepsLocal/'))

[~,name] = system('hostname');

if ( contains(name,'nmMacBookProM5') )
    cd /Volumes/Caleb/
end