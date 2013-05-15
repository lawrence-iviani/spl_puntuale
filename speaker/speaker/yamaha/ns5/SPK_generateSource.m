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
source.name='NSA5';
source.manufacturer='Yamaha';
source.maxSPL=98;%Fornito dal costruttore

%Pattern: matrice che contiene il pattern direzionale (in scala lineare) per ogni frequenza 
%phase: la fase misurata
%rad: array gli angoli in radianti del pattern
[ pressureOnAxes pattern phase rad]=calcolatePressureAndPattern(freq,source.maxSPL);

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
%Just for debug
 %ang=0;
 %displayFreqResp(ang,source)


function [pressureOnAxes pattern phase rad]=calcolatePressureAndPattern(freq,maxSPL)
temp=load(['OK-RTA_on_axis.txt']);
freqMeas=temp(:,1)';
pressureMeasOnAxes=UTIL_dbSPL2pressure(temp(:,2))';
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
pressureMeasOnAxes_RMS=sqrt(2*sum(pressureMeasOnAxes.^2)/(T*N_BIN));
gain=pressureMAX_SPL/pressureMeasOnAxes_RMS;
disp(['pressureMAX_SPL=',num2str(pressureMAX_SPL),' Pa pressureMeas_RMS=',num2str(pressureMeasOnAxes_RMS),...
      ' Pa gain=',num2str(gain),' (',num2str(UTIL_linearAmp2db(gain)),'db)' ]);
pressureMeasOnAxes=gain.*pressureMeasOnAxes;%Pressione normalizzata
pressureMeasOnAxes_RMS=sqrt(2*sum(pressureMeasOnAxes.^2)/(T*N_BIN));
[pattern phase rad]=calcolatePattern(freq,pressureMeasOnAxes, gain);

pressureOnAxes=zeros(length(pressureMeasOnAxes),1);
for n=1:length(freq)
    r=findFreqIndex(freqMeas,freq(n));  
    p_sup=pressureMeasOnAxes(r(2));
    p_inf=pressureMeasOnAxes(r(1));
    f_sup=freqMeas(r(2));
    f_inf=freqMeas(r(1));
    m=(p_sup-p_inf)/(f_sup-f_inf);
    q=p_inf-m*f_inf;
    pressureOnAxes(n)=freq(n)*m+q;
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

function [pattern phase rad]=calcolatePattern(freq, pressureOnAxes,gain)

degree=[0 45 90 135 180 225 270 315];
rad=UTIL_deg2rad(degree);

for n=1:length(degree)
    temp=load(['OK-FreqResp_',num2str(degree(n)),'deg.txt']);
    pressureMeas(n,:)=(UTIL_dbSPL2pressure(temp(:,2))*gain)';
    phaseMeas(n,:)=unwrap(UTIL_deg2rad(temp(:,3))');
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
    pattern(nf,:)=UTIL_interpolate(freq(nf),p_sup,p_inf,f_sup,f_inf); %freq(nf)*mp+qp;
    pattern(nf,:)=pattern(nf,:)/pressureOnAxes(nf);
    
    ph_inf=phaseMeas(:,rf(1));
    ph_sup=phaseMeas(:,rf(2));
   
    %se la fase è arrotolata...
    %phase(nf,:)=UTIL_interpolatePhase(freq(nf), phaseMeas, rf(2), rf(1), f_sup, f_inf);
    %altrimenti basta interpolazione lineare...
    phase(nf,:)=UTIL_interpolate(freq(nf),ph_sup,ph_inf,f_sup,f_inf);
end


function displayFreqResp(angle,source)
freq=zeros(1,length(source.polarPattern));
ampl=zeros(1,length(source.polarPattern));
phase=zeros(1,length(source.polarPattern));
index=find(angle<=source.polarPattern(1).angle,1,'last');
for nf=1:length(source.polarPattern)
    polPat=source.polarPattern(nf);
    freq(nf)=polPat.freq;
    ampl(nf)=source.polarPattern(nf).pressure(index);
    phase(nf)=source.polarPattern(nf).initPhase(index);
end

%subplot(311)
%semilogx(freq,ampl)
%subplot(312)
%semilogx(freq,phase)
%subplot(313)
%semilogx(freq,unwrap(phase))        

