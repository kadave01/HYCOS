function [coupling_vars] = expansion_new(coupling_vars)
global coupling_vars
%% turbine cooling flow dump 1
x_co2_combustor_outlet = coupling_vars.local_constants.Mixture.mol_frac_CO2(end);
x_h2o_combustor_outlet = 1-x_co2_combustor_outlet;
no_moles_co2 = coupling_vars.mass_flow.M5/coupling_vars.constants.co2_mol_mass; 
total_moles = no_moles_co2/x_co2_combustor_outlet;
no_moles_h2o = total_moles - no_moles_co2;
mass_flow_co2 = no_moles_co2*coupling_vars.constants.co2_mol_mass;
mass_flow_h2o = no_moles_h2o*coupling_vars.constants.h2o_mol_mass;
total_mass_flow_combustor_outlet = mass_flow_co2 + mass_flow_h2o;
y_co2_combustor_outlet = mass_flow_co2/total_mass_flow_combustor_outlet;
y_h2o_combustor_outlet = 1-y_co2_combustor_outlet;
TurbineCoolingFlow = coupling_vars.mass_flow.M1*coupling_vars.local_constants.coolant_fraction;

%% expansion
P_turbine_inlet = min(coupling_vars.Pressure.P7,coupling_vars.Pressure.coolant);
P_turbine_outlet = coupling_vars.Pressure.P8;
Isen_efficiency = coupling_vars.constants.expansion_Isen_efficiency;
sp_entropy_comubstor_outlet = sp_entropy(P_turbine_inlet,coupling_vars.Temperature.T6,["CO2","H2O"], ...
    [y_co2_combustor_outlet,y_h2o_combustor_outlet],[x_co2_combustor_outlet,x_h2o_combustor_outlet]);
mass_flow_turbine_inlet = total_mass_flow_combustor_outlet + TurbineCoolingFlow/2;
sp_enthalpy_comubstor_outlet = sp_enthalpy(P_turbine_inlet,coupling_vars.Temperature.T6,["CO2","H2O"], ...
    [y_co2_combustor_outlet,y_h2o_combustor_outlet],[x_co2_combustor_outlet,x_h2o_combustor_outlet]);
enthalpy_turbine_inlet = total_mass_flow_combustor_outlet*sp_enthalpy_comubstor_outlet ...
    + TurbineCoolingFlow/2*coupling_vars.sp_enthalpy.h2;
sp_enthalpy_inlet = enthalpy_turbine_inlet/mass_flow_turbine_inlet;
mass_flow_co2_turbine_inlet = mass_flow_co2 + TurbineCoolingFlow/2;
mass_flow_h2o_turbine_inlet = mass_flow_turbine_inlet - mass_flow_co2_turbine_inlet;
no_moles_co2_turbine_inlet = mass_flow_co2_turbine_inlet/coupling_vars.constants.co2_mol_mass; 
no_moles_h2o_turbine_inlet = mass_flow_h2o_turbine_inlet/coupling_vars.constants.h2o_mol_mass; 
x_co2_turbine_inlet = no_moles_co2_turbine_inlet/ (no_moles_co2_turbine_inlet + no_moles_h2o_turbine_inlet);
x_h2o_turbine_inlet = 1 - x_co2_turbine_inlet;
y_co2_turbine_inlet = mass_flow_co2_turbine_inlet / (mass_flow_turbine_inlet);
y_h2o_turbine_inlet = 1 - y_co2_turbine_inlet;
Temperature_turbine_inlet = Mix_temperature_Ph(P_turbine_inlet,sp_enthalpy_inlet, ...
    ["CO2","H2O"],[y_co2_turbine_inlet,y_h2o_turbine_inlet],[x_co2_turbine_inlet,x_h2o_turbine_inlet]);
sp_entropy_inlet = sp_entropy(P_turbine_inlet,Temperature_turbine_inlet,["CO2","H2O"], ...
    [y_co2_turbine_inlet,y_h2o_turbine_inlet],[x_co2_turbine_inlet,x_h2o_turbine_inlet]);
ideal_sp_entropy_outlet = sp_entropy_inlet;
ideal_Temperature_trubine_outlet = Mix_temperature_Ps(P_turbine_outlet,ideal_sp_entropy_outlet,["CO2","H2O"], ...
    [y_co2_turbine_inlet,y_h2o_turbine_inlet],[x_co2_turbine_inlet,x_h2o_turbine_inlet]);
ideal_sp_enthalpy_turbine_outlet = sp_enthalpy(P_turbine_outlet,ideal_Temperature_trubine_outlet,["CO2","H2O"], ...
    [y_co2_turbine_inlet,y_h2o_turbine_inlet],[x_co2_turbine_inlet,x_h2o_turbine_inlet]);
ideal_sp_work_expansion = (sp_enthalpy_inlet - ideal_sp_enthalpy_turbine_outlet);
actual_sp_work_expansion = ideal_sp_work_expansion*Isen_efficiency;
sp_enthalpy_turbine_outlet = sp_enthalpy_inlet - actual_sp_work_expansion;
Temperature_turbine_outlet = Mix_temperature_Ph(P_turbine_outlet,sp_enthalpy_turbine_outlet,["CO2","H2O"], ...
    [y_co2_turbine_inlet,y_h2o_turbine_inlet],[x_co2_turbine_inlet,x_h2o_turbine_inlet]);
sp_entropy_outlet = sp_entropy(P_turbine_outlet,Temperature_turbine_outlet,["CO2","H2O"], ...
    [y_co2_turbine_inlet,y_h2o_turbine_inlet],[x_co2_turbine_inlet,x_h2o_turbine_inlet]);


%% turbine cooling flow dump 2

mass_flow_inlet_HEX = mass_flow_turbine_inlet + TurbineCoolingFlow/2;
mass_flow_co2_inlet_HEX = mass_flow_co2_turbine_inlet + TurbineCoolingFlow/2;
y_co2_HEX_inlet = mass_flow_co2_inlet_HEX/mass_flow_inlet_HEX;
y_h2o_HEX_inlet = 1 - y_co2_HEX_inlet;
no_moles_h2o_HEX_inlet = no_moles_h2o_turbine_inlet;
no_moles_co2_HEX_inlet = mass_flow_co2_inlet_HEX/coupling_vars.constants.co2_mol_mass;
no_moles_HEX_inlet = no_moles_co2_HEX_inlet + no_moles_h2o_HEX_inlet;
x_co2_HEX_inlet = no_moles_co2_HEX_inlet/no_moles_HEX_inlet;
x_h2o_HEX_inlet = 1 - x_co2_HEX_inlet;

enthalpy_HEX_inlet = sp_enthalpy_turbine_outlet*mass_flow_turbine_inlet...
    + TurbineCoolingFlow/2*coupling_vars.sp_enthalpy.h2;
sp_enthalpy_HEX_inlet = enthalpy_HEX_inlet/mass_flow_inlet_HEX;
Temperature_HEX_inlet = Mix_temperature_Ph(P_turbine_outlet,sp_enthalpy_HEX_inlet, ...
    ["CO2","H2O"],[y_co2_HEX_inlet,y_h2o_HEX_inlet],[x_co2_HEX_inlet,x_h2o_HEX_inlet]);
sp_entropy_HEX_inlet = sp_entropy(P_turbine_outlet,Temperature_HEX_inlet, ...
    ["CO2","H2O"],[y_co2_HEX_inlet,y_h2o_HEX_inlet],[x_co2_HEX_inlet,x_h2o_HEX_inlet]);


%% feedback
coupling_vars.local_constants.coolant_fraction = TurbineCoolingFlow/coupling_vars.constants.compressor_massflow;
coupling_vars.Temperature.T7 = Temperature_turbine_inlet;
coupling_vars.Temperature.T8 = Temperature_turbine_outlet;
coupling_vars.Temperature.T9 = Temperature_HEX_inlet;
coupling_vars.sp_enthalpy.h6 = sp_enthalpy_comubstor_outlet;
coupling_vars.sp_enthalpy.h7 = sp_enthalpy_inlet;
coupling_vars.sp_enthalpy.h8 = sp_enthalpy_turbine_outlet;
coupling_vars.sp_enthalpy.h9 = sp_enthalpy_HEX_inlet;
coupling_vars.sp_entropy.s6 = sp_entropy_comubstor_outlet;
coupling_vars.sp_entropy.s7 = sp_entropy_inlet;
coupling_vars.sp_entropy.s8 = sp_entropy_outlet;
coupling_vars.sp_entropy.s9 = sp_entropy_HEX_inlet;
coupling_vars.local_constants.Mixture.HEX_inlet.x_co2 = [coupling_vars.local_constants.Mixture.HEX_inlet.x_co2 x_co2_HEX_inlet];
coupling_vars.local_constants.Mixture.HEX_inlet.x_h2o = [coupling_vars.local_constants.Mixture.HEX_inlet.x_h2o x_h2o_HEX_inlet];
coupling_vars.local_constants.Mixture.HEX_inlet.y_co2 = [coupling_vars.local_constants.Mixture.HEX_inlet.y_co2 y_co2_HEX_inlet];
coupling_vars.local_constants.Mixture.HEX_inlet.y_h2o = [coupling_vars.local_constants.Mixture.HEX_inlet.y_h2o y_h2o_HEX_inlet];
coupling_vars.mass_flow.M6 = total_mass_flow_combustor_outlet;
coupling_vars.mass_flow.M7 = mass_flow_turbine_inlet;
coupling_vars.mass_flow.M8 = mass_flow_turbine_inlet;
coupling_vars.mass_flow.M9 = mass_flow_inlet_HEX;
coupling_vars.performance.sp_expansion_work = actual_sp_work_expansion;
end