function s = z2s(z,ref)
% s = z2s(z [,ref])
%
% Z-matrix to scattering transformation
%
% input:
%   z:   Z-matrix matrix nxnxf   (f: number of frequencies)
%   ref: (optional) reference impedance (default 50 Ohm)
%
% output:
%   s:   S-matrix nxnxf
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

N = size(z,1);
Nf = size(z,3);

E = eye(N);
Zref = E*Z0;
G = E/sqrt(real(Z0));

s=zeros(N,N,Nf); %preallocate

for f=1:Nf
    s(:,:,f) = G*(z(:,:,f)-Zref)/(z(:,:,f)+Zref)/G;
end
