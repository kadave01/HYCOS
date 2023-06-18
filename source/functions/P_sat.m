function [P_sat] = P_sat(Mixture_temperature,species)
if Mixture_temperature > py.CoolProp.CoolProp.PropsSI("Tcrit",species)
    display("Input error: Temperature provided larger than Critical Point temperature");
else
    try
        P_sat = py.CoolProp.CoolProp.PropsSI('P','T',Mixture_temperature,'Q',0,species);
    catch ME
        if (strcmp(ME.identifier,'MATLAB:Python:PyException'))
            msg = strjoin(["Error encounterd. \nIVerify inputs."]);
            causeException = MException('MATLAB:myCode:dimensions',msg);
            ME = addCause(ME,causeException);
        end
        display(causeException.message);
    end
end
