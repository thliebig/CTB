function s_new = s_renorm(s, Z, Z_new)
% s_new = s_renorm(s, Z, Z_new)
%
% scattering matrix renormalization
%
% input:
%   s:      scattering matrix nxnxf   (f: number of frequencies)
%   Z:      old reference impedance
%   Z_new:  new reference impedance
%
% output:
%   s:      renormalized scattering-matrix nxnxf
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% (c) Jan. 2014

z = s2z(s, Z);
s_new = z2s(z, Z_new);

