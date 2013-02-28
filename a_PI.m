function a = a_PI(Y1,Y2,Y3)
% a = a_PI(Y1,Y2,Y3)
%
% calculate the ABCD matrix from a PI-circuit
%
% Reference: David M. Pozar "Microwave Engineering"
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% Feb. 2013


a(1,1,:) = 1+Y2./Y3;
a(1,2,:) = 1./Y3;
a(2,1,:) = Y1+Y2+Y1.Y2./Y3;
a(2,2,:) = 1+Y1./Y3;
