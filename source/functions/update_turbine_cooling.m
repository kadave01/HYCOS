function [coupling_vars] = update_turbine_cooling(coupling_vars)
global coupling_vars
constant_mu_c = 0.08;
constant_phi_inf = 0.9;
constant_beta = 0.9;
constant_T_b = coupling_vars.constants.max_blade_temp;
constant_T_c_in = coupling_vars.Temperature.coolant;
% variables
variable_T_combustor_outlet = ceil(coupling_vars.Temperature.T6);
variable_MassFlow_Turbine_inlet = coupling_vars.mass_flow.M6;
variable_phi = (variable_T_combustor_outlet - constant_T_b) / (variable_T_combustor_outlet - constant_T_c_in );
if variable_T_combustor_outlet > constant_T_b
    coupling_vars.local_constants.coolant_fraction = (constant_mu_c * variable_MassFlow_Turbine_inlet * (variable_phi/(constant_phi_inf-variable_phi))^constant_beta)/coupling_vars.mass_flow.M1;
elseif variable_T_combustor_outlet < constant_T_b
    coupling_vars.local_constants.coolant_fraction = 0;
end
end