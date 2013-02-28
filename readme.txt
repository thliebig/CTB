Circuit Toolbox for Matlab/Octave
---------------------------------

Small collection of useful functions to convert n-port network parameter
such as scattering parameter, Z- or Y-parameter.

Read/Write to touchstone file format to read with Qucs: http://qucs.sourceforge.net

---
Examples:
addpath('path/to/CTB');
% create ABCD matrix of a series C, shunt R and shunt L
f = linspace(0,1e9,201); % frequency vector
a = a_series(1./(2j*pi*f*10e-12)); % create ABCD matrix for a series capacity of 10pF
a = a_mul(a, a_shunt(1/50*ones(size(f)))); % append a 50 Ohms shunt resistance
a = a_mul(a, a_series(2j*pi*f*20e-9));    % append a 20nH series inductance
s = a2s(a); % convert to s-parameter

figure
plot(f,20*log10(squeeze(abs(s(1,1,:)))));
hold on;
grid on;
plot(f,20*log10(squeeze(abs(s(2,1,:)))),'r--');
ylim([-20 0]);
legend('s11','s21');

---
Copyright (c) 2006-2013 Sebastian Held, Thorsten Liebig.
All rights reserved.
