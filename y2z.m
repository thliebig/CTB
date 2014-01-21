function z = y2z(y)
% z = y2z(y)
%
% Y-matrix to Z-matrix
%
% input:
%   y:   Y-matrix matrix nxnxf   (f: number of frequencies)
%
% output:
%   z:   Z-matrix nxnxf
%
% Reference: http://qucs.sourceforge.net/tech/node98.html
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% (c) 2013

Nf = size(y,3);

z = y*0; % init
for f=1:Nf
    z(:,:,f) = inv(y(:,:,f));
end
