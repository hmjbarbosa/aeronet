figure(1); clf
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 4])
bins=[0:0.025:1];
counts=histc(aero.aot_total(:,1),bins);
b=barh(bins+bins(2)/2,counts/sum(counts),1,'w'); 
set(b,'facecolor',[0.7 0.7 0.7]);
ylim([0 1]); xlim([0 .5]);
title('Manaus-AM/EMBRAPA','fontsize',[14]);
ylabel('Total AOD 500nm')
print('sda_hist_total.png','-dpng');
%!mogrify -trim sda_hist_total.png

figure(2); clf
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 4])
counts=histc(aero.aot_fine(:,1),bins);
b=barh(bins+bins(2)/2,counts/sum(counts),1,'w');
set(b,'facecolor',[0.7 0.7 0.7]);
ylim([0 1]); xlim([0 .5]);
title('Manaus-AM/EMBRAPA','fontsize',[14]);
ylabel('Fine AOD 500nm')
print('sda_hist_fine.png','-dpng');
%!mogrify -trim sda_hist_fine.png

figure(3); clf
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 4])
counts=histc(aero.aot_coarse(:,1),bins);
b=barh(bins+bins(2)/2,counts/sum(counts),1,'w');
set(b,'facecolor',[0.7 0.7 0.7]);
ylim([0 1]); xlim([0 .5]);
title('Manaus-AM/EMBRAPA','fontsize',[14]);
ylabel('Coarse AOD 500nm')
print('sda_hist_coarse.png','-dpng');
%!mogrify -trim sda_hist_coarse.png

figure(4); clf
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 4])
counts=histc(aero.aot_finefrac(:,1),bins);
b=barh(bins+bins(2)/2,counts/sum(counts),1,'w');
set(b,'facecolor',[0.7 0.7 0.7]);
ylim([0 1]); xlim([0 .5]);
title('Manaus-AM/EMBRAPA','fontsize',[14]);
ylabel('AOD Fine fraction')
print('sda_hist_fraction.png','-dpng');
%!mogrify -trim sda_hist_fraction.png

figure(5); clf;
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 4])
edges = 10.^(-3:0.1:0)'; 
h=histc([aero.aot_fine(:,1), aero.aot_coarse(:,1)],edges);
b=bar(edges,h,'histc');
delete(findobj('marker','*'));
xlim([edges(1), edges(end)])
set(gca,'xscale','log')                                           
legend('fine mode','coarse mode')
xlabel('AOD')
title('Manaus-AM/EMBRAPA','fontsize',[14]);
grid
print('sda_fine_hist.png','-dpng');
!mogrify -trim sda_fine_hist.png


%xd=aero.aot_fine(:,1);
%yd=aero.aot_finefrac(:,1);
%
%n=50;
%xi = linspace(min(xd(:)),max(xd(:)),n);
%yi = linspace(min(yd(:)),max(yd(:)),n);
%
%xr = interp1(xi,1:numel(xi),xd,'nearest')';
%yr = interp1(yi,1:numel(yi),yd,'nearest')';
%
%z = accumarray([xr' yr'], 1, [n, n])';
%
%figure(3)
%contourf(xi,yi,z)
%ylabel('Fine fraction')
%xlabel('AOD Fine mode')
%colorbar
