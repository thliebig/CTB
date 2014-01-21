function net = InitNetwork(freq, s_para, varargin)
% function net = InitNetwork(freq, s_para, varargin)
%
%   Init a new network with a given frequncy vector and scattering parameter set
%
% arguments:
%   freq:   frequncy vector
%   s_para: scattering parameter
%
% example:
%   % read some touchstone s-parameter file
%   [type,freq,data,ref]=read_touchstone('test.s3p');
%
%   % init network
%   net = InitNetwork(freq, data);
%   % attach a series capacity to port 2
%   net = AddElement2Port(net, 2, 'C_se', 1e-12);
%   % terminate all ports with 50 Ohms
%   net = AddElement2Port(net, 1:3, 'R_se', 50);
%   % apply 1mW to port 1 and get port currents
%   I_tot = ApplyRFPower2Port(net, 1, 1e-3);
%
% See also AddElement2Port, ApplyCurrent2Port, ApplyRFPower2Port,
%          read_touchstone, write_touchstone
%
% ------
% Cuicuit Toolbox (https://github.com/thliebig/CTB)
% (c) Thorsten Liebig, 2013

net.Z0 = 50;
net.numFreq = numel(freq);
net.numPorts = size(s_para, 1);
net.f = freq;
net.s = s_para;
net.orig.s = s_para;
net.z = s2z(net.s, net.Z0);
net.y = s2y(net.s, net.Z0);

ABCD(1,1,1:net.numFreq) = 1;
ABCD(2,2,:) = 1;

% networks attached to each port
for n=1:net.numPorts
    net.ABCD{n} = ABCD;
end

if (size(s_para, 1) ~= size(s_para, 2))
    error 'n unequal m'
end

if (size(s_para, 3) ~= net.numFreq)
    error 'number of frequencies do not match'
end
