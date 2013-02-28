function a = a_shunt(Y)
% a = a_shunt(Y)
%
% create the ABCD matrix of a shunt admittance
%
% example:
% C = 1e-12; aka 1pF
% f = linspace(0,2e9,201);
% Y = 1./(2j*pi*f*C);
%
% %ABCD matrix of a shunt capacitor
% a = a_shunt(Y);
%
% Reference: David M. Pozar "Microwave Engineering"
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% Feb. 2013

a(2,1,:) = Y;
a(1,2,:) = 0;
a(1,1,:) = 1;
a(2,2,:) = 1;
