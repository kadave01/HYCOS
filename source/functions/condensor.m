function [coupling_vars] = condensor(coupling_vars)
global coupling_vars
enthalpy_inlet = coupling_vars.sp_enthalpy.h10*coupling_vars.mass_flow.M10;
enthalpy_outlet = coupling_vars.sp_enthalpy.h1*coupling_vars.mass_flow.M1; %+ (coupling_vars.mass_flow.M11-coupling_vars.mass_flow.M1)*py.CoolProp.CoolProp.PropsSI('H','T',coupling_vars.Temperature.T1,'Q',0,"H2O");
coupling_vars.performance.heat_rejected_condenser = abs(enthalpy_outlet - enthalpy_inlet);
end