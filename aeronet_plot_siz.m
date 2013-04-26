%aero=aeronet_read_siz('merge_sujo/merge_sujo.siz'); tag='Southern Amazon';
%aero=aeronet_read_siz('merge_limpo/merge_limpo.siz'); tag='Central Amazon';
clear XX Xm Xrel wet dry
[a,b]=fastfit([1:aero.nradius],log10(aero.radius));
bin1=floor((-1.3-b)/a); % 10^-2
bin2=ceil((1.17-b)/a); % 10^2
nbin=bin2-bin1+1;
XX(1:size(aero.size,1),1:12,1:nbin)=NaN;
x1=1-bin1+1;
x2=x1+aero.nradius-1;
lograd=a*([1:nbin]-x1+1)+b;
for i=1:size(aero.size,1)
  data(i,:)=datevec(aero.jd(i));
  XX(i,data(i,2),x1:x2)=aero.size(i,:);
end
Xm=squeeze(nanmedian(XX,1));
for i=1:12 
  permon(i)=sum(data(:,2)==i);
  Xrel(i,:)=Xm(i,:)./max(Xm(i,:));
  disp(['month= ' num2str(i) ' inversions= ' num2str(permon(i))]);
end
nt=size(XX,1);
wet=quantile(reshape(XX(:,[1:6,12],:),[nt*7, nbin]),[.25 .5 .75],1);
nwet=sum(data(:,2)<=6 | data(:,2)>=12);
disp(['wet inversions= ' num2str(nwet)]);
dry=quantile(reshape(XX(:,  [7:11],:),[nt*5, nbin]),[.25 .5 .75],1);
ndry=sum(data(:,2)>=7 & data(:,2)<=11);
disp(['dry inversions= ' num2str(ndry)]);


%--------------------------------------------------
f1=figure(1); clf
cmax=max(max(Xm))*0.7;
gplot2(Xm',[0:cmax/100:cmax],[1:12],lograd);
set(gca,'ytick',[-2:2],'TickLength',[0.05 0.5],'yminortick','on')
ax=get(gca,'ytick');
set(gca,'yticklabel',sprintf('%g|',10.^ax))
xlabel('Months','fontsize',12);
ylabel('Radius (r) [\mum]','fontsize',12);
h=get(f1,'children');
ylabel(h(1),'dV(r)/dln(r) [\mum^3/\mum^2]','fontsize',12);
title(tag,'fontsize',14);
out=['size_2d_' strrep(tag,' ','_') '.png'];
print(out,'-dpng'); 

%--------------------------------------------------
f2=figure(2); clf
cmax=1;
gplot2(Xrel',[0:cmax/100:cmax],[1:12],lograd);
set(gca,'ytick',[-2:2])
ax=get(gca,'ytick');
set(gca,'yticklabel',sprintf('%g|',10.^ax))
xlabel('Months','fontsize',12);
ylabel('Radius (r) [\mum]','fontsize',12);
h=get(f2,'children');
ylabel(h(1),'Normalized dV(r)/dln(r) [a.u.]','fontsize',12);
title(tag,'fontsize',14);
out=['size_2drel_' strrep(tag,' ','_') '.png'];
print(out,'-dpng'); 

%--------------------------------------------------
f3=figure(3); clf
errorbar(10.^lograd,wet(2,:),wet(2,:)-wet(1,:),wet(3,:)-wet(2,:),'bo-','linewidth',2); hold on;
errorbar(10.^lograd,dry(2,:),dry(2,:)-dry(1,:),dry(3,:)-dry(2,:),'ro-','linewidth',2); hold on;
h=legend(['wet=' num2str(nwet)],['dry=' num2str(ndry)],'Location',[0.72, 0.75, 0.1, 0.1]);
v=get(h,'title');
set(v,'string',tag,'fontsize',12);
xlim([1e-2 1e2]); set(gca,'xscale','log');
xlabel('Radius (r) [\mum]','fontsize',12);
ax=get(gca,'xtick'); set(gca,'xticklabel',sprintf('%4.3g|',ax));
ylabel('dV(r)/dln(r) [\mum^3/\mum^2]','fontsize',12);
out=['size_1d_' strrep(tag,' ','_') '.png'];
print(out,'-dpng'); 

%


