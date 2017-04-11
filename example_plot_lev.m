% example for standard files (lev)

clear all
close all

% read data
fname='ExampleData/990101_021231_Balbina.lev20';
aero=aeronet_read_lev(fname);

figure(1); 

% exclude lines where any angstrom is negative
mask=~any(aero.angstrom'<0)';
% exclude lines where water vapor > 6cm
mask=mask&(aero.water(:,1)<6);

% ---- angstrom
figure(1); clf;
aeronet_plot_points(aero.jd(mask), aero.angstrom(mask,3), 'Angstrom 440-675nm',fname)

figure(2); clf;
aeronet_plot_box(aero.jd(mask), aero.angstrom(mask,3), 'Angstrom 440-675nm',...
                        [6:8], [1:2,12], 0, fname)

% ---- water
figure(3); clf;
aeronet_plot_points(aero.jd(mask), aero.water(mask,1), 'Water (cm)', fname)

figure(4); clf;
aeronet_plot_box(aero.jd(mask), aero.water(mask,1), 'Water (cm)',...
                        [6:8], [1:2,12], 0 , fname)
%



