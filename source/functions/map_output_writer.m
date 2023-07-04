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

%%
function [output_data] = output_writer_map()
global coupling_vars

TOP = coupling_vars.Pressure.P1;
TIT = coupling_vars.Temperature.T6;
Efficiency = coupling_vars.performance.efficiency;
Net_sp_work = coupling_vars.performance.net_work; 
TOT = coupling_vars.Temperature.T9;

fileID = fopen('utils/output_map.dat', 'a');
    fprintf(fileID, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', TOP, TIT, Efficiency, Net_sp_work, TOT);
    fprintf(fileID, '\n');
    fclose(fileID);
end