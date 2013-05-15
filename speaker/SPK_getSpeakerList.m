function speakerList=SPK_getSpeakerList(file)

%Descrizione struttura Speaker..
%SPL_max in  pascal @ 1m
%Sensibilità in pascal/watt @ 1m
%Diag polare (vedi sotto)
%Nome
%Produttore
%Dimensioni (8 vertici)

%Per quanto riguarda il diag polare esso viene individuato da un'array composto da 1   struttura
%di questo tipo: (1 per ogni frequenza)
% freq: la frequenza a cui si riferisce
% matrix 2xN angolo1 angolo2 ... angoloN
%            val1    val2    ... valN

speakerList=struct();

freq=UTIL_generateFreq(20,20000, 1/3);
if (strcmp(file,'default')==1)
    %Preparo qualche dispositivo (omni,quasi-omni, cardioide, iper, otto ecc...)
    disp('omni');
    speakerList.speaker(1)=SPK_generateOmniSource(freq,120,5);%Genera una sorgente omni con 130 dBSPL, con frequenze del vettore freq e risoluzione angolre di 5°
    disp('cardioide');
    speakerList.speaker(2)=SPK_generateCardioidSource(freq,120,5);%Genera una sorgente cardioide (pattern dipendente dalla freq) con 130 dBSPL, con frequenze del vettore freq e risoluzione angolre di 5°
    
    p=pwd;
    disp('ns5 old way');
    cd ('speaker/speaker/yamaha/ns5');
    puppa=SPK_generateSource(freq);
    speakerList.speaker(3)=puppa;
    cd (p);
    disp('mica new way');
    a=open('measure/mica/mica.mat');
    puppa=SPK_generateSourceFromSourceData(freq,a);
    speakerList.speaker(4)=puppa;
    disp('ns5 new way');
    a=open('measure/ns5 measure/text/nsa5.mat');
    puppa=SPK_generateSourceFromSourceData(freq,a);
    speakerList.speaker(5)=puppa;
else
    
   %TODO: carica da file 
end