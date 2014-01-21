function net = AddElement2Port(net, port, type, value, varargin)
% function net = AddElement2Port(net, port, type, value, varargin)
%
%   Add a linear network element to the given ports
%
% arguments:
%   port:   number of ports to apply the element
%   type:   type of network element:
%               'C_se' : series capacity
%               'C_sh' : shunt capacity
%               'L_se' : series inductance
%               'L_sh' : shunt inductance
%               'R_se' : series resistance
%               'R_sh' : shunt resistance
%               'Z_se' : series impedance
%               'Y_se' : shunt addmitance
%
% See also: InitNetwork, SetPortTermination, ApplyCurrent2Port,
% ApplyRFPower2Port
%
% ------
% Cuicuit Toolbox (https://github.com/thliebig/CTB)
% (c) Thorsten Liebig, 2013

if (numel(port)>1)
    if (numel(value)==1)
        value = value*ones(size(port));
    end
    for n=1:numel(port)
        net = AddElement2Port(net, port(n), type, value(n), varargin);
    end
    return;
end

if ((port<1) || (port>net.numPorts))
    error 'invalid port number'
end

if iscell(type)
    for n=1:numel(type)
        net = AddElement2Port(net, port, type{n}, value(n), varargin{:});
    end
    return
end

Y = [];
Z = [];

if (strcmpi(type, 'C_se'))
    Z = 1./(2j*pi*net.f*value);
elseif (strcmpi(type, 'C_sh'))
    Y = 2j*pi*net.f*value;
elseif (strcmpi(type, 'L_se'))
    Z = 2j*pi*net.f*value;
elseif (strcmpi(type, 'L_sh'))
    Y = 1./(2j*pi*net.f*value);
elseif (strcmpi(type, 'R_se'))
    Z = value*ones(size(net.f));
elseif (strcmpi(type, 'R_sh'))
    Y = 1/value*ones(size(net.f));
elseif (strcmpi(type, 'Z_se'))
    Z = value;
elseif (strcmpi(type, 'Y_sh'))
    Y = value;
else
    error 'unknown element type'
end

if (~isempty(Y))
    net.ABCD{port} = a_mul(net.ABCD{port}, a_shunt(Y));
    Y = reshape(Y,1,1,numel(net.f));
    net.y(port,port,:) = net.y(port,port,:) + Y(1,1,:);
    net.s = y2s(net.y, net.Z0);
    net.z = y2z(net.y);
elseif (~isempty(Z))
    net.ABCD{port} = a_mul(net.ABCD{port}, a_series(Z));
    Z = reshape(Z,1,1,numel(net.f));
    net.z(port,port,:) = net.z(port,port,:) + Z(1,1,:);
    net.s = z2s(net.z, net.Z0);
    net.y = z2y(net.z);
else
    error 'internal error'
end
