%Funzione d'ingresso di tutto l'ambaradan

actualPath=pwd;

%aggiungo un pò di funzioncine fatte da me..
path(path,[actualPath,'/utility']);
path(path,[actualPath,'/GUI']);
path(path,[actualPath,'/speaker']);
path(path,[actualPath,'/generateDataSource']);
%path(path,[actualPath,'/filespeaker']);

%Alloco un pò di dati, per velocizzare l'esecuzione
fprintf(1,'MAIN - Alloco dati\n');



%Genero la griglia di osservazione
%disegna la geometria

%Creo una struttura che descrive un piano con una geometria di default
%Mi servono 3 vertici del piano e la risoluzione x e y con il quale voglio
%effettuare la simulazione.
planeGeometry=struct();
planeGeometry.A=[0 0 0];
planeGeometry.B=[6 0 0];
planeGeometry.C=[0 6 0];
%planeGeometry.A=[0 7.4 7.5];
%planeGeometry.B=[15 7.4 7.5];
%planeGeometry.C=[0 7.6 -7.5];
planeGeometry.resX=0.05;
planeGeometry.resY=0.1;
planeGeometry.name='';

%La struttura roomGeometry contiene un array di piani sui quali voglio
%effettuare i conti
%roomGeometry=struct();
%roomGeometry.plane(1)=planeGeometry;

disp('MAIN - Preparing room geometry');
[h roomGeometry]=GUI_RoomGeometry('Plane',planeGeometry);
disp('MAIN - exit');
if (ishandle(h)) 
    disp('MAIN - closing handle');
    close(h);
end

%TODO: GUI PER SCEGLIERE LE FREQUENZE...
%TODO freq e velocità del suono dovrebbere essere impostate dall'utente.
%Genero un vettore di frequenze (la minima la massima con una certa
%risoluzione)
LoF=20;
HiF=10000;
resolution=1/3;
freq=UTIL_generateFreq(LoF,HiF, resolution);%Questa dev'essere la frequenza di tutto!!!
c=343;

disp('MAIN - Generating grid based on room geometry');
%Genero le griglie di punti dove voglio calcoare 
spaceGrid=generateGrid(freq,roomGeometry);

%---------SPEAKER--------
disp('MAIN - Preparing speakers list');
speakers=struct();
speakerList=SPK_getSpeakerList('default');%Carica degli speaker di default.. tutta da veder questa..
speakers.nSpeakers=0;
finito=false;
disp('MAIN - Speakers list done');

while ~finito
    [h speakerDescription finito]=GUI_addSpeaker('RoomGeometry',roomGeometry,'SpeakerList',speakerList,...
        'SpeedOfSound',c);
    if (finito) 
        break
    end
    fprintf(1,'MAIN - Added a %s speaker in %f %f %f oriented to %f rad with %f ms delay', ...
              speakerDescription.speaker.name, speakerDescription.posX , speakerDescription.posY, speakerDescription.posZ, ...
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

fprintf(1,'MAIN - Fine allocazione\n');


%calcolo gli spl
%TODO: statistiche
calc_nPoint=0;

for nplane=1:length(spaceGrid.geometry.plane)
    tnpoint=size(spaceGrid.geometry.plane(nplane).freqSlice(1).point);
    calc_nPoint=calc_nPoint+tnpoint(1)*tnpoint(2);
end

fprintf(1,'MAIN - Inizio calcolo, verranno calcolati %d punti per %d speaker \n',calc_nPoint,speakers.nSpeakers );

tic;
spaceGrid=calculateGrid(speakers,spaceGrid,c);
calc_time=toc;
fprintf(1,'MAIN - Fine calcolo\nCalcolati %d punti per %d speaker in %f sec.\n', calc_nPoint,speakers.nSpeakers,calc_time  );

h=GUI_result('SpaceGrid',spaceGrid);
close(h)




