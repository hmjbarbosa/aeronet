% Function
%    function [aero] = aeronet_read_ONEILL(fname)
%
% Input:
%    fname - string with full path and file name.
%
% Output:
%    aero - a Matlab object with all info from input file.
%
% Header (5 lines): 
%
%    Level 2.0 Quality Assured Data. The following AERONET-SDA data are ...
%        derived from AOD data which are pre and post-field calibrated ...
%        and manually inspected.
%    
%    SDA Version 4.1 (tauf_tauc),Note: the labels in square brackets that ...
%        follow some of the parameter (column) names are the symbols ...
%        associated with these parameters in the original SDA publication ...
%        of O'Neill et al. (2003)
%    
%    Location=Ji_Parana,Latitude=-10.860000,Longitude=-61.799999, ...
%             Elevation[m]=100.000000,PI=Brent Holben,Email=brent@ ...
%             aeronet.gsfc.nasa.gov
%    
%    SDA from Level 2.0 AOD,All Points,UNITS can be found at,,, ...
%        http://aeronet.gsfc.nasa.gov/data_menu.html
%    
%    Date(dd:mm:yyyy),Time(hh:mm:ss),Julian_Day,Total_AOD_500nm[tau_a], ...
%        Fine_Mode_AOD_500nm[tau_f],Coarse_Mode_AOD_500nm[tau_c], ...
%        FineModeFraction_500nm[eta],2nd_Order_Reg_Fit_Error- ...
%        Total_AOD_500nm[regression_dtau_a], ...
%        RMSE_Fine_Mode_AOD_500nm[Dtau_f], ...
%        RMSE_Coarse_Mode_AOD_500nm[Dtau_c], ...
%        RMSE_FineModeFraction_500nm[Deta],Angstrom_Exponent(AE)- ...
%        Total_500nm[alpha],dAE/dln(wavelength)-Total_500nm[alphap],AE- ...
%        Fine_Mode_500nm[alpha_f],dAE/dln(wavelength)- ...
%        Fine_Mode_500nm[alphap_f],Solar_Zenith_Angle,Air_Mass, ...
%        870nm_Input_AOD,675nm_Input_AOD,667nm_Input_AOD, ...
%        555nm_Input_AOD,551nm_Input_AOD,532nm_Input_AOD, ...
%        531nm_Input_AOD,500nm_Input_AOD,490nm_Input_AOD, ...
%        443nm_Input_AOD,440nm_Input_AOD,412nm_Input_AOD, ...
%        380nm_Input_AOD,Last_Processing_Date,Number_of_Wavelengths, ...
%        Exact_Wavelengths_for_Input_AOD
%
function [aero] = aeronet_read_ONEILL(fname)
tic
fid=fopen(fname,'r');

[aero.path, aero.file, aero.ext]=fileparts(fname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ HEADER 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:5
  head{i}=fgetl(fid);
end

% level from line 1
C=textscan(head{1},'%s %*[^\n]','delimiter','<p>');
aero.level=C{1}{1};

% version from line 2
C=textscan(head{2},'%s %*[^\n]','delimiter',',');
aero.version=C{1}{1};

% Location from line 3
C=textscan(head{3},['Location=%s Latitude=%f Longitude=%f Elevation[m]=%f ' ...
		    'PI=%s Email=%s'],'delimiter',',');
aero.location=C{1}{1};
aero.lat=C{2};
aero.long=C{3};
aero.elev=C{4};
aero.PI=C{5}{1};
aero.email=C{6}{1};

% Wavelengths from line 5
C=textscan(head{5},'%s','delimiter',',');
aero.ncols=size(C{1},1);
aero.nwlen=0;
for i=1:size(C{1},1)
  word=C{1}{i};
  if (length(word)>8 & word(end-8:end) == 'Input_AOD')
    tmp=sscanf(word,'%dnm_Input_AOD');
    if (~isempty(tmp))
      aero.nwlen=aero.nwlen+1;
      aero.wlen(aero.nwlen)=tmp;
      aero.anywlen(aero.nwlen)=0;
      aero.allwlen(aero.nwlen)=0;
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i=0;
while ~feof(fid);
  i=i+1;
  % read just one line, and remove characters
  arow=strrep(fgetl(fid),'N/A','NaN');
  arow=strrep(arow,'/','');
  arow=strrep(arow,':','');
  arow=strrep(arow,'-999.','NaN');

  % read line as float
  tmp=textscan(arow,'%f','delimiter',',');
  if (i==1)
    M(i,1:aero.ncols)=NaN;
  else
    M(i,:)=NaN;
  end
  M(i,1:size(tmp{1},1))=tmp{1};  
end
aero.ntimes=i;
fclose(fid);
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CONVERTO DO MATLAB DATA TYPE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

jini=1;
for i=1:aero.ntimes
  % Date and Time
  aero.jd(i,1)=datenum(sprintf('%08d %06d',M(i,jini),M(i,jini+1)),...
		     'ddmmyyyy HHMMSS');
end

jini=jini+2;
% Day of year
jini=jini+1;
% Total AOD 500nm
aero.aot_total(:,1)=M(:,jini);
jini=jini+1;
% Fine AOD 500nm
aero.aot_fine(:,1)=M(:,jini);
jini=jini+1;
% coarse AOD 500nm
aero.aot_coarse(:,1)=M(:,jini);
jini=jini+1;
% fine fraction AOD 500nm
aero.aot_finefrac(:,1)=M(:,jini);
jini=jini+1;

% Total AOD 500nm ERR
aero.aot_total(:,2)=M(:,jini);
jini=jini+1;
% Fine AOD 500nm ERR
aero.aot_fine(:,2)=M(:,jini);
jini=jini+1;
% coarse AOD 500nm ERR
aero.aot_coarse(:,2)=M(:,jini);
jini=jini+1;
% fine fraction AOD ERR
aero.aot_finefrac(:,2)=M(:,jini);
jini=jini+1;

% total angstrom 500nm
aero.totang(:,1)=M(:,jini);
jini=jini+1;
% derivative of total angstrom
aero.derivtotang(:,1)=M(:,jini);
jini=jini+1;

% fine angstrom 500nm
aero.fineang(:,1)=M(:,jini);
jini=jini+1;
% derivative of fine angstrom
aero.derivfineang(:,1)=M(:,jini);
jini=jini+1;

% solar zenith angle
aero.sza(:,1)=M(:,jini);
jini=jini+1;

% air mass
aero.mass(:,1)=M(:,jini);
jini=jini+1;

% air mass
aero.mass(:,1)=M(:,jini);
jini=jini+1;

% input AOD
aero.inputaod(:,1:aero.nwlen)=M(:,jini:jini+aero.nwlen-1);
jini=jini+aero.nwlen;
 
% processing date
jini=jini+1;

% number of used wavelengths
aero.usedwlen(:,1)=floor(M(:,jini));
jini=jini+1;

for i=1:aero.ntimes
  % exact wlen
  aero.exact_wlen(i,:)=M(i,jini:jini+aero.usedwlen(i)-1);
  jini=jini+1;
end
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VERIFY WAVELENGTHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:aero.nwlen
  % in at least 1 measurment
  if any(~isnan(aero.inputaod(:,i)))
    aero.anywlen(i)=1;
  end
  % in all measurements
  if ~any(isnan(aero.inputaod(:,i)))
    aero.allwlen(i)=1;
  end

end
% set 
toc
%