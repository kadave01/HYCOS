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
function [s] = sp_entropy (Pressure,Temperature,species,mass_fraction,mol_fraction)
n = length(species);
s = 0;
for i = 1:n
    if mass_fraction(i) == 0
        continue
    else
        try
            s = s + mass_fraction(i)*py.CoolProp.CoolProp.PropsSI('S','P',Pressure*mol_fraction(i),'T',Temperature,species(i));
        catch ME
            if (strcmp(ME.identifier,'MATLAB:Python:PyException'))
                msg = strjoin(["Error caused by proximity to saturation line of",species(n),". \nIt is possible that the defined mixture exists in 2 phases." ...
                    "\nThe retunred value of s_mix is calcualted assuming only the gaseous fraction"]);
                causeException = MException('MATLAB:myCode:dimensions',msg);
                ME = addCause(ME,causeException);
            end
%             display(causeException.message)
            s = s + mass_fraction(i)*py.CoolProp.CoolProp.PropsSI('S','P',Pressure*mol_fraction(i),'Q',1,species(i));
        end
    end
end
