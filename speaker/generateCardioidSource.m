function source=generateCardioidSource(freq,SPL_db,angleResol,xpos,ypos)

%Questa funzione genera una sorgente omnidirezionale alle frequenze volute
%e con la risoluzione angolare voluta...
source=struct();
SPL_lin=UTIL_dbSPL2pressure(SPL_db);
rad=0:deg2rad(angleResol):2*pi;
SPL_pattern=zeros(length(freq),length(rad));
pattern=0.37+0.63*cos(rad);
SPL_pattern(:,:)=SPL_lin*pattern;%in uno speaker complesso bisogna avere i dati di orientazione e calcolarli con l'SPL
source.freq=freq;
source.rad=rad;
source.SPLpattern=SPL_pattern;
source.X=xpos;
source.Y=ypos;
source.orientation=pi/2;%L'orientamento della cassa (guarda verso dx)
