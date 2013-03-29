clear 
tic

fid=fopen('../../aeronet/Manaus_EMBRAPA/110101_131231_Manaus_EMBRAPA.lev20','r');

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

%