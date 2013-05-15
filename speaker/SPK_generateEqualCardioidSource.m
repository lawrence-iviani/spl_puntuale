function source=SPK_generateEqualCardioidSource(freq,SPL_db,angleResol)

%Genera una sorgente omnidirezionale alle  freqeunze volute, e con una
%risoluzione angolare voluta
% freq: array di frequenze a cui si vuole generare la sorgente
% SPL_db: SPL in dbspl sull'asse. Può essere un array (SPL per ogni
% frequenza) o unico
% angleResol: risoluzione angolare in gradi

%Questa funzione genera una sorgente omnidirezionale alle frequenze volute
%e con la risoluzione angolare voluta...



rad=0:deg2rad(angleResol):2*pi-deg2rad(angleResol);


%creo 1 pattern per ogni frequenza, adesso c'è lo stesso pattern per ogni
%freq ma dovrebbe dipendere dal freq
pattern=zeros(length(freq),length(rad));
for nf=1:length(freq)
    %pattern(nf,:)=0.37+0.63*cos(rad);
    pattern(nf,:)=abs(0.37+0.63*cos(rad));%TODO: boh
end
pressure=calcPressure(SPL_db,length(freq));

source=struct();
source.freq=freq;%Frequenze prese in considerazione...
source.sens=0;%TODO: da implementare...
source.name='Equal CaRdIoId_puppa';
source.manufacturer='PUPPA SPEAKER ltd';
source.maxSPL=SPL_db;%Fornito dal costruttore
source.pressure=pressure;%Pressione sul asse ad ogni frequenza..

for nf=1:length(freq)
    polarPattern=struct();
    polarPattern.freq=freq(nf);
    polarPattern.pressure=zeros(1,length(rad));
    polarPattern.angle=zeros(1,length(rad));
    polarPattern.initPhase=zeros(1,length(rad));
    polarPattern.angle(:)=rad;
    polarPattern.pressure(:)=pressure(nf)*pattern(nf,:);
    polarPattern.initPhase(:)=0;
    source.polarPattern(nf)=polarPattern;
end

function pressure=calcPressure(SPL_db,len)
pressure=zeros(len,1);
p=UTIL_dbSPL2pressure(SPL_db)
N_SAMPLE=1024;
N_BIN=len;
Fs=44100;
Ts=1/Fs;
T=N_SAMPLE*Ts;
pressure(:)=sqrt(p^2/(T*N_BIN))
