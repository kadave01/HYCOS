function [coupling_vars] = combustor(coupling_vars)
global coupling_vars
%%
P_inlet = coupling_vars.Pressure.P5;%input from intializer
P_outlet = coupling_vars.Pressure.P6;%input from intializer
T_inlet = coupling_vars.Temperature.T5;
T_outlet = coupling_vars.Temperature.T6;
h_inlet = coupling_vars.sp_enthalpy.h5;
mass_flow_co2_inlet = coupling_vars.mass_flow.M5;
mol_flow_co2_inlet = mass_flow_co2_inlet/coupling_vars.constants.co2_mol_mass;
mol_flow_co2_out = mol_flow_co2_inlet;
mass_flow_co2_out = mass_flow_co2_inlet;
combustion_eff = coupling_vars.constants.combustion_eff;
tracker_mol_frac = 0;%variable definition
tracker_mass_flow_h2= 0;%variable definition
tracker = 0;%variable definition
mass_flow_h2 = 0;
heat_release = inf;
h_added = 0;
h_out = inf;
calorific_value_fuel = coupling_vars.constants.HHV_h2;
x_co2_out = coupling_vars.local_constants.Mixture.mol_frac_CO2(end);
update_x_co2_out = inf;
delta_x_co2 = update_x_co2_out-x_co2_out;


%%
while abs(delta_x_co2) > coupling_vars.constants.mol_fraction_error
    mol_flow_h2o_out = mol_flow_co2_out*(1/x_co2_out - 1);
    x_h2o_out = 1 - x_co2_out;
    mass_flow_h2o_out = mol_flow_h2o_out*coupling_vars.constants.h2o_mol_mass;
    y_co2_out = mass_flow_co2_out/(mass_flow_co2_out+mass_flow_h2o_out);
    y_h2o_out = 1 - y_co2_out;
    H_out = (mass_flow_co2_out+mass_flow_h2o_out)*sp_enthalpy(P_outlet,T_outlet,["CO2","H2O"],[y_co2_out,y_h2o_out],[x_co2_out,x_h2o_out]);
    H_in = mass_flow_co2_inlet*h_inlet+mass_flow_h2o_out*py.CoolProp.CoolProp.PropsSI('H','P',P_inlet,'T',coupling_vars.Temperature.T1,"H2O");
    fuel_burn = (H_out-H_in)/(calorific_value_fuel*combustion_eff);
    update_mass_flow_h2o_out = fuel_burn*9;
    update_x_co2_out = mol_flow_co2_out/(mol_flow_co2_out+update_mass_flow_h2o_out/coupling_vars.constants.h2o_mol_mass);
    delta_x_co2 = update_x_co2_out-x_co2_out;
    if abs(delta_x_co2) < coupling_vars.constants.mol_fraction_error
        break
    else
        x_co2_out = update_x_co2_out;
    end
end

coupling_vars.local_constants.check = [coupling_vars.local_constants.check coupling_vars.local_constants.Mixture.mol_frac_CO2(end)];
coupling_vars.local_constants.Mixture.mol_frac_CO2 = [coupling_vars.local_constants.Mixture.mol_frac_CO2 x_co2_out];
coupling_vars.performance.massflow_h2 = fuel_burn;

end


%% local functions
function [T_out,x_CO2_out,x_H2O_out,y_CO2_out,y_H2O_out,h_vap,h_liq,h_mix,m_mix,mass_flow_vap]  = guess_temperature_PH(Pressure,Enthalpy_mix,initial_guess_temp,molar_flow_CO2_hot_inlet,molar_flow_H2O_hot_inlet,mdot_hot_inlet,mdot_CO2_hot_inlet)

T_out = initial_guess_temp;
H_mix_desired = Enthalpy_mix;
H_mix = 0;
tracker = 0;
tracker_H_mix = [];
tracker_T_out= [];

while abs(H_mix/H_mix_desired - 1) > 1E-6
    tracker = tracker + 1;
    x_H2O_out = molar_flow_H2O_hot_inlet/(molar_flow_H2O_hot_inlet+molar_flow_CO2_hot_inlet);
    x_CO2_out = 1-x_H2O_out;
    molar_flow_rate_out = molar_flow_CO2_hot_inlet / x_CO2_out;
    condensed_moles = molar_flow_H2O_hot_inlet - (molar_flow_rate_out -molar_flow_CO2_hot_inlet);
    mass_flow_liq = condensed_moles*0.0180153; %coupling_vars.constants.h2o_mol_mass;
    mass_flow_vap = mdot_hot_inlet - mass_flow_liq;
    y_CO2_out = mdot_CO2_hot_inlet/ mass_flow_vap;
    y_H2O_out = 1 - y_CO2_out;
    h_vap = sp_enthalpy(Pressure,T_out,["CO2","H2O"],[y_CO2_out,y_H2O_out],[x_CO2_out,x_H2O_out]);
    h_liq = py.CoolProp.CoolProp.PropsSI('H','P',Pressure*x_H2O_out,'Q',0,"H2O");
    H_mix = mass_flow_vap*h_vap + mass_flow_liq*h_liq;
    m_mix = mass_flow_vap+mass_flow_liq;
    h_mix = H_mix/(m_mix);
    tracker_H_mix(tracker) = H_mix;
    tracker_T_out(tracker) = T_out;
    if abs(H_mix/H_mix_desired - 1) < 1E-6
        continue
    elseif tracker == 1 && H_mix < H_mix_desired
        T_out = T_out + 50;
    elseif tracker == 1 && H_mix > H_mix_desired
        T_out = T_out - 50;
    else
        T_out = (H_mix_desired - tracker_H_mix(tracker))/(tracker_H_mix(tracker)-tracker_H_mix(tracker-1)) ...
            * (tracker_T_out(tracker)-tracker_T_out(tracker-1)) + tracker_T_out(tracker);
    end

    if T_out < py.CoolProp.CoolProp.PropsSI('Ttriple', "H2O")
        T_out = (tracker_T_out(tracker) + tracker_T_out(tracker-1))/2;
    end
end
end


