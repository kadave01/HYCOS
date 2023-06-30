close all
clear all
clc
TOP = [1, 2:2:100];
TIT = [1000:5:2000];
global coupling_vars
%% add subdirectories to search path
% Get the current script's file path
currentScript = mfilename('fullpath');
[currentFolder, ~, ~] = fileparts(currentScript);
parentFolder = fileparts(currentFolder);
subdirectory = 'functions';  % Replace with your subdirectory name
subdirectoryPath = fullfile(parentFolder, subdirectory);
addpath(parentFolder);
addpath(subdirectoryPath);

fileID = fopen('utils/output_map.dat', 'w');
    fprintf(fileID, 'TOP\tTIT\tEfficiency\tNet_sp_work\tTOT\n');
    fclose(fileID);

for i = 1:length(TOP)
    for j = 1:length(TIT)
        data = [
                TOP(i);                 % Lowest cycle pressure [bar]
                303.85;                 % Highest cycle pressure [bar]
                TIT(j);                 % Highest cycle temperature [K]
                302.15;                 % Lowest cycle temperature [K]
                10;                     % PPTD [K]
                0.9973;                 % HEX pressure recovery ratio HP side [-]
                0.97;                   % HEX pressure recovery ratio LP side [-]
                0.99;                   % Combustor pressure recovery ratio [-]
                80;                     % Isentropic efficiency of compression process [%]
                83;                     % Isentropic efficiency of expansion process [%]
                99.5;                   % Combustion efficiency [%]
                4;                      % Number of intercooled compression steps [-]
                1073.15;                % Maximum allowable blade metal temperature [K]
                44.00095;               % Molar mass of CO2 [kg/kmol]
                18.0153;                % Molar mass of H2O [kg/kmol]
                2.01588;                % Molar mass of H2 [kg/kmol]
                31.9988;                % Molar mass of O2 [kg/kmol]
                285.8E3;                % Molar HHV of fuel (H2) [MJ/kmole]
                241.826E3;              % Molar LHV of fuel (H2) [MJ/kmole]
                1E-1;                   % Permissible error in PPTD calculation [-]
                1E-6;                   % Permissible error in mixture composition calculation [-]
                51                      % Number of heat exchange steps in the recuperator [-]
               ];
        fid = fopen('utils/input_map.dat', 'w');
        fprintf(fid, '%f\n', data);
        fclose(fid);
        coupling_vars = read_map_input();% read input_map.dat
        coupling_vars = evaluate_map();
        map_output_writer()
        clearvars coupling_vars
        delete('utils/input_map.dat');
        fprintf('TOP: %f, TIT: %f\n', TOP(i), TIT(j));
    end
end
