
% MIT License
% 
% Copyright (c) 2023 Kaushal Dave
% 
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

close all
clear all
clc
TOP = [1,2:2:100]; %specify the desired values of TOP
TIT = [1000:5:2000]; %specify the desired values of TIT
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

fileID = fopen('../utils/output_map.dat', 'w');
    fprintf(fileID, 'TOP[Pa]\tTIT[K]\tEfficiency[-]\tNet_sp_work[J/kgCO2]\tTOT[K]\n');
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
        coupling_vars = read_map_input(data);% read input_map.dat
        coupling_vars = evaluate_map();
        map_output_writer()
        clearvars coupling_vars
        fprintf('TOP: %f, TIT: %f\n', TOP(i), TIT(j));
    end
end
