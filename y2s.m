function s = y2s(y,ref)
% s = y2s(y [,ref])
%
% Y-matrix to scattering transformation
%
% input:
%   y:   Y-matrix matrix nxnxf   (f: number of frequencies)
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

N = size(y,1);
Nf = size(y,3);

if (numel(Z0)==1)
    Z0 = Z0*ones(N,1);
end

E = eye(N);
Zref = zeros(N,N);
G = Zref;
for n=1:N
    Zref(n,n) = Z0(n);
    G(n,n) = 1/sqrt(real(Z0(n)));
end

s=zeros(N,N,Nf); %preallocate

for f=1:Nf
    s(:,:,f) = G*((E-Zref*y(:,:,f))/(E+Zref*y(:,:,f)))/G;
end
