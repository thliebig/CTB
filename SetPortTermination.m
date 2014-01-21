function net = SetPortTermination(net, port, Z0, varargin)
% function net = SetPortTermination(net, port, Z0, varargin)
%
%   Set the given port impedance/termination
%
% arguments:
%   port:   number of ports to apply the termination
%   Z0:     port impedance
%
% See also: InitNetwork, AddElement2Port, ApplyCurrent2Port,
% ApplyRFPower2Port
%
% ------
% Cuicuit Toolbox (https://github.com/thliebig/CTB)
% (c) Thorsten Liebig, 2013

if (numel(port)>1)
    if (numel(Z0)==1)
        Z0 = Z0*ones(1,size(port));
    end
    for n=1:numel(port)
        net = SetPortTermination(net, port(n), Z0(n), varargin);
    end
    return;
end

if ((port<1) || (port>net.numPorts))
    error 'invalid port number'
end

if (numel(net.Z0)==1)
    if (net.Z0==Z0)
        % nothing needs to be done
        return
    end
    net.Z0 = net.Z0*ones(1,net.numPorts);
end

if (net.Z0(port)==Z0)
    % nothing needs to be done
    return
end

net.Z0(port)=Z0;
net.s = z2s(net.z, net.Z0);
