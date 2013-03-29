clear jd1 days hh good period
% start counting from
jd1=datenum(2011,1,1,0,0,0);
%days=aero.jd-jd1+1;
days=aero.jd;
idays=[floor(min(days)):floor(max(days))+1];

% number of measurements in each day
%hh=histc(days,[1:floor(max(days))+1]);
hh=histc(days,idays);
figure(1); 
subplot(2,1,1);
plot(idays,hh); ylabel('meas. per day'); 
datetick('x','yy/mm')

% days with a minimum number of measurements in
mperd=6;
disp(['Measurements per day= ' num2str(mperd)]);
good=hh>=mperd;

% cound sequency of good days
period(1)=0;
for i=2:size(good,1)
  if good(i)
    period(i)=period(i-1)+1;
  else
    if period(i-1)>=4
      disp(['Days: ' num2str(period(i-1)) ' start: ' ...
            datestr(jd1+i-1-1-period(i-1)) ' end: ' datestr(jd1+i-1-1)]);
    end
    period(i)=0;
  end
end

subplot(2,1,2);
plot(idays,period); ylabel(['Acc. days with meas. => ' num2str(mperd)]); 
datetick('x','yy/mm')

print('count_aero.png','-dpng')
%

