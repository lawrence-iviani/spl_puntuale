function matrix=FILE_readSmaartFreqResponse(nomeFile)

[fid message]=fopen(nomeFile);

if fid==-1
    messErr=strcat('Can''t open File: ', ' ', nomeFile);
    warning(messErr);
    matrix=[];
    return;
end

tline=' ';
n=1;
while ( ~(tline==-1) ) 
    tline=fgetl(fid);
    %se inizia per punto e virgola è un commento, salto  la riga
    index=strfind(tline,';');
    if ( ~isempty(index))  
        mess=tline(index(1)+1:end);
        %disp(mess);
    elseif (~(tline==-1)) 
        t=[0 -1000 0];
        index=strfind(tline,'***');
        if ( ~isempty(index)) 
            temp=sscanf(tline,'%f %s %s');
            t(1)=temp(1);     
        else
            temp=sscanf(tline,'%f');
            for k=1:length(temp)
                t(k)=temp(k);
            end
        end
        matrix(n,:)=t;
        n=n+1;
    end           
end

fclose(fid);