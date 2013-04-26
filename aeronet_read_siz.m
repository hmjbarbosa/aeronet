% Function
%    function [aero] = aeronet_read_tab(fname)
%
% Input:
%    fname - string with full path and file name.
%
% Output:
%    aero - a Matlab object with all info from input file.
%
% Header (4 lines): 
%    
%    14:03:2011,Locations=Manaus_EMBRAPA,long=-59.970,lat=-2.891,elev=
%        ...  115,Nmeas=2,PI=Paulo_Artaxo,Email=artaxo@if.usp.br
%
%    Level 2.0 Almucantar Retrievals, Version 2
%
%    Size Distribution,ALL POINTS DATA,Inversion Product UNITS can be
%        found at,,, http://aeronet.gsfc.nasa.gov/new_web/units.html
%    
%    Date(dd-mm-yyyy),Time(hh:mm:ss),Julian_Day, ...
%        0.050000,0.065604,0.086077,0.112939,0.148184,0.194429,0.255105,0.334716,...
%        0.439173,0.576227,0.756052,0.991996,1.301571,1.707757,2.240702,2.939966, ...
%        3.857452,5.061260,6.640745,8.713145,11.432287,15.000000, ...
%        Inflection_Point[um],...
%        last_processing_date(mm/dd/yyyy),alm_type, ...
%        solar_zenith_angle_for_1020nm_scan,sky_error,sun_error, ...
%        alpha440-870,tau440(measured),%sphericity,if_level2_AOD, ...
%        scat_angle_440(>=3.2to6),scat_angle_440(>=6to30),...
%        scat_angle_440(>=30to80),scat_angle_440(>=80),...
%        scat_angle_675(>=3.2to6),scat_angle_675(>=6to30),...
%        scat_angle_675(>=30to80),scat_angle_675(>=80),...
%        scat_angle_870(>=3.2to6),scat_angle_870(>=6to30),...
%        scat_angle_870(>=30to80),scat_angle_870(>=80),...
%        scat_angle_1020(>=3.2to6),scat_angle_1020(>=6to30),...
%        scat_angle_1020(>=30to80),scat_angle_1020(>=80),...
%        albedo_440,albedo_675,albedo_870,albedo-1020,...
%        average_solar_zenith_angle_for_flux_calculation,DATA_TYPE
function [aero] = aeronet_read_siz(fname)
tic
fid=fopen(fname,'r');

[aero.path, aero.file, aero.ext]=fileparts(fname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ HEADER 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:4
  head{i}=fgetl(fid);
end

% Location from line 1
C=textscan(head{1},['%s Locations=%s long=%f lat=%f elev=%f ' ...
		    'Nmeas=%f PI=%s Email=%s'],'delimiter',',');
aero.location=C{2}{1};
aero.long=C{3};
aero.lat=C{4};
aero.elev=C{5};
aero.Nmeas=C{6};
aero.PI=C{7}{1};
aero.email=C{8}{1};

% level from line 1
C=textscan(head{2},'%s %*[^\n]','delimiter','<p>');
aero.level=C{1}{1};

% version from line 3
aero.version=head{3};

% size limits from line 4
C=textscan(head{4},'%s','delimiter',',');
aero.ncols=size(C{1},1);
aero.nradius=0;
for i=1:size(C{1},1)
  word=C{1}{i};
  tmp=str2num(word);
  if (~isempty(tmp))
    aero.nradius=aero.nradius+1;
    aero.radius(aero.nradius)=tmp;
  end
end

% Wavelengths from line 4
C=textscan(head{4},'%s','delimiter',',');
aero.ncols=size(C{1},1);
aero.nwlen=0;
for i=1:size(C{1},1)
  word=C{1}{i};
  if (word(1:6) == 'albedo')
    tmp=sscanf(word,'albedo_%d');
    if (~isempty(tmp))
      aero.nwlen=aero.nwlen+1;
      aero.wlen(aero.nwlen)=tmp;
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
  arow=strrep(arow,'Level ','');

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

  % Absorption AOT, nradius values
  aero.size(i,:)=M(i,jini:jini+aero.nradius-1);
  jini=jini+aero.nradius;
  % inflection point
  aero.inflection(i,1)=M(i,jini);
  jini=jini+1;

  % processing date
  jini=jini+1;
  % zenith angle
  aero.alm_type(i,1)=M(i,jini);
  jini=jini+1;
  % zenith angle
  aero.zen(i,1)=M(i,jini);
  jini=jini+1;
  % sky_error
  aero.sky_error(i,1)=M(i,jini);
  jini=jini+1;
  % sun_error
  aero.sun_error(i,1)=M(i,jini);
  jini=jini+1;
  % alpha
  aero.alpha(i,1)=M(i,jini);
  jini=jini+1;
  % tau
  aero.tau440(i,1)=M(i,jini);
  jini=jini+1;
  % sphericity
  aero.sphere(i,1)=M(i,jini);
  jini=jini+1;
  % level2
  aero.islevel2(i,1)=M(i,jini);
  jini=jini+1;
  % scat_angle (>=3.2to6) (>=6to30) (>=30to80) (>=80)
  for k=1:aero.nwlen
    aero.scat_angle(i,k,1:4)=M(i,jini:jini+4-1);
    jini=jini+4;
  end
  % Albedo, nwlen values
  aero.albedo(i,:)=M(i,jini:jini+aero.nwlen-1);
  jini=jini+aero.nwlen;
  % zenith angle for flux
  aero.zenflux(i,1)=M(i,jini);
  jini=jini+1;
  % datatype
  aero.datatype(i,1)=M(i,jini);
  jini=jini+1;

end
toc

%