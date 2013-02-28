function s = a2s(a,ref)
% s = a2s(a [,ref])
%
% ABCD to Scattering Matrix transformation (only for 2x2xf matrices)
%
% input:
%   a:   ABCD matrix 2x2xf   (f: number of frequencies)
%   ref: (optional) reference impedance (default 50 Ohm)
%
% output:
%   s:   S-matrix 2x2xf normalized to ref Ohm
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

A = squeeze(a(1,1,:));
B = squeeze(a(1,2,:));
C = squeeze(a(2,1,:));
D = squeeze(a(2,2,:));
s(1,1,:) = (A + B./Z0 - C.*Z0 - D) ./ (A + B./Z0 + C.*Z0 + D);
s(1,2,:) = 2*(A.*D - B.*C) ./ (A + B./Z0 + C.*Z0 + D);
s(2,1,:) = 2 ./ (A + B./Z0 + C.*Z0 + D);
s(2,2,:) = (-A + B./Z0 - C.*Z0 + D) ./ (A + B./Z0 + C.*Z0 + D);
