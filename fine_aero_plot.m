function []=fine_aero_plot(jd, aot, title, xtic, xticl)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 3])
sub=subplot('position',[0.08 0.14 0.73 0.76]);
plot(jd,aot,'.');
datetick('x','yy/mm');
ylim([0 1]); 
xlabel('Years','fontsize',12)  
ylabel(title,'fontsize',12)
grid on;
sub=subplot('position',[0.83 0.14 0.15 0.76]);
bins=[0:0.025:1];
counts=histc(aot(:,1),bins);
b=barh(bins+bins(2)/2,counts/sum(counts),1,'w'); 
set(b,'facecolor',[0.7 0.7 0.7]);
ylim([0 1]); xlabel('freq');
xlim([min(xtic) max(xtic)]);
set(gca,'XTick',xtic);
set(gca,'xticklabel',xticl);
set(gca,'yticklabel','');
grid on;
%