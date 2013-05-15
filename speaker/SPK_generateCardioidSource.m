function source=SPK_generateCardioidSource(freq,SPL_db,angleResol)

%Genera una sorgente omnidirezionale alle  freqeunze volute, e con una
%risoluzione angolare voluta
% freq: array di frequenze a cui si vuole generare la sorgente
% SPL_db: SPL in dbspl sull'asse. Può essere un array (SPL per ogni
% frequenza) o unico
% angleResol: risoluzione angolare in gradi

%Questa funzione genera una sorgente omnidirezionale alle frequenze volute
%e con la risoluzione angolare voluta...

rad=0:deg2rad(angleResol):2*pi-deg2rad(angleResol);


pattern=zeros(length(freq),length(rad));
a_max=0.8;
a_min=0.0005;
%m=(0.1-1)/(20000-20);%coeff angolare tra 20 e 20 khz con valori di a agli estremi
%q=-m*20000;
%a=freq*m+q;
%b=1-a;
%[a b]=parabolicFunction(freq,a_min,a_max,1);
[a b]=linearFunction(freq,a_min,a_max);


for nf=1:length(freq)
    %pattern(nf,:)=0.37+0.63*cos(rad);
    pattern(nf,:)=abs(a(nf)+b(nf)*cos(rad));
end
pressure=calcPressure(SPL_db,length(freq));
source=struct();
source.freq=freq;%Frequenze prese in considerazione...
source.sens=0;%TODO: da implementare...
source.name='VARIABLE! CaRdIoId_puppa';
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
N_SAMPLE=len;
N_BIN=len;
Fs=44100;
Ts=1/Fs;
T=N_SAMPLE*Ts;
pressure(:)=sqrt(UTIL_dbSPL2pressure(SPL_db)^2/(T*N_BIN));

function [a b]=linearFunction(x, y1, y2)
x2=x(end);
x1=x(1);

m=(y2-y1)/(x2-x1);
q=y1-m*x1;
b=m*x+q;
a=y2-b;

function [a b]=parabolicFunction(x, y1, y2, a)
x2=x(end);
x1=x(1);
t=(y1/x1 - a*x1 - y2/x1 + a*(x2^2)/x1)
b=t/(1-x2/x1);
c=y2-a*(x2^2)-b*x2;

a=a*x.^2+b*x+c;
b=y2-a;


