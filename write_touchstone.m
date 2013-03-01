function write_touchstone( type, freq, data, filename, ref, comment )
% write_touchstone( type, freq, data, filename [,ref [,comment]] ) - write touchstone-file
% for ADS
% type      'z' for Z-Parameter touchstone-file
%           'y' for Y-Parameter touchstone-file
%           's' for S-Parameter touchstone-file
% freq      vector of frequencies (in Hz)
% data      (numports x numports x numfreq) matrix
% filename  filename of the file to create
% ref       (optional) reference impedance
% comment   (optional) written in the header
%
% (C) Sebastian Held <sebastian.held@gmx.de>
% Version 21. Feb 2006

if lower(type) == 'z'
    par_type = 'Z';
    if nargin < 5; ref = 1; end
elseif lower(type) == 'y'
    par_type = 'Y';
    if nargin < 5; ref = 1; end
elseif lower(type) == 's'
    par_type = 'S';
    if nargin < 5; ref = 50; end
else
    error( 'only z-, y- and s-parameters supported by now' );
end

if nargin < 6
    comment = '';
end

num_rows = size( data, 1 );
num_columns = size( data, 2 );
if num_rows ~= num_columns
    error( 'number of rows and columns do not agree' );
end

[fid, message] = fopen( filename, 'wt' );
if fid == -1
    error( message );
end

fprintf( fid, '%s\n', ['#   Hz   ' par_type '  RI   R   ' num2str(ref)] );
fprintf( fid, '%s\n', ['! ' comment] );

if size( data, 1 ) == 1 || size( data, 1 ) >= 3
    write_data_1(data, fid, freq);
elseif size( data, 1 ) == 2
    write_data_2(data, fid, freq);
else
    error( 'FIXME - unhandled dimension' );
end

fclose( fid );
return;
end %write_touchstone()

function write_data_1(data, fid, freq)
num_rows = size( data, 1 );
num_columns = size( data, 2 );
% for more than 3-port devices
for f=1:length(freq)
    fprintf( fid, '%e ', freq(f) ); %Frequenz
    for row = 1:num_rows
        column = 1;
        while column <= num_columns
            for z=1:min( 4, num_columns-column+1 ); % nur maximal 4 Parameter in einer Zeile! (ADS-Begrenzung)
                fprintf( fid, '% e % e   ', real( data(row,column,f) ), imag( data(row,column,f) ) );
                column = column + 1;
            end
            fprintf( fid, '\n             ' ); % Zeilenende
        end
    end
    fprintf( fid, '\n' );
end
end %write_data_1()

function write_data_2(data, fid, freq)
% for 2-port devices
% ADS uses different format (what a mess)
for f=1:length(freq)
    fprintf( fid, '%e   % e % e   % e % e   % e % e   % e % e\n', freq(f), ...
        real(data(1,1,f)), imag(data(1,1,f)), real(data(2,1,f)), imag(data(2,1,f)), ...
        real(data(1,2,f)), imag(data(1,2,f)), real(data(2,2,f)), imag(data(2,2,f)) ); %Frequenz
end
end %write_data_2()
