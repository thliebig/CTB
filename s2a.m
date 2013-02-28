function a = s2a(s,ref)
% a = s2a(s [,ref])
%
% Scattering to ABCD transformation (only for 2x2xf matrices)
%
% input:
%   s:   S-matrix matrix 2x2xf   (f: number of frequencies)
%   ref: (optional) reference impedance (default 50 Ohm)
%
% output:
%   a:   ABCD 2x2xf
%
% Reference: David M. Pozar "Microwave Engineering"
%
% Sebastian Held <sebastian.held@gmx.de>
% Sep 1 2010

if nargin < 2
    Z0 = 50;
else
    Z0 = ref;
end

S11 = squeeze(s(1,1,:));
S12 = squeeze(s(1,2,:));
S21 = squeeze(s(2,1,:));
S22 = squeeze(s(2,2,:));
a(1,1,:) = ((1+S11).*(1-S22) + S12.*S21) ./ (2*S21);
a(1,2,:) = Z0 .* ((1+S11).*(1+S22) - S12.*S21) ./ (2*S21);
a(2,1,:) = 1./Z0 .* ((1-S11).*(1-S22) - S12.*S21) ./ (2*S21);
a(2,2,:) = ((1-S11).*(1+S22) + S12.*S21) ./ (2*S21);
