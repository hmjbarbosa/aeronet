% Function
%    function [aero] = aeronet_read_tot(fname)
%
% Input:
%    fname - string with full path and file name.
%
% Output:
%    aero - a Matlab object with all info from input file.
%
% Header (6 lines): 
%    
%    Level 2.0. Quality Assured Data.<p>The following data are pre and ...
%        post field calibrated, automatically cloud cleared and manually inspected.
%    
%    Version 2 Direct Sun Algorithm
%    
%    ,PI=Brent Holben,Email=brent@aeronet.gsfc.nasa.gov
%    
%    Total Optical Depth Level 2.0,All Points,UNITS can be found at,,, ...
%        http://aeronet.gsfc.nasa.gov/data_menu.html
%    
%    Location=Ji_Parana,long=-61.800,lat=-10.860,elev=100,Nmeas=7,PI= ...
%             Brent_Holben,Email=Brent.N.Holben@nasa.gov
%    
%    Date(dd-mm-yy),Time(hh:mm:ss),Julian_Day,AOT_1640-Total,AOT_1640- ...
%        AOT,AOT_1640-Rayleigh,AOT_1640-O3,AOT_1640-NO2,AOT_1640-CO2, ...
%        AOT_1640-CH4,AOT_1640-Water,AOT_1020-Total,AOT_1020-AOT, ...
%        AOT_1020-Rayleigh,AOT_1020-O3,AOT_1020-NO2,AOT_1020-CO2, ...
%        AOT_1020-CH4,AOT_1020-Water,AOT_870-Total,AOT_870-AOT,AOT_870- ...
%        Rayleigh,AOT_870-O3,AOT_870-NO2,AOT_870-CO2,AOT_870-CH4, ...
%        AOT_870-Water,AOT_675-Total,AOT_675-AOT,AOT_675-Rayleigh, ...
%        AOT_675-O3,AOT_675-NO2,AOT_675-CO2,AOT_675-CH4,AOT_675-Water, ...
%        AOT_667-Total,AOT_667-AOT,AOT_667-Rayleigh,AOT_667-O3,AOT_667- ...
%        NO2,AOT_667-CO2,AOT_667-CH4,AOT_667-Water,AOT_555-Total, ...
%        AOT_555-AOT,AOT_555-Rayleigh,AOT_555-O3,AOT_555-NO2,AOT_555- ...
%        CO2,AOT_555-CH4,AOT_555-Water,AOT_551-Total,AOT_551-AOT, ...
%        AOT_551-Rayleigh,AOT_551-O3,AOT_551-NO2,AOT_551-CO2,AOT_551- ...
%        CH4,AOT_551-Water,AOT_532-Total,AOT_532-AOT,AOT_532-Rayleigh, ...
%        AOT_532-O3,AOT_532-NO2,AOT_532-CO2,AOT_532-CH4,AOT_532-Water, ...
%        AOT_531-Total,AOT_531-AOT,AOT_531-Rayleigh,AOT_531-O3,AOT_531- ...
%        NO2,AOT_531-CO2,AOT_531-CH4,AOT_531-Water,AOT_500-Total, ...
%        AOT_500-AOT,AOT_500-Rayleigh,AOT_500-O3,AOT_500-NO2,AOT_500- ...
%        CO2,AOT_500-CH4,AOT_500-Water,AOT_490-Total,AOT_490-AOT, ...
%        AOT_490-Rayleigh,AOT_490-O3,AOT_490-NO2,AOT_490-CO2,AOT_490- ...
%        CH4,AOT_490-Water,AOT_443-Total,AOT_443-AOT,AOT_443-Rayleigh, ...
%        AOT_443-O3,AOT_443-NO2,AOT_443-CO2,AOT_443-CH4,AOT_443-Water, ...
%        AOT_440-Total,AOT_440-AOT,AOT_440-Rayleigh,AOT_440-O3,AOT_440- ...
%        NO2,AOT_440-CO2,AOT_440-CH4,AOT_440-Water,AOT_412-Total, ...
%        AOT_412-AOT,AOT_412-Rayleigh,AOT_412-O3,AOT_412-NO2,AOT_412- ...
%        CO2,AOT_412-CH4,AOT_412-Water,AOT_380-Total,AOT_380-AOT, ...
%        AOT_380-Rayleigh,AOT_380-O3,AOT_380-NO2,AOT_380-CO2,AOT_380- ...
%        CH4,AOT_380-Water,AOT_340-Total,AOT_340-AOT,AOT_340-Rayleigh, ...
%        AOT_340-O3,AOT_340-NO2,AOT_340-CO2,AOT_340-CH4,AOT_340-Water, ...
%        Pressure[hPa],Total_O3[DobsonUnits],Total_NO2[DobsonUnits], ...
%        Last_Processing_Date(dd/mm/yyyy)
%    
function [aero] = aeronet_read_tot(fname)

fid=fopen(fname,'r');

[aero.path, aero.file, aero.ext]=fileparts(fname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ HEADER 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:6
  head{i}=fgetl(fid);
end

% level from line 1
C=textscan(head{1},'%s %*[^\n]','delimiter','<p>');
aero.level=C{1}{1};

% version from line 2
aero.version=head{2};

% Location from line 5
C=textscan(head{5},['Location=%s long=%f lat=%f elev=%f ' ...
		    'Nmeas=%f PI=%s Email=%s'],'delimiter',',');
aero.location=C{1}{1};
aero.long=C{2};
aero.lat=C{3};
aero.elev=C{4};
aero.Nmeas=C{5};
aero.PI=C{6}{1};
aero.email=C{7}{1};

% Wavelengths from line 6
C=textscan(head{6},'%s','delimiter',',');
aero.ncols=size(C{1},1);
aero.nwlen=0;
for i=1:size(C{1},1)
  word=C{1}{i};
  if (word(end-5:end) == '-Total')
    tmp=sscanf(word,'AOT_%d');
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

  % read line as float
  tmp=textscan(arow,'%f','delimiter',',');
  M(i,:)=tmp{1};  
end
aero.ntimes=i;
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CONVERTO DO MATLAB DATA TYPE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:aero.ntimes
  jini=1;
  % Date and Time
  aero.jd(i,1)=datenum(sprintf('%08d %06d',M(i,jini),M(i,jini+1)),...
		     'ddmmyyyy HHMMSS');
  jini=jini+2;
  % Day of year
  jini=jini+1;
  % AOT-Total, nwlen values
  aero.aot_total(i,:)=M(i,jini:8:jini+8*(aero.nwlen-1));
  jini=jini+1;
  aero.aot_aot(i,:)=M(i,jini:8:jini+8*(aero.nwlen-1));
  jini=jini+1;
  aero.aot_rayleigh(i,:)=M(i,jini:8:jini+8*(aero.nwlen-1));
  jini=jini+1;
  aero.aot_O3(i,:)=M(i,jini:8:jini+8*(aero.nwlen-1));
  jini=jini+1;
  aero.aot_NO2(i,:)=M(i,jini:8:jini+8*(aero.nwlen-1));
  jini=jini+1;
  aero.aot_CO2(i,:)=M(i,jini:8:jini+8*(aero.nwlen-1));
  jini=jini+1;
  aero.aot_CH4(i,:)=M(i,jini:8:jini+8*(aero.nwlen-1));
  jini=jini+1;
  aero.aot_Water(i,:)=M(i,jini:8:jini+8*(aero.nwlen-1));
  jini=jini+8*(aero.nwlen-1)+1;

  % pressure (hPa)
  aero.pressure(i,1)=M(i,jini);
  jini=jini+1;
  
  % ozone
  aero.o3dob(i,1)=M(i,jini);
  jini=jini+1;
  
  % no2
  aero.no2dob(i,1)=M(i,jini);
  jini=jini+1;

  % processing date
  jini=jini+1;

end
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VERIFY WAVELENGTHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:aero.nwlen
  % in at least 1 measurment
  if any(~isnan(aero.aot_total(:,i)))
    aero.anywlen(i)=1;
  end
  % in all measurements
  if ~any(isnan(aero.aot_total(:,i)))
    aero.allwlen(i)=1;
  end

end
% set 

%