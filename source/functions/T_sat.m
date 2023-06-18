function [T_sat] = T_sat(Mixture_Pressure,species,mol_fraction)
if mol_fraction == 0
    display("Input error");
else
    try
        T_sat = py.CoolProp.CoolProp.PropsSI('T','P',Mixture_Pressure*mol_fraction,'Q',0,species);
    catch ME
        if (strcmp(ME.identifier,'MATLAB:Python:PyException'))
            msg = strjoin(["Error encounterd. \nIt is possible that the defined mixture component is in supercritical phase."]);
            causeException = MException('MATLAB:myCode:dimensions',msg);
            ME = addCause(ME,causeException);
        end
        display(causeException.message);
    end
end
