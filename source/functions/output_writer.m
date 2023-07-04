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
function [output_data] = output_writer()
global coupling_vars
Pressure = [coupling_vars.Pressure.P1	coupling_vars.Pressure.P2	coupling_vars.Pressure.P3	coupling_vars.Pressure.P4	coupling_vars.Pressure.P5	coupling_vars.Pressure.P6	coupling_vars.Pressure.P7	coupling_vars.Pressure.P8	coupling_vars.Pressure.P9	coupling_vars.Pressure.P10	coupling_vars.Pressure.P11]./1e5;
Temperature = [coupling_vars.Temperature.T1	coupling_vars.Temperature.T2	coupling_vars.Temperature.T3	coupling_vars.Temperature.T4	coupling_vars.Temperature.T5	coupling_vars.Temperature.T6	coupling_vars.Temperature.T7	coupling_vars.Temperature.T8	coupling_vars.Temperature.T9	coupling_vars.Temperature.T10	coupling_vars.Temperature.T11];
Performance = [coupling_vars.performance.efficiency*1e2 coupling_vars.performance.net_work/1e3 coupling_vars.control_vars.PPTD coupling_vars.performance.massflow_h2*1e3];

filename = 'output.dat';
fileID = fopen(filename,'w');
fprintf(fileID,'%.2f,',Pressure);
fprintf(fileID,'\n');
fprintf(fileID,'%.2f,',Temperature);
fprintf(fileID,'\n');
fprintf(fileID,'%.3f,',Performance);
fprintf(fileID,'\n');
fclose(fileID);
fclose('all');

disp(compose("Evaluation completed \n Net efficiency = %.2f%%",coupling_vars.performance.efficiency*1e2))
end