function speaker=SPK_generateSpeaker(freq,speakerDescription,c)

%Genera una sorgente tenendo conto di delay, orientamento, pattern contenuta in speakerDescription
%per ogni frequenza contenuta in freq (in generale le frequenze in
%speakerDescr saranno diverse da quelle del progetto su cui si lavora..

%freq: vettore alle frequenze per le quali dev'essere genearato lo speaker
%speakerDescr: contiene informazioni a riguardo dello speaker..

%Interpolazione frequenze
speaker=struct();
spk=speakerDescription.speaker;

%genero un array di frequenze alle quali è misurato l'altoparlante, in
%quanto sono memorizzate una per ogni pattern polare che è una struttura
freqSpeaker=zeros(1,length(spk.polarPattern));
for nf=1:length(spk.polarPattern)
    freqSpeaker(nf)=spk.polarPattern(nf).freq;
end

speaker.X=speakerDescription.posX;    
speaker.Y=speakerDescription.posY;
speaker.Z=speakerDescription.posZ;
for nf=1:(length(freq))
    %----Trovo gli indici misurati negli speaker adiacenti alla frequenza che voglio calcolare
    [r_h c_h]=find(freqSpeaker>freq(nf),1,'first' );
    [r_l c_l]=find(freqSpeaker<=freq(nf),1,'last' );
    if (c_h==1) 
        c_h=2;
        c_l=1;
    end
    if (c_l==length(freqSpeaker) )
        c_h=length(freqSpeaker);
        c_l=length(freqSpeaker)-1;
    end
    
    %--------------eseguo interpolazione alle diverse FREQUENZE per ogni ANGOLO con relativa FASE
    % dei pattern misurati/ricavati dello speaker --------------   
    f_lo=freqSpeaker(c_l);
    f_hi=freqSpeaker(c_h);
    If=f_hi-f_lo;
    Df=freq(nf)-f_lo;
    %applico il ritardo elettronico calcolandone la fase in radianti...
    elettronicPhase=2*pi*freq(nf)*speakerDescription.delay/1000; %Ho il ritardo in msec!!
    if(speakerDescription.reversePolarity==1) 
        elettronicPhase=elettronicPhase+pi;
    end
    
    tempPolarPattern.freq=freq(nf);
    for ang=1:length(spk.polarPattern(nf).angle)
        press_lo=spk.polarPattern(c_l).pressure(ang);
        press_hi=spk.polarPattern(c_h).pressure(ang);
        ph_lo=spk.polarPattern(c_l).initPhase(ang);
        ph_hi=spk.polarPattern(c_h).initPhase(ang);
        kpress=(press_hi-press_lo)/If;
        kph=(ph_hi-ph_lo)/If;
        
        %memorizzo il pattern spaziale alla frequenza nf
        tempPolarPattern.angle(ang)=spk.polarPattern(c_l).angle(ang);
        tempPolarPattern.pressure(ang)=max(0, press_lo+Df*kpress);%occhio che nn scendano sotto lo zero per qualche strana interpolazione....
        tempPolarPattern.initPhase(ang)=ph_lo+Df*kph + elettronicPhase;
    end
    %disp(['phases are ',num2str(tempPolarPattern.initPhase)] );
    %---------applico la rotazione prevista e salvo--------------
    tempPolarPattern=UTIL_rotatePolarPattern(speakerDescription.orientation,tempPolarPattern);
    speaker.polarPattern(nf)=tempPolarPattern;   
end

%DEBUG!!
%npol=length(speaker.polarPattern);
%UTIL_displayPolarPattern(speaker.polarPattern,npol);



