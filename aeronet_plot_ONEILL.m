% example for SDA files 

clear all
close all

% read data
fname='ExampleData/990101_021231_Balbina.ONEILL_20';
aero=aeronet_read_ONEILL(fname);

% ---- total
figure(1); clf;
aeronet_plot_ONEILL_points(aero.jd, aero.aot_total(:,1), 'Total AOD 500nm',fname)
%out=[aero.file '_aod_total_points.png']; 
%print(out,'-dpng'); eval(['!mogrify -trim ' out]);

figure(2); clf;
aeronet_plot_ONEILL_box(aero.jd, aero.aot_total(:,1), 'Total AOD 500nm',...
                        [6:8], [1:2,12],1,fname)
%out=[aero.file '_aod_total_box.png'];
%print(out,'-dpng'); eval(['!mogrify -trim ' out]);

% ---- fine
figure(3); clf;
aeronet_plot_ONEILL_points(aero.jd, aero.aot_fine(:,1), 'Fine AOD 500nm',fname)

figure(4); clf;
aeronet_plot_ONEILL_box(aero.jd, aero.aot_fine(:,1), 'Fine AOD 500nm',...
                        [6:8], [1:2,12],1,fname)

% ---- coarse
figure(5); clf;
aeronet_plot_ONEILL_points(aero.jd, aero.aot_coarse(:,1), 'Coarse AOD 500nm',fname)

figure(6); clf;
aeronet_plot_ONEILL_box(aero.jd, aero.aot_coarse(:,1), 'Coarse AOD 500nm',...
                        [6:8], [1:2,12],1,fname)

% ---- finefrac
figure(7); clf;
aeronet_plot_ONEILL_points(aero.jd, aero.aot_finefrac(:,1), 'Finefrac AOD 500nm',fname)

figure(8); clf;
aeronet_plot_ONEILL_box(aero.jd, aero.aot_finefrac(:,1), 'Finefrac AOD 500nm',...
                        [6:8], [1:2,12],1,fname)


