function []=aeronet_plot_ONEILL_points(jd, val, ylab)
% large horizontal plot
set(gcf,'position',[300,300,800,300]); % units in pixels!
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 3])
% climatology on the left side
sub=subplot('position',[0.08 0.14 0.73 0.76]);
plot(jd,val,'.');
% largest val
%maxval=max(val(:,1))*1.2;
%minval=0;
yval=get(gca,'ylim'); minval=yval(1); maxval=yval(2);
ylim([minval maxval]); 
ylabel(ylab,'fontsize',12);
xlabel('Year/Month','fontsize',12);
% round scale to full years 
tmp1=datevec(min(jd)); jd1=datenum(tmp1(1),1,1,0,0,0);
tmp2=datevec(max(jd)); jd2=datenum(tmp2(1)+1,1,1,0,0,0);
xlim([jd1, jd2]);
datetick('x','yy/mm','keeplimits');
grid on; 
% histograms on right side
sub=subplot('position',[0.83 0.14 0.15 0.76]);
bins=[minval:(maxval-minval)/100:maxval];
hall=histc(val(:,1),bins);
b=barh(bins+(bins(2)-bins(1))/2,hall/sum(hall),1,'w'); 
set(b,'facecolor',[0.7 0.7 0.7]);
ylim([minval maxval]); 
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