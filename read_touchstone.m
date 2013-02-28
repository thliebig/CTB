function [type,freq,data,ref,comment]=read_touchstone( filename )
% [type,freq,data,ref]=read_touchstone( filename ) - read touchstone-file
% type      (lowercase) 'z' for Z-Parameter touchstone-file
% freq      vector of frequencies (in Hz)
% data      (numports x numports x numfreq) matrix
% filename  filename of the file to read
% ref       reference impedance
% comment   cell array of comment lines
%
% Version 16. Jun 2010
% 18. Aug 2010: comment lines
% 1. Sep 2010: BUGFIX: two-port files had S12 and S21 swapped!!!!!
% ATTENTION: higher than two-ports must be validated again!!!!!!!!!1

[fid, message] = fopen( filename, 'rt' );
if fid == -1
    error( message );
end

comment = {};

% constants
DB = 0;
MA = 1;
RI = 2;

% number of ports (extract extension)
temp = lower(filename);
k = strfind(temp,'.');
if isempty(k)
    error( 'filename has no extension' );
end
last_dot = k(length(k));
if length(temp) <= k
    error( 'filename ends with "."' );
end
extension = temp(last_dot+1:length(temp));
if (lower(extension(1)) ~= 's') && (lower(extension(length(extension))) ~= 'p')
    error( 'filename must have an extension like .s2p' );
end
num_ports = str2double(extension(2:length(extension)-1));

parameters_found = 0;
freq_nr = 1;
tline = fgetl(fid);
while ischar(tline)
    tline = strtrim(tline);
    if isempty(tline) || (tline(1) == '!')
        % comment
        if ~isempty(tline)
            comment{end+1} = tline;
        end
        tline = fgetl(fid);
        continue
    end
    if tline(1) == '#'
        % found parameters
        if parameters_found == 1
            warning( 'additional parameter line found; expect garbage!' );
        end
        parameters_found = 1;
        % parse parameters
        [~,remain] = strtok(tline); % token is now '#'
        [token,remain] = strtok(remain); % token is now the unit
        unit = lower(token);
        if strcmp(unit,'hz')
            freq_mul = 1;
        elseif strcmp(unit,'khz')
            freq_mul = 1e3;
        elseif strcmp(unit,'mhz')
            freq_mul = 1e6;
        elseif strcmp(unit,'ghz')
            freq_mul = 1e9;
        else
            error( ['wrong unit: "' token '"'] );
        end
        [token,remain] = strtok(remain); % token is now the parameter type
        type = lower(token);
        [token,remain] = strtok(remain); % token is now the complex format
        format = lower(token);
        if strcmp(format,'ri')
            format = RI;
        elseif strcmp(format,'ma')
            format = MA;
        elseif strcmp(format,'db')
            format = DB;
        else
            error( ['wrong complex format: "' format '"'] );
        end
        [token,remain] = strtok(remain); % token must be 'R'
        if lower(token) ~= 'r'
            error( 'incorrect file format' );
        end
        token = strtok(remain); % token is reference impedance
        ref = str2double(token);
        tline = fgetl(fid);
        continue
    end
    % read data
    clear 'cell_array';
    cell_array = split( tline );
    while length(cell_array) < 2*num_ports^2 + 1
        temp_tline = fgetl(fid); %FIXME comments? empty lines?
        cell_array = [cell_array,split( temp_tline )];
    end
    % now we have (at least) num_values values in cell_array
    temp_freq = str2double(cell_array(1)) * freq_mul;
    temp_data = zeros(num_ports);
    for source = 1:num_ports
        for dest = 1:num_ports
            if num_ports ~= 2
                pos = ((source-1)*num_ports + dest)*2;
            else
                % special file format for two-ports
                pos = ((source-1)*2 + dest)*2;
            end
            if format == RI
                temp_data(dest,source) = str2double(cell_array(pos)) + 1i*str2double(cell_array(pos+1));
            elseif format == MA
                temp_data(dest,source) = str2double(cell_array(pos)) * exp(1i*str2double(cell_array(pos+1))/180*pi);
                %disp( [tline '  ### freq: ' num2str(temp_freq/1e9) '  S' num2str(source) num2str(dest) '  ' num2str(temp_data(dest,source))] );
                %disp( ['pos: ' num2str(pos) '     cell_array: ' char(cell_array(pos))] );
            elseif format == DB
                temp_data(dest,source) = 10^(str2double(cell_array(pos))/20) * exp(1i*str2double(cell_array(pos+1))/180*pi);
            end
        end
    end
    % values are parsed, insert them into the freq and data arrays
    freq(freq_nr) = temp_freq;
    data(:,:,freq_nr) = temp_data;
    freq_nr = freq_nr + 1;

%    disp( ['frequency f=' num2str(temp_freq/1e9)] );
    tline = fgetl(fid);
end

fclose( fid );

end %read_touchstone()



function cell_array=split( str )
    cell_array = cell(0);
    [token,remain] = strtok(str);
    while ~isempty(token)
        cell_array = [cell_array token];
        [token,remain] = strtok(remain);
    end
end
