function [coupling_vars] = ic_compressor(coupling_vars)
    global coupling_vars
    %% Inputs
    P_inlet = coupling_vars.Pressure.P1;
    P_outlet = coupling_vars.Pressure.P2;
    T_inlet = coupling_vars.Temperature.T1;
    Isen_efficiency = coupling_vars.constants.compression_Isen_efficiency;
    N_compression_steps = coupling_vars.constants.N_compression_steps;
    compressor_massflow = coupling_vars.constants.compressor_massflow;

    %% Inlet Calculations
    stage_pr_ratio = (P_outlet/P_inlet)^(1/N_compression_steps);
    Inlet_Pressure_profile = zeros(1,N_compression_steps);
    Inlet_Pressure_profile(1) = P_inlet;
    for i=2:N_compression_steps
        Inlet_Pressure_profile(i) = Inlet_Pressure_profile(i-1)*stage_pr_ratio;
    end

    Inlet_Temperature_profile = ones(1,N_compression_steps).*T_inlet;
    for i=1:N_compression_steps
        try
        Inlet_sp_enthalpy_profile(i) = py.CoolProp.CoolProp.PropsSI('H','P',Inlet_Pressure_profile(i),'T',Inlet_Temperature_profile(i),"CO2");
        Inlet_sp_entropy_profile(i) = py.CoolProp.CoolProp.PropsSI('S','P',Inlet_Pressure_profile(i),'T',Inlet_Temperature_profile(i),"CO2");
        Inlet_density_profile(i) = py.CoolProp.CoolProp.PropsSI('D','P',Inlet_Pressure_profile(i),'T',Inlet_Temperature_profile(i),"CO2");
        catch
        Inlet_sp_enthalpy_profile(i) = py.CoolProp.CoolProp.PropsSI('H','P',Inlet_Pressure_profile(i),'Q',0,"CO2");
        Inlet_sp_entropy_profile(i) = py.CoolProp.CoolProp.PropsSI('S','P',Inlet_Pressure_profile(i),'Q',0,"CO2");
        Inlet_density_profile(i) = py.CoolProp.CoolProp.PropsSI('D','P',Inlet_Pressure_profile(i),'Q',0,"CO2");
        end
    end
    %% Outlet calculations
    Ideal_outlet_sp_entropy_profile = Inlet_sp_entropy_profile;
    Outlet_Pressure_profile = Inlet_Pressure_profile.*stage_pr_ratio;
    for i=1:N_compression_steps
        Ideal_outlet_sp_enthalpy_profile(i) = py.CoolProp.CoolProp.PropsSI('H','P',Outlet_Pressure_profile(i),'S',Ideal_outlet_sp_entropy_profile(i),"CO2");
    end
    Ideal_sp_work_compression_stage = Ideal_outlet_sp_enthalpy_profile - Inlet_sp_enthalpy_profile;
    Actual_sp_work_compression_stage = Ideal_sp_work_compression_stage .* Isen_efficiency^-1;
    Outlet_sp_enthalpy_profile = Inlet_sp_enthalpy_profile + Actual_sp_work_compression_stage;
    if length(Outlet_sp_enthalpy_profile) >1
        heat_rejected_intercooler = (Outlet_sp_enthalpy_profile(1:(end-1))-Inlet_sp_enthalpy_profile(2:end))*compressor_massflow;
    else
        heat_rejected_intercooler = (Outlet_sp_enthalpy_profile-Inlet_sp_enthalpy_profile)*compressor_massflow;
    end

    for i=1:N_compression_steps
        Outlet_Temperature_profile(i) = py.CoolProp.CoolProp.PropsSI('T','P',Outlet_Pressure_profile(i),'H',Outlet_sp_enthalpy_profile(i),"CO2");
        Outlet_sp_entropy_profile(i) = py.CoolProp.CoolProp.PropsSI('S','P',Outlet_Pressure_profile(i),'T',Outlet_Temperature_profile(i),"CO2");
    end

    %% feedback
    coupling_vars.mass_flow.M3 = coupling_vars.mass_flow.M2 * (1-coupling_vars.local_constants.coolant_fraction);
    coupling_vars.mass_flow.M4 = coupling_vars.mass_flow.M3;
    coupling_vars.mass_flow.M5 = coupling_vars.mass_flow.M4;
    coupling_vars.Temperature.T2 = Outlet_Temperature_profile(end);     %compressor outlet
    coupling_vars.Temperature.T3 = Outlet_Temperature_profile(end);     %heat excahnger inlet
    coupling_vars.Temperature.coolant = Outlet_Temperature_profile(end);     %coolant temperature
    coupling_vars.Pressure.coolant = Outlet_Pressure_profile(end);     %coolant pressure
    coupling_vars.sp_enthalpy.h1 = Inlet_sp_enthalpy_profile(1);     %compressor inlet
    coupling_vars.sp_enthalpy.h2 = Outlet_sp_enthalpy_profile(end);     %compressor outlet
    coupling_vars.sp_enthalpy.h3 = Outlet_sp_enthalpy_profile(end);     %heat excahnger inlet
    coupling_vars.sp_entropy.s1 = Inlet_sp_entropy_profile(1);     %compressor inlet
    coupling_vars.sp_entropy.s2 = Outlet_sp_entropy_profile(end);     %compressor outlet
    coupling_vars.sp_entropy.s3 = Outlet_sp_entropy_profile(end);     %heat excahnger inlet
    coupling_vars.performance.compressor_sp_work_profile = Actual_sp_work_compression_stage;
    coupling_vars.performance.sp_heat_rejected_intercooler= heat_rejected_intercooler;
    
end