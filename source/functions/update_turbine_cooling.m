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