function source=SPK_generateSubSource(freq,SPL_db,angleResol)

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

pattern=calcolateSUBPattern(freq,rad);
pressure=calcolatePressure(freq);

source=struct();
source.freq=freq;%Frequenze prese in considerazione...
source.sens=0;%TODO: da implementare...
source.name='PuPPa_SUB (meyer 650P)';
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
freqMeas=[21   26    32     38    49   72  98  124   159   198  247   311  380 700];
p=       [82.3 97.7  105.5 108.2 109.4 111 109 105.1 101.1 98.1 94.9  84.3 46   0];
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

function pattern=calcolateSUBPattern(freq,rad)



%frequenze al quale voglio il pattern con relativi coeff per il calcolo del
%pattern
freqMeas=[20    40   80    100   160];
       a=[0.9  0.85  0.7   0.58  0.55];
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


