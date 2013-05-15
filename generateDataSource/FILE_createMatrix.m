function FILE_createMatrix(speakerName, speakerDescription, speakerSPLdB_1meter, formatType, readPath, writeFileName)

% Crea le matrici dai file di misura cercando nel percorso path.
% formatType indica il tipo di formato. 
% Tipi supportati: SMAART, CSVMAPP.
% pathRead: è il path da dove leggere in formato ASCII le diverse misure
% writeFileName: nome e path dove scrivere la matrice 
if (isempty(speakerName))
    speakerName='No name';
end
if (isempty(speakerDescription))
    speakerDescription='No description';
end
if (isempty(speakerSPLdB_1meter))
    warning('Invalid data for SPL @ 1 meter.. Can''t save matrix')
    return
end

manufacturer='FIXME: NOT IMPLEMENTED';

if ( strcmp(formatType, 'SMAART')==1)
    disp('SMAART')
    
    %preparo spl su asse.
    nomefile=strcat(readPath,'/RTA.txt');
    tSPL=FILE_readSmaartFreqResponse(nomefile);
    %Salvo solo i valori di frequenza e SPLdB, il terzo è il valore di fase
    %ma non ha senso nel RTA.. Viene introdotto (posto a zero) dalla
    %funzione per motivi di coerenza...
    SPL_on_axis=tSPL(:,1:2);
    
    count=1;
    angle=[];
    files=dir(readPath);
    for n=1:length(files)
        index1=strfind(files(n).name,'FreqResp_');
        index2=strfind(files(n).name,'.txt');
        if ( ~isempty(index1) && ~isempty(index2) )
            %ho trovato un file di risposte in frequenze
            t=files(n).name( (index1+length('FreqResp_')):end );    
            %TODO: ORA DEVO DEFINIRE UN THETA ED UN FI DIVERSI. QUINDI LA
            %MIA MODIFICA PARTE QUA E SI PROPAGA VERSO
            %SPK_generateSourceFromSourceData E QUINDI AL RESTO DEL
            %PROGRAMA... ORA DEVO TROVARE 
            angle(count)=sscanf(t ,'%fdeg.txt' );
            
            count=count+1;
        end
    end
    %ordino nomefile e angle in modo tale che siano ordinati!!!!
    angle=sort(angle);  
    for n=1:length(angle)
        nomefile=strcat(readPath,'/','FreqResp_',num2str(angle(n)),'deg.txt');
        %disp(['nome file = ' nomefile]);
        FreqResp(n,:,:)=FILE_readSmaartFreqResponse(nomefile);
    end
    
elseif ( strcmp(formatType, 'CSVMAPP')==1 )
    disp('CSVMAPP')
    %preparo spl su asse.
    nomefile=strcat(readPath,'/RTA.csv');
    SPL_on_axis=csvread(nomefile);
    count=1;
    angle=[];
    files=dir(readPath);
    for n=1:length(files)
        index1=strfind(files(n).name,'FreqResp_');
        index2=strfind(files(n).name,'.csv');
        if ( ~isempty(index1) && ~isempty(index2) )
            %ho trovato un file di risposte in frequenze
            t=files(n).name( (index1+length('FreqResp_')):end );    
            angle(count)=sscanf(t ,'%f.csv' );
            
            count=count+1;
        end
    end
    %ordino nomefile e angle in modo tale che siano ordinati!!!!
    angle=sort(angle);  
    for n=1:length(angle)
        nomefile=strcat(readPath,'/','FreqResp_',num2str(angle(n)),'deg.csv');
        disp(['nome file = ' nomefile]);
        tfreqresp=csvread(nomefile);
        %Aggiungo una colonna di zeri (la fase) che in mapp non c'è
        [r c]=size(tfreqresp);
        tfreqresp=[tfreqresp zeros(r,1)];
        FreqResp(count,:,:)=tfreqresp;
    end
    
else
    warning(['Errore: ' formatType{1}  ' tipo non supportato']);
    return
end

%   Scrivo la struttura dati ricavata
if (isempty(SPL_on_axis) || isempty(angle) || isempty(FreqResp) )
    warning('Some field is empty, NOT saving matrix');
else
    disp('Saving matrix');
    save(writeFileName,'speakerName','speakerDescription', 'manufacturer' ,'speakerSPLdB_1meter','SPL_on_axis','angle','FreqResp');
end