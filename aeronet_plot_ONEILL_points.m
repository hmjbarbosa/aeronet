function []=aeronet_plot_ONEILL_points(jd, aot, ylab)
% large horizontal plot
set(gcf,'position',[300,300,800,300]); % units in pixels!
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 3])
% climatology on the left side
sub=subplot('position',[0.08 0.14 0.73 0.76]);
plot(jd,aot,'.');
% largest aod
maxaod=max(aot(:,1))*1.2;
ylim([0 maxaod]); 
ylabel(ylab,'fontsize',12)
xlabel('Year/Month','fontsize',12)  
% round scale to full years 
tmp1=datevec(min(jd)); jd1=datenum(tmp1(1),1,1,0,0,0);
tmp2=datevec(max(jd)); jd2=datenum(tmp2(1)+1,1,1,0,0,0);
xlim([jd1, jd2]);
datetick('x','yy/mm','keeplimits');
grid on; 
% histograms on right side
sub=subplot('position',[0.83 0.14 0.15 0.76]);
bins=[0:maxaod/100:maxaod];
hall=histc(aot(:,1),bins);
b=barh(bins+bins(2)/2,hall/sum(hall),1,'w'); 
set(b,'facecolor',[0.7 0.7 0.7]);
ylim([0 maxaod]); 
xlabel('freq','fontsize',12);
tmp=get(gca,'xtick');
xtic=linspace(0, max(hall/sum(hall))*1.2, 4);
xlim([min(xtic) max(xtic)]);
xticl=' ';
for i=2:numel(xtic)
  tmp=sprintf('%4.2f',xtic(i));
  xticl=[xticl '|' tmp(2:4)];
end
set(gca,'XTick',xtic);
set(gca,'xticklabel',xticl);
set(gca,'yticklabel','');
grid on;
%