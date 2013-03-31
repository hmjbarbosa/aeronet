clear 
tic

fid=fopen('../../aeronet/Manaus_EMBRAPA/110101_131231_Manaus_EMBRAPA.tot20','r');

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