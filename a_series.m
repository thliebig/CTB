function a = a_series(Z)
% a = a_series(Z)
%
% create the ABCD matrix of a series impedance
%
% example:
% C = 1e-12; aka 1pF
% f = linspace(0,2e9,201);
% Z = 2j*pi*f*C;
%
% %ABCD matrix of a series capacitor
% a = a_series(Z);
%
% Reference: David M. Pozar "Microwave Engineering"
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% Feb. 2013

a(1,2,:) = Z;
a(1,1,:) = 1;
a(2,1,:) = 0;
a(2,2,:) = 1;
