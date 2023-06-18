%% Read the input.dat file
filename = 'input.dat';
fid = fopen(filename, 'r');

data = [];  % store the data here

while ~feof(fid)
    line = fgetl(fid);
    
    % Extract the value part of the line using regular expressions
    value_str = regexprep(line, '\s*%.*', '');  % Remove spaces and everything after '%'
    
    % Process the value part of the line as data
    value = str2double(value_str);  % convert to numeric if needed
    
    if ~isnan(value)  % check if the value is valid
        % Append the data to the storage variable
        data = [data; value];
    end
end

fclose(fid);

%% define global variable
global coupling_vars
%%design variables
coupling_vars.Pressure.P1 = data(1)*1E5;        %compressor inlet 
coupling_vars.Pressure.P2 =  data(2)*1E5;       %compressor outlet 
coupling_vars.Temperature.T6 = data(3);         %combustor outlet
coupling_vars.Temperature.T1 = data(4);         %compressor inlet
coupling_vars.control_vars.PPTD = data(5);           %heat excahnger pinch point <---- check this wrt other papers try 15 deg
%constants
coupling_vars.constants.HEX_pressure_recovery_hp = data(6); 
coupling_vars.constants.HEX_pressure_recovery_lp = data(7);
coupling_vars.constants.combustor_pressure_recovery = data(8);
coupling_vars.constants.compression_Isen_efficiency = data(9)*1E-2;
coupling_vars.constants.expansion_Isen_efficiency = data(10)*1E-2;
coupling_vars.constants.combustion_eff = data(11)*1E-2;
coupling_vars.constants.N_compression_steps = data(12);
coupling_vars.constants.max_blade_temp = data(13);
coupling_vars.constants.co2_mol_mass = data(14)*1E-3;
coupling_vars.constants.h2o_mol_mass = data(15)*1E-3;
coupling_vars.constants.h2_mol_mass = data(16)*1E-3;
coupling_vars.constants.o2_mol_mass = data(17)*1E-3;
coupling_vars.constants.HHV_h2 = 285.8E3/coupling_vars.constants.h2_mol_mass; %J/kgofh2
coupling_vars.constants.LHV_h2 = 241.826E3/coupling_vars.constants.h2_mol_mass; %J/kgofh2
%% Exit criteria
coupling_vars.constants.PPTD_error = 1e-1;
coupling_vars.constants.mol_fraction_error = 1E-6;
%% intialization
coupling_vars.local_constants.HEX_eff= [];
coupling_vars.local_constants.PPTD_tracker = [];
coupling_vars.local_constants.Mixture.mol_frac_CO2 = 0.98;
coupling_vars.local_constants.coolant_fraction = 0.10751;
coupling_vars.local_constants.Mixture.HEX_inlet.x_co2 = [];
coupling_vars.local_constants.Mixture.HEX_inlet.x_h2o = [];
coupling_vars.local_constants.Mixture.HEX_inlet.y_co2 = [];
coupling_vars.local_constants.Mixture.HEX_inlet.y_h2o = [];
coupling_vars.local_constants.check = [];
%% internally computed parameters
coupling_vars.Pressure.CPR = coupling_vars.Pressure.P2/coupling_vars.Pressure.P1;        %Cycle(compression) pressure ratio
coupling_vars.constants.compressor_massflow = 1;%147.060740463587
%% calculated pressures
coupling_vars.Pressure.P2 = coupling_vars.Pressure.P1 * coupling_vars.Pressure.CPR;     %compressor outlet
coupling_vars.Pressure.P3 = coupling_vars.Pressure.P2;      %heat exchanger inlet
coupling_vars.Pressure.P4 = coupling_vars.Pressure.P3 * coupling_vars.constants.HEX_pressure_recovery_hp;       %heat exchanger outlet
coupling_vars.Pressure.P5 = coupling_vars.Pressure.P4; %combustor inlet
coupling_vars.Pressure.P6 = coupling_vars.Pressure.P5 * coupling_vars.constants.combustor_pressure_recovery;        %combustor outlet
coupling_vars.Pressure.P7 = coupling_vars.Pressure.P6; %turbine inlet
coupling_vars.Pressure.P12 = coupling_vars.Pressure.P1;      %dryer outlet
coupling_vars.Pressure.P11 = coupling_vars.Pressure.P12/coupling_vars.constants.HEX_pressure_recovery_lp;     %dryer inlet
coupling_vars.Pressure.P10 = coupling_vars.Pressure.P11;       %heat exchanger outlet
coupling_vars.Pressure.P9 = coupling_vars.Pressure.P10/coupling_vars.constants.HEX_pressure_recovery_lp;       %heat exchanger inlet
coupling_vars.Pressure.P8 = coupling_vars.Pressure.P9;     %turbine outlet
%% massaflow
coupling_vars.mass_flow.M1 = coupling_vars.constants.compressor_massflow;
coupling_vars.mass_flow.M2 = coupling_vars.mass_flow.M1;
%% Setting reference temperature and pressue in CoolProp
T_ref = coupling_vars.Temperature.T1; %[K]
P_ref = coupling_vars.Pressure.P5; %[Pa]
h_ref = 0; %[J/mol]
s_ref = 0; %[J/(mol.K)]
py.CoolProp.CoolProp.set_reference_state('CO2',T_ref,py.CoolProp.CoolProp.PropsSI('Dmolar','P',P_ref,'T',T_ref,'CO2'),h_ref,s_ref);
py.CoolProp.CoolProp.set_reference_state('H2O',T_ref,py.CoolProp.CoolProp.PropsSI('Dmolar','P',P_ref,'T',T_ref,'H2O'),h_ref,s_ref);
py.CoolProp.CoolProp.set_reference_state('O2',T_ref,py.CoolProp.CoolProp.PropsSI('Dmolar','P',P_ref,'T',T_ref,'O2'),h_ref,s_ref);
py.CoolProp.CoolProp.set_reference_state('H2',T_ref,py.CoolProp.CoolProp.PropsSI('Dmolar','P',P_ref,'T',T_ref,'H2'),h_ref,s_ref);
