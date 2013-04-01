
figure(1); 

% ---- total
clf;
aeronet_plot_ONEILL_points(aero.jd, aero.aot_total, 'Total AOD 500nm')
out=[aero.file '_aod_total_points.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

clf;
aeronet_plot_ONEILL_box(aero.jd, aero.aot_total(:,1), 'Total AOD 500nm',...
                        [7:11], [1:6,12] )
out=[aero.file '_aod_total_box.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

% ---- fine
clf;
aeronet_plot_ONEILL_points(aero.jd, aero.aot_fine, 'Fine AOD 500nm')
out=[aero.file '_aod_fine_points.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

clf;
aeronet_plot_ONEILL_box(aero.jd, aero.aot_fine(:,1), 'Fine AOD 500nm',...
                        [7:11], [1:6,12] )
out=[aero.file '_aod_fine_box.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

% ---- coarse
clf;
aeronet_plot_ONEILL_points(aero.jd, aero.aot_coarse, 'Coarse AOD 500nm')
out=[aero.file '_aod_coarse_points.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

clf;
aeronet_plot_ONEILL_box(aero.jd, aero.aot_coarse(:,1), 'Coarse AOD 500nm',...
                        [7:11], [1:6,12] )
out=[aero.file '_aod_coarse_box.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

% ---- finefrac
clf;
aeronet_plot_ONEILL_points(aero.jd, aero.aot_finefrac, 'Finefrac AOD 500nm')
out=[aero.file '_aod_finefrac_points.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);

clf;
aeronet_plot_ONEILL_box(aero.jd, aero.aot_finefrac(:,1), 'Finefrac AOD 500nm',...
                        [7:11], [1:6,12] )
out=[aero.file '_aod_finefrac_box.png'];
print(out,'-dpng'); eval(['!mogrify -trim ' out]);


