%%
close all
clear all
clc
global coupling_vars
%% add subdirectories to search path
currentFolder = pwd;
subdirectory = 'functions';  % Replace with your subdirectory name
subdirectoryPath = fullfile(currentFolder, subdirectory);
addpath(subdirectoryPath);

currentFolder = pwd;
subdirectory = 'utils';  % Replace with your subdirectory name
subdirectoryPath = fullfile(currentFolder, subdirectory);
addpath(subdirectoryPath);

%% Read input file
coupling_vars = read_input();
coupling_vars = evaluate();
