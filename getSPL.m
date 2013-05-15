function pressure=getPressure(speaker,d_x,d_y)

%ritorna l'SPL di uno speaker in una certa direzione, calcolata con le
%distanze d_x e d_y dallo speaker

%sotto il metro nn voglio niente...
if (UTIL_linDistance(d_x,d_y) < 1  )
    SPL=0;
    return 
end

%l'angolo tra speaker e punto 
ang=atan(d_y/d_x);
%if (d_x > 0 && d_y > 0)
if (isnan(ang))
    SPL=0;
    return 
end
%determino correttamente l'angolo e riporto tutto nell'intervallo 0:2pi    
if (d_x > 0 && d_y < 0)
    ang=ang+2*pi;
end
if (d_x < 0 && d_y < 0) ||  (d_y > 0 && d_x <0) 
    ang=ang+pi;
end
%fprintf(1,'dx=%f dy=%f ang=%f\n',d_x,d_y,rad2deg(ang));


%Cerco quali sn gli angoli più vicini...


%find(speaker.polarPattern.angle);
SPL=zeros(length(speaker.polarPattern), length(speaker.polarPattern(1).pressure) );
for n=1:length(speaker.polarPattern)
    [r_h,c_h]=find(speaker.polarPattern(n).angle<=ang,1,'first');
    [r_l,c_l]=find(ang>speaker.polarPattern(n).angle,1,'last');
    if (c_h==1) 
        c_l=1;
    end
    %TODO:Sarebbe da fare un'interpolazi
    SPL(n,:)=(speaker.polarPattern(n).pressure(c_l)+speaker.polarPattern(n).pressure(c_h))/2;
end
%fprintf(1,'%f<%f<%f\n', (speaker.rad(r_l,c_l)),(ang),(speaker.rad(r_h,c_h)));
%fprintf(1,'%d - %d\n', c_l,c_h);

%Esegue la media tra i due spl, andrebbe migliorata questa funzionalità con
%un'interpolazione...



