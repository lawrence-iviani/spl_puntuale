function source=SPK_generateSourceFromSourceData(freq, sourceData)

% Genera una sorgente alle  freqeunze volute, partendo da un insieme di
% dati misurati e salvati in una matrice. Sive File_createMatrix per capire
% l'organizzazione dei dati
% freq: array di frequenze a cui si vuole generare la sorgente



source=struct();
source.freq=freq;%Frequenze prese in considerazione...
source.sens=0;%TODO: da implementare... Si vuole implementare la sensibilità del componente.. è un'idea per il dimensionamento degli speaker....
source.name=sourceData.speakerName;
source.name=sourceData.speakerDescription;
source.manufacturer=sourceData.manufacturer;
source.maxSPL=sourceData.speakerSPLdB_1meter;


%Pattern: matrice che contiene il pattern direzionale (in scala lineare) per ogni frequenza 
%phase: la fase misurata
%rad: array gli angoli in radianti del pattern
[ pressureOnAxes pattern phase rad]=calcolatePressureAndPattern(freq,sourceData);

source.pressure=pressureOnAxes;%Pressione sul asse ad ogni frequenza..
%TODO: devo avere una serie di polarPattern, ora  il mio problema diventa
%identificare il pp da angolazione ed elevazione. quindi la struttura
%polarPattern non sarà più un  vettore per ogni frequenza ma una matrice
%per ogni frequenza....!!! Devo trovare un sistema intelligente per
%polarPattern di inserimento e prelievo dei dati 
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
 %figure;
 %UTIL_displayPolarPattern(source,1)
%end debug code


function [pressureOnAxes pattern phase rad]=calcolatePressureAndPattern(freq,sourceData)
%temp=load(['OK-RTA_on_axis.txt']);
%freqMeas=temp(:,1)';
freqMeas=sourceData.SPL_on_axis(:,1);

%pressureMeasOnAxes=UTIL_dbSPL2pressure(temp(:,2))';
pressureMeasOnAxes=UTIL_dbSPL2pressure(sourceData.SPL_on_axis(:,2));
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
pressureMAX_SPL=UTIL_dbSPL2pressure(sourceData.speakerSPLdB_1meter);
pressureMeasOnAxes_RMS=sqrt(2*sum(pressureMeasOnAxes.^2)/(T*N_BIN));
gain=pressureMAX_SPL/pressureMeasOnAxes_RMS;
disp(['pressureMAX_SPL=',num2str(pressureMAX_SPL),' Pa pressureMeas_RMS=',num2str(pressureMeasOnAxes_RMS),...
      ' Pa gain=',num2str(gain),' (',num2str(UTIL_linearAmp2db(gain)),'db)' ]);
pressureMeasOnAxes=gain.*pressureMeasOnAxes;%Pressione normalizzata
pressureMeasOnAxes_RMS=sqrt(2*sum(pressureMeasOnAxes.^2)/(T*N_BIN));
[pattern phase rad]=calcolatePattern(freq,pressureMeasOnAxes, gain, sourceData);

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
[r_l c]=find(vector_f<=f,1,'last');
[r_h c]=find(vector_f>f,1,'first');

if (isempty(r_h) || r_h==0 )
    r(1)=r_l-1;
    r(2)=r_l;
else
    if (isempty(r_l) || r_l==0 )
        r(2)=r_h;
        r(1)=r_h-1;
    else
        r(1)=r_l;
        r(2)=r_h;
    end
end

function [pattern phase rad]=calcolatePattern(freq, pressureOnAxes,gain,sourceData)


rad=UTIL_deg2rad(sourceData.angle);
for n=1:length(rad)
    %temp=load(['OK-FreqResp_',num2str(degree(n)),'deg.txt']);
    temp(:,:)=sourceData.FreqResp(n,:,:);
    t=(UTIL_dbSPL2pressure(temp(:,2))*gain);
    pressureMeas(:,n)=t;
    t=unwrap(UTIL_deg2rad(temp(:,3)) );
    phaseMeas(:,n)=t;
end
freqMeas=temp(:,1);


pattern=zeros(length(freq),length(rad));
phase=zeros(length(freq),length(rad));
for nf=1:length(freq)
    rf=findFreqIndex(freqMeas,freq(nf)); 
    f_inf=freqMeas(rf(1));
    f_sup=freqMeas(rf(2));
    %disp(['search for ',num2str(freq(nf)),' Hz find finf=',num2str(f_inf),' hz fsup=',num2str(f_sup),' hz'])
        
    %p_inf=pressureMeas(:,rf(1));
    %p_sup=pressureMeas(:,rf(2));
    p_inf=pressureMeas(rf(1),:);
    p_sup=pressureMeas(rf(2),:);
    %disp(['pinf=', num2str(p_inf)])
    %disp(['psup=',num2str(p_sup)])
    t=UTIL_interpolate(freq(nf),p_sup,p_inf,f_sup,f_inf);
    pattern(nf,:)=t; %freq(nf)*mp+qp;
    pattern(nf,:)=pattern(nf,:)/pressureOnAxes(nf);
    
    ph_inf=phaseMeas(rf(1),:);
    ph_sup=phaseMeas(rf(2),:);
    %disp(['ph_inf=', num2str(ph_inf)])
    %disp(['ph_sup=',num2str(ph_sup)])
    
    disp('FIXME: verificare fase (wrapped e unwrapped e correttezza intrepolazione');
    %se la fase è arrotolata...
    %phase(nf,:)=UTIL_interpolatePhase(freq(nf), phaseMeas, rf(2), rf(1), f_sup, f_inf);
    %altrimenti basta interpolazione lineare...
    
    t=UTIL_interpolate(freq(nf),ph_sup,ph_inf,f_sup,f_inf);
    phase(nf,:)=t;
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

subplot(311)
semilogx(freq,ampl)
subplot(312)
semilogx(freq,phase)
subplot(313)
semilogx(freq,unwrap(phase))        

