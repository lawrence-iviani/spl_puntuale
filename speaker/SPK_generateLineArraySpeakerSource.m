function source=SPK_generateLineArraySpeakerSource(freq,SPL_db,angleResol)

%Genera una sorgente omnidirezionale alle  freqeunze volute, e con una
%risoluzione angolare voluta
% freq: array di frequenze a cui si vuole generare la sorgente
% SPL_db: SPL in dbspl sull'asse. Può essere un array (SPL per ogni
% frequenza) o unico
% angleResol: risoluzione angolare in gradi

%Questa funzione genera una sorgente omnidirezionale alle frequenze volute
%e con la risoluzione angolare voluta...

pressure=zeros(length(freq),1);
if (length(SPL_db)==1) 
    pressure(:)=UTIL_dbSPL2pressure(SPL_db);
else
    pressure(:)=UTIL_dbSPL2pressure(SPL_db(:));
end

rad=0:deg2rad(angleResol):2*pi-deg2rad(angleResol);

pattern=calcolatePattern(freq,rad);
pressure(:)=calcolatePressure(freq);

source=struct();
source.freq=freq;%Frequenze prese in considerazione...
source.sens=0;%TODO: da implementare...
source.name='PuPPa_ARRAY_MEDIUM (MILO)';
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

function pressure=calcolatePressure(freq)
freqMeas=[24 40 49   62  78     100   125   159   201   253   317  403   500    635 800   989   1245  1587  1978  2600  3200  4000  5078   6445  8008   10156 12500   16000 19000];
p=       [61 75 87.9 100 108.5 111.2 111.3 111.5 111.9 109.8 111.9 113.4 111.8  112 112.1 111.1 109.5 108.3 109.7 111.6 111.6 112.5 113.8  112.1 113.1  113.6  111.4  109.3 97.1 ];
p=UTIL_dbSPL2pressure(p);
for n=1:length(freq)
    r=findFreqIndex(freqMeas,freq(n));
    if (length(r)==2)
        p_sup=p(r(2));
        p_inf=p(r(1));
        f_sup=freqMeas(r(2));
        f_inf=freqMeas(r(1));
        m=(p_sup-p_inf)/(f_sup-f_inf);
        q=p_inf-m*f_inf;
        pressure(n)=freq(n)*m+q;
    else
        pressure(n)=p(r);
    end
end

function r=findFreqIndex(vector_f,f)
[c r_l]=find(vector_f<=f,1,'last');
[c r_h]=find(vector_f>f,1,'first');
if (isempty(r_h))
    r=r_l;
else
    if (isempty(r_l) )
        r(1)=r_h;
    else
        r(1)=r_l;
        r(2)=r_h;
    end
end

function pattern=calcolatePattern(freq,rad)



%frequenze al quale voglio il pattern con relativi coeff per il calcolo del
%pattern
freqMeas=[63  100 125  125.000000001 200  400 1000 1000.0000001 10000];
       a=[0.9 0.8 0.55 0.2           0.25 0.3 0.5  0.6          0.45];
       b=1-a;
       

pattern=zeros(length(freq),length(rad));
for nf=1:length(freq)
    r=findFreqIndex(freqMeas,freq(nf));
    if (length(r)==2)
        a_sup=a(r(2));
        a_inf=a(r(1));
        b_sup=b(r(2));
        b_inf=b(r(1));
        f_inf=freqMeas(r(1));
        f_sup=freqMeas(r(2));
        %disp(['search for ',num2str(freq(nf)),' Hz find finf=',num2str(f_inf),' hz fsup=',num2str(f_sup),' hz'])
        %disp(['asup=',num2str(a_sup),' ainf=',num2str(a_inf),...
        %    'bsup=',num2str(b_sup),' binf=',num2str(b_inf)])
        
        %un pò d'interpolazione
        ma=((a_sup-a_inf)/(f_sup-f_inf));
        mb=((b_sup-b_inf)/(f_sup-f_inf));
        qa=a_inf-f_inf*ma;
        qb=b_inf-f_inf*mb;
        %disp(['ma=',num2str(ma),' qa=',num2str(qa),...
        %    ' mb=',num2str(mb),' qb=',num2str(qb)])
        
        a_coef=freq(nf)*ma+qa;
        b_coef=freq(nf)*mb+qb;       
    else
        %disp(['search for ',num2str(freq(nf)), ' Hz find ',num2str(freqMeas(r)),' hz'])
        a_coef=a(r);
        b_coef=b(r);
    end
    %disp(['coeff a=',num2str(a_coef),' b=',num2str(b_coef)]);
    pattern(nf,:)=abs(a_coef+b_coef*cos(rad));
end


