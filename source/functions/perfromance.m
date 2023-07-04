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