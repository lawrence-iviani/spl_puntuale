%Funzione d'ingresso di tutto l'ambaradan

actualPath=pwd;

%aggiungo un pò di funzioncine fatte da me..
path(path,[actualPath,'/utility']);
path(path,[actualPath,'/GUI']);
path(path,[actualPath,'/speaker']);
path(path,[actualPath,'/generateDataSource']);
%path(path,[actualPath,'/filespeaker']);

%Alloco un pò di dati, per velocizzare l'esecuzione
fprintf(1,'Alloco dati\n');

%TODO freq e velocità del suono dovrebbere essere impostate dall'utente.
%Genero un vettore di frequenze (la minima la massima con una certa
%risoluzione)
LoF=20;
HiF=10000;
resolution=1/3;
freq=UTIL_generateFreq(LoF,HiF, resolution);%Questa dev'essere la frequenza di tutto!!!

%Calcolo o stimo la velocità del suono
c=343;
%Genero la griglia di osservazione
%disegna la geometria

%Creao una struttura con una geometria di default
planeGeometry=struct();

planeGeometry.A=[0 0 1.6];
planeGeometry.B=[10 0 1.6];
planeGeometry.C=[0 10 1.6];
planeGeometry.D=[10 10 1.6];
planeGeometry.resX=0.25;
planeGeometry.resY=0.25;
planeGeometry.resZ=0.25;

roomGeometry=struct();
roomGeometry.plane(1)=planeGeometry;

[h roomGeometry]=GUI_RoomGeometry('RoomGeometry',roomGeometry);
if (ishandle(h)) 
    close(h);
end

%TODO: GUI PER SCEGLIERE LE FREQUENZE...
spaceGrid=generateGrid(freq,roomGeometry);
fprintf(1,'Room size is X=%f Y=%f with resolution %fx%f\n',roomGeometry.X,roomGeometry.Y,roomGeometry.resX,roomGeometry.resY);


%---------SPEAKER--------
speakers=struct();
speakerList=SPK_getSpeakerList('default');%Carica degli speaker di default.. tutta da veder questa..
speakers.nSpeakers=0;
finito=false;

while ~finito
    [h speakerDescription finito]=GUI_addSpeaker('RoomGeometry',roomGeometry,'SpeakerList',speakerList,...
        'SpeedOfSound',c);
    if (finito) 
        break
    end
    fprintf(1,'Added a %s speaker in %f %f oriented to %f rad with %f ms delay', ...
              speakerDescription.speaker.name, speakerDescription.posX , speakerDescription.posY, ...
              speakerDescription.orientation, speakerDescription.delay);
    if (speakerDescription.reversePolarity==1) 
        fprintf(1,' and polarity reversed\n');
    else
        fprintf(1,' and straight polarity\n');
    end
    speakers.nSpeakers=speakers.nSpeakers+1;
   
    
    %Pre-calcolo i pattern alle effettive frequenze, applico eventuali
    %ritardi e direzioni degli speaker 
    speaker=SPK_generateSpeaker(freq,speakerDescription);
    speakers.speaker(speakers.nSpeakers)=speaker;
end
close(h)
clear speaker
clear finito

fprintf(1,'Fine allocazione\n');


%calcolo gli spl
%TODO: statistiche
calc_nPoint=(spaceGrid.geometry.X/spaceGrid.geometry.resX)*(spaceGrid.geometry.Y/spaceGrid.geometry.resY);
fprintf(1,'Inizio calcolo, verranno calcolati %d punti per %d speaker \n',calc_nPoint,speakers.nSpeakers );

tic;
spaceGrid=calculateGrid(speakers,spaceGrid,c);
calc_time=toc;
fprintf(1,'Fine calcolo\nCalcolati %d punti per %d speaker in %f sec.\n', calc_nPoint,speakers.nSpeakers,calc_time  );

h=GUI_result('SpaceGrid',spaceGrid);
close(h)




