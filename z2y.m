function y = z2y(z)
% y = z2y(z)
%
% Z-matrix to Y-matrix
%
% input:
%   z:   Z-matrix matrix nxnxf   (f: number of frequencies)
%
% output:
%   y:   Y-matrix nxnxf
%
% Reference: http://qucs.sourceforge.net/tech/node98.html
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% (c) 2013

% y2z is just doing the invertion ...
y = y2z(z);
