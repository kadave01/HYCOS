function [coupling_vars] = perfromance(coupling_vars)
global coupling_vars
coupling_vars.performance.compressor_work = sum(coupling_vars.performance.compressor_sp_work_profile)*coupling_vars.mass_flow.M1;
coupling_vars.performance.turbine_work = coupling_vars.performance.sp_expansion_work*coupling_vars.mass_flow.M7;
coupling_vars.performance.net_work = round(coupling_vars.performance.turbine_work - coupling_vars.performance.compressor_work,3); 
coupling_vars.performance.fuel_energy = coupling_vars.performance.massflow_h2*coupling_vars.constants.LHV_h2;
coupling_vars.performance.fuel_energy_HHV = coupling_vars.performance.massflow_h2*coupling_vars.constants.HHV_h2;
coupling_vars.performance.efficiency = round(coupling_vars.performance.net_work/coupling_vars.performance.fuel_energy,4);
coupling_vars.performance.efficiency_HHV = coupling_vars.performance.net_work/coupling_vars.performance.fuel_energy_HHV;
coupling_vars.performance.heat_rejected = sum(coupling_vars.performance.sp_heat_rejected_intercooler)*coupling_vars.mass_flow.M1 + coupling_vars.performance.heat_rejected_condenser;
end