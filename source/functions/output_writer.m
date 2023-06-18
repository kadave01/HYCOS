function [output_data] = output_writer()
global coupling_vars
Pressure = [coupling_vars.Pressure.P1	coupling_vars.Pressure.P2	coupling_vars.Pressure.P3	coupling_vars.Pressure.P4	coupling_vars.Pressure.P5	coupling_vars.Pressure.P6	coupling_vars.Pressure.P7	coupling_vars.Pressure.P8	coupling_vars.Pressure.P9	coupling_vars.Pressure.P10	coupling_vars.Pressure.P11]./1e5;
Temperature = [coupling_vars.Temperature.T1	coupling_vars.Temperature.T2	coupling_vars.Temperature.T3	coupling_vars.Temperature.T4	coupling_vars.Temperature.T5	coupling_vars.Temperature.T6	coupling_vars.Temperature.T7	coupling_vars.Temperature.T8	coupling_vars.Temperature.T9	coupling_vars.Temperature.T10	coupling_vars.Temperature.T11];
Performance = [coupling_vars.performance.efficiency*1e2 coupling_vars.performance.net_work/1e3 coupling_vars.control_vars.PPTD coupling_vars.performance.massflow_h2*1e6];

filename = 'output.dat';
fileID = fopen(filename,'a');
fprintf(fileID,'%.2f,',Pressure);
fprintf(fileID,'\n');
fprintf(fileID,'%.1f,',Temperature);
fprintf(fileID,'\n');
fprintf(fileID,'%.2f,',Performance);
fprintf(fileID,'\n');
fclose(fileID);
fclose('all');

disp(compose("Evaluation completed \n Net efficiency = %.2f%%",coupling_vars.performance.efficiency*1e2))
end