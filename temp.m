clf;
plot(10.^lograd, Xm( 1,:),'b-'); hold on;
plot(10.^lograd, Xm( 2,:),'b-')                            
plot(10.^lograd, Xm( 3,:),'b-')                            
plot(10.^lograd, Xm( 4,:),'b-')                            
plot(10.^lograd, Xm( 5,:),'b-')                            
plot(10.^lograd, Xm( 6,:),'b-')                            
plot(10.^lograd, Xm(12,:),'b-')
plot(10.^lograd, nanmean(Xm([1:6,12])),'b-','linewidth',2) 
plot(10.^lograd, nanmean(Xm([1:6,12],:)),'b-','linewidth',2)
xlim([1e-2 1e2]); set(gca,'xscale','log')

plot(10.^lograd, Xm( 7,:),'r-'); hold on;
plot(10.^lograd, Xm( 8,:),'r-')                            
plot(10.^lograd, Xm( 9,:),'r-')                            
plot(10.^lograd, Xm(10,:),'r-')                            
plot(10.^lograd, Xm(11,:),'r-')                            
plot(10.^lograd, nanmean(Xm([1:7])),'r-','linewidth',2) 
plot(10.^lograd, nanmean(Xm([1:7],:)),'r-','linewidth',2)
