function []=fine_aero_box(jd, aot, title, xtic, xticl)
set(gcf,'position',[300,300,800,300]); % units in pixels!
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 8 3])
sub=subplot('position',[0.08 0.05 0.73 0.85]);
XX(1:size(aot,1),1:12)=NaN;
for i=1:size(aot,1)
  data=datevec(jd(i));
  XX(i,data(2))=aot(i,1);
end
boxplot(XX);
pos=get(gca,'position');
medi(1)=nanmean(reshape(XX,[],1));
medi(2)=nanmean(reshape(XX(:,7:11),[],1));
medi(3)=nanmean(reshape([XX(:,1:6) XX(:,12)],[],1));
desv(1)=nanstd(reshape(XX,[],1));
desv(2)=nanstd(reshape(XX(:,7:11),[],1));
desv(3)=nanstd(reshape([XX(:,1:6) XX(:,12)],[],1));
stats=['avg: ' sprintf('%4.2f',medi(1)) ' \pm ' ...
       sprintf(' %4.2f',desv(1)) char(10) ...
       'dry: ' sprintf('%4.2f',medi(2)) ' \pm ' ...
       sprintf(' %4.2f',desv(2)) char (10) ...
       'wet: ' sprintf('%4.2f',medi(3)) ' \pm ' ...
       sprintf(' %4.2f',desv(3)) ];
annotation('textbox', [pos(1), pos(2)+pos(4)-0.20, 0.15, 0.199], ...
           'string', stats, 'backgroundcolor','w')
ylim([0 1]); 
xlabel('Months','fontsize',12)  
ylabel(title,'fontsize',12)
grid on;
sub=subplot('position',[0.83 pos(2)+0.005 0.15 pos(4)-0.005]);
bins=[0:0.025:1];

%counts=histc(aot(:,1),bins);
%b=barh(bins+bins(2)/2,counts/sum(counts),1,'w'); 
dry=histc(XX(:,7:11),bins);
plot(dry/sum(dry),bins+bins(2)/2,'r-'); 
%set(b,'facecolor',[0.7 0.6 0.6]);
ylim([0 1]); xlabel('freq');
xlim([min(xtic) max(xtic)]);
set(gca,'XTick',xtic);
set(gca,'xticklabel',xticl);
set(gca,'yticklabel','');
grid on; hold on;
wet=histc([XX(:,1:6) XX(:,12)],bins);
plot(wet/sum(wet),bins+bins(2)/2,'b-'); 
%set(b,'facecolor',[0.6 0.6 0.7]);
%