function a = a_mul(varargin)
% a = a_mul(varargin)
%
% multiply a number of ABCD matricies
%
% example:
%
% a = a_mul(a1,a2); which is a = a1 * a2;
%
% a = a_mul(a1,a2,a3,a4); which is a = a1 * a2 * a3 * a4;
%
% Reference: David M. Pozar "Microwave Engineering"
%
% Thorsten Liebig <thorsten.liebig@gmx.de>
% Feb. 2013

if nargin<1
    error 'no argument is given'
end

a = varargin{1};

for n=2:numel(varargin)
    a2 = varargin{n};
    for f=1:size(a,3)
        a(:,:,f) = a(:,:,f)*a2(:,:,f);
    end
end
