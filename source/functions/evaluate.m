global coupling_vars
coupling_vars = ic_compressor();
coupling_vars = expansion_new();
coupling_vars = recuperator_hex();
coupling_vars = combustor();

while abs(coupling_vars.local_constants.check(end)/coupling_vars.local_constants.Mixture.mol_frac_CO2(end) -1) > coupling_vars.constants.mol_fraction_error
    coupling_vars = update_turbine_cooling();
    coupling_vars = ic_compressor();
    coupling_vars = expansion_new();
    coupling_vars = recuperator_hex();
    coupling_vars = combustor();
end
coupling_vars = condensor();
coupling_vars = perfromance();