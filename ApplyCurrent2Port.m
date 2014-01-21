function [I_port I_orig_port] = ApplyCurrent2Port(net, port, current, varargin)
% function I_port = ApplyCurrent2Port(net, port, current, varargin)
%
%   Apply a total current to a given port of your network
%
% arguments:
%   port:           number of ports to apply the power to
%   current:        applied total current
%
% output:
%   I_port:         Total currents going into the ports
%
% See also: InitNetwork, SetPortTermination, AddElement2Port,
% ApplyRFPower2Port
%
% ------
% Cuicuit Toolbox (https://github.com/thliebig/CTB)
% (c) Thorsten Liebig, 2013

if (numel(port)>1)
    I_port = zeros(net.numPorts,net.numFreq);
    I_orig_port = zeros(net.numPorts,net.numFreq);
    for n=1:numel(port)
        [I_p I_op] = ApplyCurrent2Port(net, port(n), current(n), varargin{:});
        I_port = I_port + I_p;
        I_orig_port = I_orig_port + I_op;
    end
    return
end

if ((port<1) || (port>net.numPorts))
    error 'invalid port number'
end

if (numel(current)==1)
    current = current*ones(size(net.f))
end

if (numel(net.Z0)==1)
    Z0 = net.Z0*ones(net.numPorts,1);
else
    Z0 = net.Z0;
end

z_term = net.z;
for n=1:net.numPorts
    z_term(n,n,:) = z_term(n,n,:) + Z0(n);
end

z_mat = z_term;
z_mat(port,:,:) = [];
z_mat(:,port,:) = [];

port_other = 1:net.numPorts;
port_other(port) = [];

I_port(port,:) = current;

for fn = 1:numel(net.f)
    z_port_vec = -1*squeeze(z_term(port_other,port,fn));
    I_port(port_other,fn) = squeeze(z_mat(:,:,fn))\z_port_vec * current(fn);
end

I_orig_port=I_port*0;
for n=1:net.numPorts
    C = reshape(net.ABCD{n}(2,1,:),1,numel(net.f));
    D = reshape(net.ABCD{n}(2,2,:),1,numel(net.f));
    I_orig_port(n,:) = (Z0(n)*C + D) .* I_port(n,:);
end
