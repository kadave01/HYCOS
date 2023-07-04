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
function [coupling_vars] = evaluate()
global coupling_vars
coupling_vars = ic_compressor();
coupling_vars = expansion();
coupling_vars = recuperator_hex();
coupling_vars = combustor();

while abs(coupling_vars.local_constants.check(end)/coupling_vars.local_constants.Mixture.mol_frac_CO2(end) -1) > coupling_vars.constants.mol_fraction_error
    coupling_vars = update_turbine_cooling();
    coupling_vars = ic_compressor();
    coupling_vars = expansion();
    coupling_vars = recuperator_hex();
    coupling_vars = combustor();
end
coupling_vars = condensor();
coupling_vars = perfromance();
output_writer();
end

