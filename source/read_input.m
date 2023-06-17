filename = 'input.dat';
fid = fopen(filename, 'r');

data = [];  % store the data here

while ~feof(fid)
    line = fgetl(fid);
    
    % Extract the value part of the line using regular expressions
    value_str = regexprep(line, '\s*%.*', '');  % Remove spaces and everything after '%'
    
    % Process the value part of the line as data
    value = str2double(value_str);  % convert to numeric if needed
    
    if ~isnan(value)  % check if the value is valid
        % Append the data to the storage variable
        data = [data; value];
    end
end

fclose(fid);

% Perform further analysis or operations with the data
% ...
