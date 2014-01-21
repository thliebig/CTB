function [I_port I_orig_port] = ApplyRFPower2Port(net, port, power, varargin)
% function I_port = ApplyRFPower2Port(net, port, power, varargin)
%
%   Apply a RF power to a given port of your network
%
% arguments:
%   port:           number of ports to apply the power to
%   power:          applied power in W
%
% output:
%   I_port:         Total currents going into the ports
%
% See also: InitNetwork, SetPortTermination, AddElement2Port,
% ApplyCurrent2Port
%
% ------
% Cuicuit Toolbox (https://github.com/thliebig/CTB)
% (c) Thorsten Liebig, 2013

if (numel(port)>1)
    I_port = zeros(net.numPorts,net.numFreq);
    I_orig_port = zeros(net.numPorts,net.numFreq);
    for n=1:numel(port)
        [I_p I_op] = ApplyRFPower2Port(net, port(n), power(n), varargin{:});
        I_port = I_port + I_p;
        I_orig_port = I_orig_port + I_op;
    end
    return
end

if ((port<1) || (port>net.numPorts))
    error 'invalid port number'
end

if (numel(net.Z0)==1)
    Z0 = net.Z0*ones(net.numPorts,1);
else
    Z0 = net.Z0;
end

I_tot = sqrt(2*abs(power)/Z0(port)) * (1-squeeze(net.s(port,port,:))) * exp(1j*angle(power));

[I_port I_orig_port] = ApplyCurrent2Port(net, port, I_tot, varargin);
