function source=SPK_generateSource(freq)

%Genera una sorgente omnidirezionale alle  freqeunze volute, e con una
%risoluzione angolare voluta
% freq: array di frequenze a cui si vuole generare la sorgente
% SPL_db: SPL in dbspl sull'asse. Può essere un array (SPL per ogni
% frequenza) o unico
% angleResol: risoluzione angolare in gradi




source=struct();
source.freq=freq;%Frequenze prese in considerazione...
source.sens=0;%TODO: da implementare...
source.name='MICA';
source.manufacturer='Meyer Sound';
source.maxSPL=127;%TODO: DATO FITTIZIO

%Pattern: matrice che contiene il pattern direzionale (in scala lineare) per ogni frequenza 
%rad: array gli angoli in radianti del pattern
pressureOnAxes=calcolatePressure(freq,source.maxSPL);
[pattern phase rad]=calcolatePattern(freq,pressureOnAxes);
source.pressure=pressureOnAxes;%Pressione sul asse ad ogni frequenza..

for nf=1:length(freq)
    polarPattern=struct();
    polarPattern.freq=freq(nf);
    polarPattern.angle=zeros(1,length(rad));
    polarPattern.angle(:)=rad;
    polarPattern.pressure=zeros(1,length(rad));
    polarPattern.pressure(:)=pressureOnAxes(nf)*pattern(nf,:);
    polarPattern.initPhase=zeros(1,length(rad));
    polarPattern.initPhase(:)=phase(nf,:);
    source.polarPattern(nf)=polarPattern;
end

function pressure=calcolatePressure(freq,maxSPL)
temp=load(['0deg.csv']);
freqMeas=temp(:,1)';
pressureMeas=UTIL_dbSPL2pressure(temp(:,2)+6)';%Notare il più in quanto le misure sono state fatte a 6 metri!!
N_SAMPLE=length(freq);
N_BIN=length(freq);
Fs=44100;%La frequenza alla quale è effettuata la misura
Ts=1/Fs;
T=N_SAMPLE*Ts;

%Normalizzo rispetto ai dati del costruttore, considero la pressione totale
%al livello misurato (somma di tutte le pressioni per ogni banda di
%frequenza e la rapporto al SPL max fornito dal costruttore...
%PROBLEMI: TODO
%1 - Posso sommare così trnquillamente le pressioni? dovrei tenere conto
%della larghezza di banda di ogni SPL misurato (nel senso che viene
%applicato un filtro con una certa campana e non il filtro ideale), in
%realtà la misura del spl totale dovrei avercela, fornita da smaart oppure
%calcolarmela tenendo conto delle finestrature.
%2 - Io faccio misure con rumore rosa(12 db fattore di cresta), il costruttore  
%fornisce misure con rumore rosa AES (6dB di fattore di cresta)
pressureMAX_SPL=UTIL_dbSPL2pressure(maxSPL);
pressureMeas_RMS=sqrt(2*sum(pressureMeas.^2)/(T*N_BIN));
gain=pressureMAX_SPL/pressureMeas_RMS;
disp(['pressureMAX_SPL=',num2str(pressureMAX_SPL),' Pa pressureMeas_RMS=',num2str(pressureMeas_RMS),...
      ' Pa gain=',num2str(gain),' (',num2str(UTIL_linearAmp2db(gain)),'db)' ]);

%NON DEVO NORMALIZZARE CON I PRODOTTI MEYER, HO GIA' L'SPL MISURATO DA LORO 
%pressureMeas=gain.*pressureMeas;%Pressione normalizzata
%pressureMeas_RMS=sqrt(2*sum(pressureMeas.^2)/(T*N_BIN));

%Interpolo alle frequenze che mi serve l'ambaradan..
pressure=zeros(length(pressureMeas),1);
for n=1:length(freq)
    r=findFreqIndex(freqMeas,freq(n));  
    p_sup=pressureMeas(r(2));
    p_inf=pressureMeas(r(1));
    f_sup=freqMeas(r(2));
    f_inf=freqMeas(r(1));
    m=(p_sup-p_inf)/(f_sup-f_inf);
    q=p_inf-m*f_inf;
    pressure(n)=freq(n)*m+q;
end
%disp(['length freq=',num2str(length(freq)),' length press=',num2str(length(pressure))]);

function r=findFreqIndex(vector_f,f)
[c r_l]=find(vector_f<=f,1,'last');
[c r_h]=find(vector_f>f,1,'first');
if (isempty(r_h))
    r(1)=r_l-1;
    r(2)=r_l;
else
    if (isempty(r_l) )
        r(2)=r_h;
        r(1)=r_h-1;
    else
        r(1)=r_l;
        r(2)=r_h;
    end
end

function [pattern phase rad]=calcolatePattern(freq, pressureOnAxes)

degree=[0 20 40 60 80 100 120 140 160 180 200 220 240 260 280 300 320 340];
rad=UTIL_deg2rad(degree);


for n=1:length(degree)
    temp=load([num2str(degree(n)),'deg.csv']);
    pressureMeas(n,:)=UTIL_dbSPL2pressure(temp(:,2)+6)';%La misura è stata fatta a due metri!
    phaseMeas(n,:)=temp(:,2);
    phaseMeas(n,:)=0; %Non c'è la fase sul mapponline!!
end
freqMeas=temp(:,1)';
       

pattern=zeros(length(freq),length(rad));
phase=zeros(length(freq),length(rad));
for nf=1:length(freq)
    rf=findFreqIndex(freqMeas,freq(nf)); 
    f_inf=freqMeas(rf(1));
    f_sup=freqMeas(rf(2));
    %disp(['search for ',num2str(freq(nf)),' Hz find finf=',num2str(f_inf),' hz fsup=',num2str(f_sup),' hz'])
        
    p_inf=pressureMeas(:,rf(1));
    p_sup=pressureMeas(:,rf(2));
    %mp=((p_sup-p_inf)/(f_sup-f_inf));
    %qp=p_inf-f_inf*mp;
    pattern(nf,:)=UTIL_interpolate(freq(nf),p_sup,p_inf,f_sup,f_inf);%freq(nf)*mp+qp;
    pattern(nf,:)=pattern(nf,:)/pressureOnAxes(nf,:);
    
    ph_inf=phaseMeas(:,rf(1));
    ph_sup=phaseMeas(:,rf(2));
   
    %se la fase è arrotolata...
    %phase(nf,:)=UTIL_interpolatePhase(freq(nf), phaseMeas, rf(2), rf(1), f_sup, f_inf);
    %altrimenti basta interpolazione lineare...
    phase(nf,:)=UTIL_interpolate(freq(nf),ph_sup,ph_inf,f_sup,f_inf);
end

