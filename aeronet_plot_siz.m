% example for size distribution
% Takes all data from one station, separate by month, and plot

clear all
close all

% read data
aero=aeronet_read_siz('ExampleData/990101_021231_Balbina.siz');

% initialize a matrix to hold the data separated by month
XX(1:aero.ntimes, 1:12, 1:aero.nradius)=NaN;

for i=1:aero.ntimes
  % build a date vector (Y M D h m s)
  data(i,:)=datevec(aero.jd(i));

  % separate input data by months at the extra dimension
  % the other's will be NaN, hence nanmedian() will not see them
  XX(i,data(i,2),:)=aero.size(i,:);
end

% count number of inversions in each month 
for i=1:12 
  % number of inversions in each month
  permon(i)=sum(data(:,2)==i);

  % some output to the user
  disp(['month= ' num2str(i) ' inversions= ' num2str(permon(i))]);
end

% compute median (50%) for each month (2nd column) separately
Xm=squeeze(nanmedian(XX,1));

% compute the 25, 50 and 75 quantiles from all inversions in DJF
djf=quantile(reshape(XX(:,[1:2,12],:),[aero.ntimes*3, aero.nradius]),[.25 .5 .75],1);
% output number of djf inversions
ndjf=sum(data(:,2)<=2 | data(:,2)>=12);
disp(['djf inversions= ' num2str(ndjf) ])

% compute the 25, 50 and 75 quantiles from all inversions in JJA
jja=quantile(reshape(XX(:,  [6:8],:),[aero.ntimes*3, aero.nradius]),[.25 .5 .75],1);
% output number of jja inversions 
njja=sum(data(:,2)>=6 & data(:,2)<=8);
disp(['jja inversions= ' num2str(njja) ])

%--------------------------------------------------
% Plots
%--------------------------------------------------

% for plotting we need the log of the radius
lograd=log10(aero.radius);

%--------------------------------------------------
f1=figure(1); clf
subplot('position',[0.1 0.1 0.8 0.7])
h=imagesc([1:12],lograd,Xm');
set(h,'alphadata',~isnan(Xm'))
% color bar
cb=colorbar; caxis([0 max(Xm(:))*0.7]);
ylabel(cb,'dV(r)/dln(r) [\mum^3/\mum^2]','fontsize',12);
% y-axis (log)
set(gca,'ydir','normal')
set(gca,'ytick',[-2:2])
yvals=get(gca,'ytick');
set(gca,'yticklabel',sprintf('%g|',10.^yvals))
ylabel('Radius (r) [\mum]','fontsize',12);
% x-axis
xlabel('Months','fontsize',12);
% add upper panel
xl=get(gca,'xlim');
subplot('position',[0.1 0.81 0.707 0.12])
bar(permon); xlim(xl); set(gca,'xticklabel',[]);
ylabel('counts');

%--------------------------------------------------
f3=figure(2); clf; 
errorbar(10.^lograd,djf(2,:),djf(2,:)-djf(1,:),djf(3,:)-djf(2,:),'bo-','linewidth',2);
hold on % errorbar() does not like if you hold the plot before using
        % it for the first time.
errorbar(10.^lograd,jja(2,:),jja(2,:)-jja(1,:),jja(3,:)-jja(2,:),'ro-','linewidth',2);
legend(['djf=' num2str(ndjf)],['jja=' num2str(njja)],'Location',[0.72, 0.75, 0.1, 0.1]);
xlim([1e-2 1e2]); set(gca,'xscale','log');
xlabel('Radius (r) [\mum]','fontsize',12);
ax=get(gca,'xtick'); set(gca,'xticklabel',sprintf('%4.3g|',ax));
ylabel('dV(r)/dln(r) [\mum^3/\mum^2]','fontsize',12);

%


