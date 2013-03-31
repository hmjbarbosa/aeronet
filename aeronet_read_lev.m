% Function
%    function [aero] = aeronet_read_lev(fname)
%
% Input:
%    fname - string with full path and file name.
%
% Output:
%    aero - a Matlab object with all info from input file.
%
% Header (5 lines): 
%    
%    Level 2.0. Quality Assured Data.<p>The following data are pre and ...
%        post field calibrated, automatically cloud cleared and manually inspected.
%    
%    Version 2 Direct Sun Algorithm
%    
%    Location=Ji_Parana,long=-61.800,lat=-10.860,elev=100,Nmeas=7,PI=Brent ...
%             Holben,Email=brent@aeronet.gsfc.nasa.gov
%    
%    AOD Level 2.0,All Points,UNITS can be found at,,, http:// ...
%        aeronet.gsfc.nasa.gov/data_menu.html
%    
%    Date(dd-mm-yy),Time(hh:mm:ss),Julian_Day,AOT_1640,AOT_1020,AOT_870, ...
%        AOT_675,AOT_667,AOT_555,AOT_551,AOT_532,AOT_531,AOT_500, ...
%        AOT_490,AOT_443,AOT_440,AOT_412,AOT_380,AOT_340,Water(cm),% ...
%        TripletVar_1640,%TripletVar_1020,%TripletVar_870,% ...
%        TripletVar_675,%TripletVar_667,%TripletVar_555,%TripletVar_551, ...
%        %TripletVar_532,%TripletVar_531,%TripletVar_500,% ...
%        TripletVar_490,%TripletVar_443,%TripletVar_440,%TripletVar_412, ...
%        %TripletVar_380,%TripletVar_340,%WaterError,440-870Angstrom, ...
%        380-500Angstrom,440-675Angstrom,500-870Angstrom,340- ...
%        440Angstrom,440-675Angstrom(Polar),...
%        Last_Processing_Date(dd/mm/yyyy), ...
%        Solar_Zenith_Angle,SunphotometerNumber,AOT_1640- ...
%        ExactWavelength(nm),AOT_1020-ExactWavelength(nm),AOT_870- ...
%        ExactWavelength(nm),AOT_675-ExactWavelength(nm),AOT_667- ...
%        ExactWavelength(nm),AOT_555-ExactWavelength(nm),AOT_551- ...
%        ExactWavelength(nm),AOT_532-ExactWavelength(nm),AOT_531- ...
%        ExactWavelength(nm),AOT_500-ExactWavelength(nm),AOT_490- ...
%        ExactWavelength(nm),AOT_443-ExactWavelength(nm),AOT_440- ...
%        ExactWavelength(nm),AOT_412-ExactWavelength(nm),AOT_380- ...
%        ExactWavelength(nm),AOT_340-ExactWavelength(nm),Water(cm)- ...
%        ExactWavelength(nm)
%    
function [aero] = aeronet_read_lev(fname)
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
aero.version=head{2};

% Location from line 3
C=textscan(head{3},['Location=%s long=%f lat=%f elev=%f ' ...
		    'Nmeas=%f PI=%s Email=%s'],'delimiter',',');
aero.location=C{1}{1};
aero.long=C{2};
aero.lat=C{3};
aero.elev=C{4};
aero.Nmeas=C{5};
aero.PI=C{6}{1};
aero.email=C{7}{1};

% Wavelengths from line 5
C=textscan(head{5},'%s','delimiter',',');
aero.ncols=size(C{1},1);
aero.nwlen=0;
for i=1:size(C{1},1)
  tmp=textscan(C{1}{i},'AOT_%s');
  if (~isempty(tmp{1}))
    [num, ok]=str2num(tmp{1}{1});
    if ok
      aero.nwlen=aero.nwlen+1;
      aero.wlen(aero.nwlen)=num;
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
toc
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
  % AOT, nwlen values
  aero.aot(i,:)=M(i,jini:jini+aero.nwlen-1);
  jini=jini+aero.nwlen;
  % water(cm)
  aero.water(i,1)=M(i,jini);
  jini=jini+1;
  % triplets, nwlen values
  aero.triplet(i,:)=M(i,jini:jini+aero.nwlen-1);
  jini=jini+aero.nwlen;
  % water error(cm)
  aero.water(i,2)=M(i,jini);
  jini=jini+1;
  % angstrom, 6 values
  aero.angstrom(i,:)=M(i,jini:jini+6-1);
  jini=jini+6;
  % processing date
  jini=jini+1;
  % zenith angle
  aero.zen(i,1)=M(i,jini);
  jini=jini+1;
  % intrument
  aero.cimel(i,1)=M(i,jini);
  jini=jini+1;
  % exact wavelength, nwlen values
  aero.wlenexact(i,:)=M(i,jini:jini+aero.nwlen-1);
  jini=jini+aero.nwlen;
  % water wave length 
  aero.water(i,3)=M(i,jini);  
end
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VERIFY WAVELENGTHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:aero.nwlen
  % in at least 1 measurment
  if any(~isnan(aero.aot(:,i)))
    aero.anywlen(i)=1;
  end
  % in all measurements
  if ~any(isnan(aero.aot(:,i)))
    aero.allwlen(i)=1;
  end

end
% set 
toc
%