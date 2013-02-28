function a = a_T(Z1,Z2,Z3)
% a = a_T(Z1,Z2,Z3)
%
% calculate the ABCD matrix from a T-circuit
%
% Reference: David M. Pozar "Microwave Engineering"
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% Feb. 2013

a(1,1,:) = 1+Z1./Z2;
a(1,2,:) = Z1+Z2+Z1.*Z2./Z3;
a(2,1,:) = 1./Z3;
a(2,2,:) = 1+Z2./Z3;
