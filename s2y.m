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

y=zeros(N,N,Nf); %preallocate

for f=1:Nf
    y(:,:,f) = G\(Zref\((s(:,:,f)+E)\(E-s(:,:,f))))*G;
end
