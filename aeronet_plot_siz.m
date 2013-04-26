clear all
addpath('../RMlicelUSP/matlab')
addpath('../RMlicelUSP/sc')
%aero=aeronet_read_siz('merge_sujo/merge_sujo.siz'); tag='Southern Amazon';
aero=aeronet_read_siz('merge_limpo/merge_limpo.siz'); tag='Central Amazon';
clear XX Xm Xrel wet dry fake jdfake
[a,b]=fastfit([1:aero.nradius],log10(aero.radius));
bin1=floor((-1.3-b)/a); % 10^-2
bin2=ceil((1.17-b)/a); % 10^2
nbin=bin2-bin1+1;
XX(1:size(aero.size,1),1:12,1:nbin)=NaN;
x1=1-bin1+1;
x2=x1+aero.nradius-1;
lograd=a*([1:nbin]-x1+1)+b;
for i=1:size(aero.size,1)
  % build a date vector
  data(i,:)=datevec(aero.jd(i));
  % separete input data by months
  XX(i,data(i,2),x1:x2)=aero.size(i,:);
  % calculate a fake date, with year=2000 except for december, that we
  % set to 1999. Then compute the julian date. The average julian date
  % of months 7-11 or 1-6,12 will give the daynumber of the dry/wet
  % inversions.
  fake=data(i,:);
  if (fake(2)~=12)
    fake(1)=2000;
  else
    fake(1)=1999;
  end
  jdfake(i)=datenum(fake);
end
% compute median (50%) for each month (column) separately
Xm=squeeze(nanmedian(XX,1));
for i=1:12 
  % number of inversions in each month
  permon(i)=sum(data(:,2)==i);
  % normalized size distribuition (monthly max = 1) in each month
  Xrel(i,:)=Xm(i,:)./max(Xm(i,:));
  % some output to the user
  disp(['month= ' num2str(i) ' inversions= ' num2str(permon(i))]);
end
nt=size(XX,1);

% compute the 25, 50 and 75 quantiles from all inversions in WET
wet=quantile(reshape(XX(:,[1:6,12],:),[nt*7, nbin]),[.25 .5 .75],1);
% output number of wet inversions
nwet=sum(data(:,2)<=6 | data(:,2)>=12);
wetday=median(jdfake(data(:,2)<=6 | data(:,2)==12))-datenum([2000 1 1 0 0 0]);
disp(['wet inversions= ' num2str(nwet) '  day-of-year=' num2str(wetday)]);
datevec(wetday+datenum([2000 1 1 0 0 0]))

% compute the 25, 50 and 75 quantiles from all inversions in DRY
dry=quantile(reshape(XX(:,  [7:11],:),[nt*5, nbin]),[.25 .5 .75],1);
% output number of wet inversions and median day-of-year
ndry=sum(data(:,2)>=7 & data(:,2)<=11);
dryday=median(jdfake(data(:,2)>=7 & data(:,2)<=11))-datenum([2000 1 1 0 0 0]);
disp(['dry inversions= ' num2str(ndry) '  day-of-year=' num2str(dryday)]);
datevec(dryday+datenum([2000 1 1 0 0 0]))

%--------------------------------------------------
f1=figure(1); clf
subplot('position',[0.1 0.1 0.8 0.7])
cmax=max(max(Xm))*0.7;
gplot2(Xm',[0:cmax/100:cmax],[1:12],lograd);
%set(gca,'ytick',[-2:2],'TickLength',[0.05 0.5],'yminortick','on')
set(gca,'ytick',[-2:2])
ax=get(gca,'ytick');
set(gca,'yticklabel',sprintf('%g|',10.^ax))
xlabel('Months','fontsize',12);
ylabel('Radius (r) [\mum]','fontsize',12);
h=get(f1,'children');
ylabel(h(1),'dV(r)/dln(r) [\mum^3/\mum^2]','fontsize',12);
pos=get(gca,'position'); pos(2)=pos(2)+pos(4)+0.01; pos(4)=0.12;
xl=get(gca,'xlim');
subplot('position',pos)
bar(permon); xlim(xl); set(gca,'xticklabel',[]);
ylabel('# inversions');
title(tag,'fontsize',14);
%legend(tag,'Location','NorthWest')
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


