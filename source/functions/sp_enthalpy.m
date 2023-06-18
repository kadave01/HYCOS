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
            %             display(causeException.message)
            h = h + mass_fraction(i)*py.CoolProp.CoolProp.PropsSI('H','P',Pressure*mol_fraction(i),'Q',1,species(i));
        end
    end
end
end