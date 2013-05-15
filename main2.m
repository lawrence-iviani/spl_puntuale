%Funzione d'ingresso di tutto l'ambaradan

%Alloco un pò di dati, per velocizzare l'esecuzione
fprintf(1,'Alloco dati\n');

%Genero un vettore di frequenze 
LoF=20;
HiF=150;
resolution=1/3;
freq=generateFreq(LoF,HiF, resolution);

%Genero la griglia di osservazione

roomGeometry=struct();
roomGeometry.X=30;
roomGeometry.Y=30;
roomGeometry.resX=0.5;
roomGeometry.resY=0.5;
spaceGrid=generateGrid(freq,roomGeometry);
fprintf(1,'Room size is X=%f Y=%f with resolution %fx%f\n',roomGeometry.X,roomGeometry.Y,roomGeometry.resX,roomGeometry.resY);

SPL=132; %Spl in dB ad 1 m
angleResolution=5;%in gradi

%---------SPEAKER--------
%GUI_addSpeaker();

speakers=struct();
speakers.nSpeakers=4;
relX=0.1*roomGeometry.X;
%tempX=0.1*roomGeometry.X;
tempX=roomGeometry.X/2-relX*speakers.nSpeakers/2;
tempY=0.1*roomGeometry.Y;


for k=1:speakers.nSpeakers
    fprintf(1,'Speaker %d X=%f Y=%f\n',k,tempX+(k-1)*relX,tempY);
    speaker=generateOmniSource(freq,SPL,angleResolution,tempX+(k-1)*relX,tempY);%TODO: funzione di radiazione, risposta in frequenza in asse
    speakers.speaker(k)=speaker;
end

%speaker=generateOmniSource(freq,SPL,angleResolution,2*tempX,tempY);%TODO: funzione di radiazione, risposta in frequenza in asse
%speakers.speaker(2)=speaker;

%speaker=generateOmniSource(freq,SPL,angleResolution,3*tempX,tempY);%TODO: funzione di radiazione, risposta in frequenza in asse
%speakers.speaker(3)=speaker;

fprintf(1,'Fine allocazione\n');

%calcolo gli spl
spaceGrid=calculateGrid(speakers,spaceGrid,343);

%Un pò di r'n'r
freq_n=7;
[X Y]=meshgrid(spaceGrid.xCoord,spaceGrid.yCoord);
surf(X,Y,pressure2dbSPL(spaceGrid.freqSlice(freq_n).point));
hidden off;
colormap(jet);
shading flat;
title(['Peak and dip at ', num2str(spaceGrid.freqSlice(freq_n).f),' Hz']);
xlabel('meter')
ylabel('meter')
zlabel('dB_SPL');

