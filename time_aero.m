% start counting from
jd1=datenum(2011,1,1,0,0,0);
% create a vector with fractional year from start date
time=2011+(aero.jd-jd1)/365.25;
% for boxplot, group data into 15day intervals
groupday=15;
% create a vector with the corresponding groups
list=floor((aero.jd-jd1)/groupday)+1;
nlist=list(size(list,1));
xlist=2011+((1:nlist)-0.5)*groupday/365.25;

%% AOD em 500nm
X(1:aero.ntimes,1:nlist)=NaN;
for i=1:nlist
  for j=1:aero.ntimes
    if list(j)==i
      X(j,i)=aero.aot(j,10);
    end
  end
end

figure(1)
boxplot(X); nn=8;
C=get(gca,'xlim');
set(gca,'xtick',[C(1):(C(2)-C(1))/nn:C(2)],'xticklabel',...
	sprintf('%0.1f|',[xlist(1):(xlist(nlist)-xlist(1))/nn:xlist(nlist)]));
title('Manaus-AM/EMBRAPA','fontsize',[14]);
xlabel('Years','fontsize',[12])  
ylabel('AOT 500nm','fontsize',[12])
grid on;
print('timebox_aero_aot.png','-dpng');

figure(2)
plot(time,aero.aot(:,10),'o');
title('Manaus-AM/EMBRAPA','fontsize',[14]);
xlabel('Years','fontsize',[12])  
ylabel('AOT 500nm','fontsize',[12])
grid on;
print('time_aero_aot.png','-dpng');


%% AOD em 500nm
X(1:aero.ntimes,1:nlist)=NaN;
for i=1:nlist
  for j=1:aero.ntimes
    if list(j)==i
      X(j,i)=aero.angstrom(j,3);
    end
  end
end

figure(3)
boxplot(X); nn=8;
C=get(gca,'xlim');
set(gca,'xtick',[C(1):(C(2)-C(1))/nn:C(2)],'xticklabel',...
	sprintf('%0.1f|',[xlist(1):(xlist(nlist)-xlist(1))/nn:xlist(nlist)]));
title('Manaus-AM/EMBRAPA','fontsize',[14]);
xlabel('Years','fontsize',[12])  
ylabel('Angstrom 440-675nm','fontsize',[12])
grid on;
print('timebox_aero_angstrom.png','-dpng');

figure(4)
plot(time,aero.angstrom(:,3),'o');
title('Manaus-AM/EMBRAPA','fontsize',[14]);
xlabel('Years','fontsize',[12])  
ylabel('Angstrom 440-675nm','fontsize',[12])
grid on;
print('time_aero_angstrom.png','-dpng');
