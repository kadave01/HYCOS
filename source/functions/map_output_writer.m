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