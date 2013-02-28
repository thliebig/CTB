function y = s2y(s,ref)
% y = s2y(s [,ref])
%
% Scattering to Y transformation
%
% input:
%   s:   S-matrix matrix nxnxf   (f: number of frequencies)
%   ref: (optional) reference impedance (default 50 Ohm)
%
% output:
%   y:   Y-matrix nxnxf
%
% Reference: http://qucs.sourceforge.net/tech/node98.html
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% Feb. 2013

if nargin < 2
    Z0 = 50;
else
    Z0 = ref;
end

N = size(s,1);
Nf = size(s,3);

E = eye(N);
Zref = E*Z0;
G = E/sqrt(real(Z0));

y=zeros(N,N,Nf); %preallocate

for f=1:Nf
    y(:,:,f) = G\(Zref\((s(:,:,f)+E)\(E-s(:,:,f))))*G;
end
