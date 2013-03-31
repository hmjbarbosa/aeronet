clear 
tic

fid=fopen('../../aeronet/Manaus_EMBRAPA/110101_131231_Manaus_EMBRAPA.ONEILL_20','r');

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
  % Total AOD 500nm
  aero.aot_total(i,1)=M(i,jini);
  jini=jini+1;
  % Fine AOD 500nm
  aero.aot_fine(i,1)=M(i,jini);
  jini=jini+1;
  % coarse AOD 500nm
  aero.aot_coarse(i,1)=M(i,jini);
  jini=jini+1;
  % fine fraction AOD 500nm
  aero.aot_finefrac(i,1)=M(i,jini);
  jini=jini+1;

  % Total AOD 500nm ERR
  aero.aot_total(i,2)=M(i,jini);
  jini=jini+1;
  % Fine AOD 500nm ERR
  aero.aot_fine(i,2)=M(i,jini);
  jini=jini+1;
  % coarse AOD 500nm ERR
  aero.aot_coarse(i,2)=M(i,jini);
  jini=jini+1;
  % fine fraction AOD ERR
  aero.aot_finefrac(i,2)=M(i,jini);
  jini=jini+1;

  % total angstrom 500nm
  aero.totang(i,1)=M(i,jini);
  jini=jini+1;
  % derivative of total angstrom
  aero.derivtotang(i,1)=M(i,jini);
  jini=jini+1;

  % fine angstrom 500nm
  aero.fineang(i,1)=M(i,jini);
  jini=jini+1;
  % derivative of fine angstrom
  aero.derivfineang(i,1)=M(i,jini);
  jini=jini+1;
  
  % solar zenith angle
  aero.sza(i,1)=M(i,jini);
  jini=jini+1;

  % air mass
  aero.mass(i,1)=M(i,jini);
  jini=jini+1;

  % air mass
  aero.mass(i,1)=M(i,jini);
  jini=jini+1;
  
  % input AOD
  aero.inputaod(i,:)=M(i,jini:jini+aero.nwlen-1);
  jini=jini+aero.nwlen;
 
  % processing date
  jini=jini+1;

  % number of used wavelengths
  aero.usedwlen(i,1)=floor(M(i,jini));
  jini=jini+1;

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

%