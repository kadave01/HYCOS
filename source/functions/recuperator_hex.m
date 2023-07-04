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
function [coupling_vars] = recuperator_hex(coupling_vars)
global coupling_vars
%%
PPTD_desired = coupling_vars.control_vars.PPTD;%input from intializer
if isempty(coupling_vars.local_constants.PPTD_tracker)
   coupling_vars.local_constants.PPTD_tracker = [coupling_vars.local_constants.PPTD_tracker PPTD_desired];
elseif abs(coupling_vars.local_constants.PPTD_tracker(end)-PPTD_desired) > 1E-2
    coupling_vars.local_constants.PPTD_tracker = [coupling_vars.local_constants.PPTD_tracker PPTD_desired];
end
PPTD_error = coupling_vars.constants.PPTD_error;
PPTD = inf;%variable definition
tracker_PPTD = 0;%variable definition
tracker_HEX = 0;%variable definition
tracker = 0;%variable definition
PPTD_adjust_counter = 0;
hex_steps = coupling_vars.local_constants.hex_steps;
if isempty(coupling_vars.local_constants.HEX_eff)
    HEX_effectiveness = 1;%variable definition
else
    HEX_effectiveness = coupling_vars.local_constants.HEX_eff(end);
end


%% Hot side inlet conditions
x_CO2_hot_inlet = coupling_vars.local_constants.Mixture.HEX_inlet.x_co2(end);
x_H2O_hot_inlet = 1 - x_CO2_hot_inlet;
T_hot_inlet = coupling_vars.Temperature.T9;
P_hot_inlet = coupling_vars.Pressure.P9;
P_hot_outlet = coupling_vars.Pressure.P10;
mdot_hot_inlet = coupling_vars.mass_flow.M9;
y_CO2_hot_inlet = coupling_vars.local_constants.Mixture.HEX_inlet.y_co2(end);
y_H2O_hot_inlet = 1-y_CO2_hot_inlet;
mdot_CO2_hot_inlet = coupling_vars.mass_flow.M1;
molar_flow_CO2_hot_inlet = mdot_CO2_hot_inlet/coupling_vars.constants.co2_mol_mass;
molar_flow_total_hot_inlet = molar_flow_CO2_hot_inlet/x_CO2_hot_inlet;
molar_flow_H2O_hot_inlet = molar_flow_total_hot_inlet-molar_flow_CO2_hot_inlet;

%% Cold side inlet conditions
T_cold_inlet = coupling_vars.Temperature.T3;
P_cold_inlet = coupling_vars.Pressure.P3;
mdot_cold_side = coupling_vars.mass_flow.M3;
P_cold_outlet = coupling_vars.Pressure.P4;


while abs(PPTD-PPTD_desired) > PPTD_error && PPTD_adjust_counter < 25
    if HEX_effectiveness > 1
    msg = "Desired HEX_effectiveness more than 100%, increasing desrired PPTD from  " + PPTD_desired + "deg.C to  "+ (PPTD_desired+1) + "deg.C";
%     disp(msg);%Error message based on HEX_effectiveness to high
%         break;
    HEX_effectiveness = 1;
    PPTD_desired = PPTD_desired+1; 
    PPTD_adjust_counter = PPTD_adjust_counter +1;
    coupling_vars.control_vars.PPTD = PPTD_desired;
    coupling_vars.local_constants.PPTD_tracker = [coupling_vars.local_constants.PPTD_tracker PPTD_desired];
    tracker_PPTD = 0;%variable definition
    tracker_HEX = 0;%variable definition
    tracker = 0;%variable definition
    end
    tracker = tracker + 1;
    %% Max heat transfer calculation
    H_inlet_hot_side = mdot_hot_inlet*coupling_vars.sp_enthalpy.h9;
    % if cooled to cold inlet temperature, some water vapor will condense out.
    % we evaluate this condensed fraction in the following lines
    ref_T_sat = T_sat(P_hot_inlet,"H2O",x_H2O_hot_inlet);
    if T_cold_inlet<ref_T_sat
        hypo_x_H2O_outlet_cold_inlet_temp = P_sat(T_cold_inlet,"H2O")/P_hot_inlet;
    else
        hypo_x_H2O_outlet_cold_inlet_temp = x_H2O_hot_inlet;
    end
    hypo_x_C2O_outlet_cold_inlet_temp = 1- hypo_x_H2O_outlet_cold_inlet_temp;
    hypo_molar_flow_rate = molar_flow_CO2_hot_inlet / hypo_x_C2O_outlet_cold_inlet_temp;
    hypo_condensed_moles_H2O = molar_flow_H2O_hot_inlet - (hypo_molar_flow_rate - molar_flow_CO2_hot_inlet);
    hypo_condensed_mass_H2O = hypo_condensed_moles_H2O * coupling_vars.constants.h2o_mol_mass;
    hypo_mdot_vapor = mdot_hot_inlet - hypo_condensed_mass_H2O;
    hypo_y_C2O_outlet_cold_inlet_temp = mdot_CO2_hot_inlet/hypo_mdot_vapor;
    hypo_y_H2O_outlet_cold_inlet_temp = 1-hypo_y_C2O_outlet_cold_inlet_temp;
    hypo_H_hot_outlet_cold_inlet_temp = hypo_mdot_vapor*sp_enthalpy(P_hot_inlet,T_cold_inlet, ...
        ["CO2","H2O"],[hypo_y_C2O_outlet_cold_inlet_temp,hypo_y_H2O_outlet_cold_inlet_temp], ...
        [hypo_x_C2O_outlet_cold_inlet_temp,hypo_x_H2O_outlet_cold_inlet_temp]) ...
        + hypo_condensed_mass_H2O*py.CoolProp.CoolProp.PropsSI('H','P',P_hot_inlet,'Q',0,"H2O");
    HT_capacity_hot_side = H_inlet_hot_side - hypo_H_hot_outlet_cold_inlet_temp;

    %% cold side calculations
    H_inlet_cold_side = mdot_cold_side*sp_enthalpy(P_cold_inlet,T_cold_inlet,"CO2",1,1);
    hypo_H_cold_outlet_hot_inlet_temp = mdot_cold_side*sp_enthalpy(P_cold_inlet,T_hot_inlet,"CO2",1,1);
    HT_capacity_cold_side = hypo_H_cold_outlet_hot_inlet_temp - H_inlet_cold_side;
    max_heat_transfer = min(HT_capacity_cold_side,HT_capacity_hot_side);
    actual_heat_transfer = max_heat_transfer*HEX_effectiveness;
    H_outlet_cold_side = H_inlet_cold_side + actual_heat_transfer;
    h_outlet_cold_side = H_outlet_cold_side/mdot_cold_side;
    T_cold_outlet = py.CoolProp.CoolProp.PropsSI('T','P',P_cold_outlet,'H',h_outlet_cold_side,"CO2");
    sp_entropy_cold_outelt = sp_entropy(P_cold_outlet,T_cold_outlet,"CO2",1,1);

    %% Hot side evaluation
    H_outlet_hot_side = H_inlet_hot_side - actual_heat_transfer;
    if tracker == 1
        guess_temp = T_cold_inlet;
    else
        guess_temp = T_hot_outlet;
    end

    [T_hot_outlet,x_co2_out,x_h2o_out,y_co2_out,y_h2o_out,h_vap,h_mix,m_mix,m_vap] = guess_temperature_Ph(P_hot_outlet, ...
        H_outlet_hot_side,guess_temp,molar_flow_CO2_hot_inlet,molar_flow_H2O_hot_inlet, ...
        mdot_hot_inlet,mdot_CO2_hot_inlet);
    sp_entropy_hot_outelt = (m_vap/m_mix)*sp_entropy(P_hot_outlet,T_hot_outlet,["CO2","H2O"],[y_co2_out,y_h2o_out], ...
        [x_co2_out,x_h2o_out]) + (1-m_vap/m_mix)*py.CoolProp.CoolProp.PropsSI('S','P',P_hot_outlet,'Q',0,"H2O");
    sp_entropy_dryer_inlet = sp_entropy(P_hot_outlet,T_hot_outlet,["CO2","H2O"],[y_co2_out,y_h2o_out],[x_co2_out,x_h2o_out]);

    %% Pinch point
    T_cold_profile = zeros(1,hex_steps);
    T_hot_profile = zeros(1,hex_steps);
    H_cold_profile = linspace(H_inlet_cold_side,H_outlet_cold_side,hex_steps);
    H_hot_profile = linspace(H_outlet_hot_side,H_inlet_hot_side,hex_steps);
    P_cold_profile = linspace(P_cold_inlet,P_cold_outlet,hex_steps);
    P_hot_profile = linspace(P_hot_outlet,P_hot_inlet,hex_steps);

    for i=1:length(H_cold_profile)
        local_sp_enthalpy = H_cold_profile(i)/mdot_cold_side;
        T_cold_profile(i) = py.CoolProp.CoolProp.PropsSI('T','H',local_sp_enthalpy,'P',P_cold_profile(i),"CO2");
    end

    for i=1:length(H_hot_profile)
        T_hot_profile(i) = guess_temperature_Ph(P_hot_profile(i),H_hot_profile(i),T_cold_profile(i), ...
            molar_flow_CO2_hot_inlet,molar_flow_H2O_hot_inlet,mdot_hot_inlet,mdot_CO2_hot_inlet);
    end

    dT = T_hot_profile - T_cold_profile;
    PPTD = min(dT);
    margin = (PPTD-PPTD_desired);
    tracker_PPTD(tracker) = PPTD;
    tracker_HEX(tracker) = HEX_effectiveness;

    if abs(margin) < PPTD_error
        if max_heat_transfer == HT_capacity_cold_side
            coupling_vars.local_constants.stream = "HP";
        else
            coupling_vars.local_constants.stream = "LP";
        end
        coupling_vars.local_constants.avg_cold_cp = actual_heat_transfer/mdot_cold_side/(T_cold_outlet-T_cold_inlet);
        coupling_vars.local_constants.avg_hot_cp = actual_heat_transfer/mdot_hot_inlet/(T_hot_inlet-T_hot_outlet);
        coupling_vars.local_constants.hex_process = [actual_heat_transfer/50*linspace(0,50,hex_steps);dT];
        coupling_vars.local_constants.cr = min(HT_capacity_cold_side,HT_capacity_hot_side)/max(HT_capacity_cold_side,HT_capacity_hot_side);
        break;
    else
        if tracker < 2
            if margin > 0
                HEX_effectiveness = HEX_effectiveness + 0.005;
            else
                HEX_effectiveness = HEX_effectiveness - 0.005;
            end
        else
            HEX_effectiveness = HEX_effectiveness - ((tracker_PPTD(end) - PPTD_desired)/(tracker_PPTD(end) - tracker_PPTD(end-1)) * (tracker_HEX(end)-tracker_HEX(end-1)));
        end
    end
end

%% feedback
coupling_vars.Temperature.T4 = T_cold_outlet;
coupling_vars.Temperature.T5 = T_cold_outlet;
coupling_vars.Temperature.T10 = T_hot_outlet;
coupling_vars.Temperature.T11 = T_hot_outlet;
coupling_vars.mass_flow.M10 = m_mix;
coupling_vars.mass_flow.M11 = m_vap;
coupling_vars.sp_enthalpy.h4 = h_outlet_cold_side;
coupling_vars.sp_enthalpy.h5 = h_outlet_cold_side;
coupling_vars.sp_enthalpy.h10 = h_mix;
coupling_vars.sp_enthalpy.h11 = h_vap;
coupling_vars.sp_entropy.s4 = sp_entropy_cold_outelt;
coupling_vars.sp_entropy.s5 = sp_entropy_cold_outelt;
coupling_vars.sp_entropy.s10 = sp_entropy_hot_outelt;
coupling_vars.sp_entropy.s11 = sp_entropy_dryer_inlet;
coupling_vars.local_constants.HEX_eff = [coupling_vars.local_constants.HEX_eff HEX_effectiveness];
coupling_vars.performance.heat_recuperated = actual_heat_transfer;
end

%% local function definition

    function [H_mix,y_H2O_out,y_CO2_out,x_H2O_out,x_CO2_out]  = Enthalpy_out(T_out,P_hot_outlet,molar_flow_CO2_hot_inlet,molar_flow_H2O_hot_inlet,mdot_hot_inlet,mdot_CO2_hot_inlet)
    x_H2O_out = P_sat(T_out,"H2O")/P_hot_outlet;
    x_CO2_out = 1-x_H2O_out;
    molar_flow_rate_out = molar_flow_CO2_hot_inlet / x_CO2_out;
    condensed_moles = molar_flow_H2O_hot_inlet - (molar_flow_rate_out -molar_flow_CO2_hot_inlet);
    mass_flow_liq = condensed_moles*0.018015300000000; %coupling_vars.constants.h2o_mol_mass;
    mass_flow_vap = mdot_hot_inlet - mass_flow_liq;
    y_CO2_out = mdot_CO2_hot_inlet/ mass_flow_vap;
    y_H2O_out = 1 - y_CO2_out;
    H_mix = mass_flow_vap*sp_enthalpy(P_hot_outlet,T_out,["CO2","H2O"],[y_CO2_out,y_H2O_out],[x_CO2_out,x_H2O_out]) ...
        + mass_flow_liq* py.CoolProp.CoolProp.PropsSI('H','P',P_hot_outlet*x_H2O_out,'Q',0,"H2O");
    end
    function [T_out,x_CO2_out,x_H2O_out,y_CO2_out,y_H2O_out,h_vap,h_mix,m_mix,mass_flow_vap]  = guess_temperature_Ph(Pressure,Enthalpy_mix,initial_guess_temp,molar_flow_CO2_hot_inlet,molar_flow_H2O_hot_inlet,mdot_hot_inlet,mdot_CO2_hot_inlet)

    T_out = initial_guess_temp;
    H_mix_desired = Enthalpy_mix;
    H_mix = inf;
    tracker = 0;
    tracker_H_mix = [];
    tracker_T_out= [];
    x_H2O_in = molar_flow_H2O_hot_inlet/(molar_flow_CO2_hot_inlet+molar_flow_H2O_hot_inlet);
    Temp_sat = T_sat(Pressure,"H2O",x_H2O_in);

    while abs(H_mix/H_mix_desired - 1) > 1E-6
        if T_out < Temp_sat
            x_H2O_out = P_sat(T_out,"H2O")/Pressure;
            if x_H2O_out > 1
                x_H2O_out = x_H2O_in;
            end
        else
               x_H2O_out = x_H2O_in;
        end
        tracker = tracker + 1;
        x_CO2_out = 1-x_H2O_out;
        molar_flow_rate_out = molar_flow_CO2_hot_inlet / x_CO2_out;
        condensed_moles = molar_flow_H2O_hot_inlet - (molar_flow_rate_out -molar_flow_CO2_hot_inlet);
        mass_flow_liq = condensed_moles*0.0180153; %coupling_vars.constants.h2o_mol_mass;
        mass_flow_vap = mdot_hot_inlet - mass_flow_liq;
        y_CO2_out = mdot_CO2_hot_inlet/ mass_flow_vap;
        y_H2O_out = 1 - y_CO2_out;
        h_vap = sp_enthalpy(Pressure,T_out,["CO2","H2O"],[y_CO2_out,y_H2O_out],[x_CO2_out,x_H2O_out]);
        h_liq = py.CoolProp.CoolProp.PropsSI('H','P',Pressure,'Q',0,"H2O"); %py.CoolProp.CoolProp.PropsSI('H','P',Pressure*x_H2O_out,'Q',0,"H2O");
        H_mix = mass_flow_vap*h_vap + mass_flow_liq*h_liq;
        m_mix = mass_flow_vap+mass_flow_liq;
        h_mix = H_mix/(m_mix);

        tracker_H_mix(tracker) = H_mix;
        tracker_T_out(tracker) = T_out;
        error = H_mix/H_mix_desired - 1;

        if abs(error) < 1E-6
            continue
        elseif tracker == 1 && H_mix < H_mix_desired
            T_out = T_out + 5.0;
        elseif tracker == 1 && H_mix > H_mix_desired
            T_out = T_out - 5.0;
        else
            delta_t_max = 5;
            delta_t_grad = (H_mix_desired - tracker_H_mix(tracker))/(tracker_H_mix(tracker)-tracker_H_mix(tracker-1)) ...
                * (tracker_T_out(tracker)-tracker_T_out(tracker-1));
            delta_t = min (delta_t_max,abs(delta_t_grad));
            if H_mix < H_mix_desired
                T_out = T_out + delta_t;
            else 
            T_out = T_out - delta_t;
            end
        end

        if T_out < py.CoolProp.CoolProp.PropsSI('Ttriple', "H2O")
            T_out = (tracker_T_out(tracker) + tracker_T_out(tracker-1))/2;
        end
        end
    end
    
    function [h] = sp_enthalpy (Pressure,Temperature,species,mass_fraction,mol_fraction)
    n = length(species);
    h = 0;
    for i = 1:n
        if mass_fraction(i) == 0
            continue
        else
            try
                h = h + mass_fraction(i)*py.CoolProp.CoolProp.PropsSI('H','P',Pressure*mol_fraction(i),'T',Temperature,species(i));
            catch ME
                if (strcmp(ME.identifier,'MATLAB:Python:PyException'))
                    msg = strjoin(["Error caused by proximity to saturation line of",species(n),". \nIt is possible that the defined mixture exists in 2 phases." ...
                        "\nThe retunred value of h_mix is calcualted assuming only the gaseous fraction"]);
                    causeException = MException('MATLAB:myCode:dimensions',msg);
                    ME = addCause(ME,causeException);
                end
                h = h + mass_fraction(i)*py.CoolProp.CoolProp.PropsSI('H','P',Pressure*mol_fraction(i),'Q',1,species(i));
            end
        end
    end
    end

