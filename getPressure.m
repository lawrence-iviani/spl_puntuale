function pressure=getPressure(speaker,d_x,d_y,d_z)

%ritorna la pressione complessa ad 1 m generata da uno speaker in una certa direzione,
%calcolata con le distanze d_x e d_y e  d_z dallo speaker.

%inizializzo il vettore d'uscita
npressure=length(speaker.polarPattern);
pressure=zeros(1,npressure);

[azimuth elevation dist]=cart2sph(d_x,d_y,d_z);
if (azimuth < 0)
    azimuth=azimuth+2*pi;
end
%disp(['getPressure: d_x=' num2str(d_x) ' d_y=' num2str(d_y) ' d_z=' num2str(d_z) ]);
%disp(['getPressure: dist=' num2str(dist) ' azimuth=' num2str(UTIL_rad2deg(azimuth)) ' elevation=' num2str(UTIL_rad2deg(elevation)) ]);

%sotto il metro nn voglio niente...
if (dist <= 1  )
    %disp(['getPressure: minor 1 exit dx=',num2str(d_x),' dy=',num2str(d_y) , ' dz=' num2str(d_z) ]);
    %disp(['getPressure: dist=' num2str(dist) ' azimuth=' num2str(azimuth) ' elevation=' num2str(elevation) ]);
    pressure(:)=0;
    return 
end

%l'angolo tra speaker e punto 

%ang=UTIL_getATAN(d_x,d_y);
%if (d_x > 0 && d_y > 0)

if (isnan(elevation) || isnan(azimuth) )
    disp(['getPressure: nan(ang) exit dx=',num2str(d_x),' dy=',num2str(d_y) , 'dz=' num2str(d_z) ...
        ' elevation=' num2str(UTIL_rad2deg(elevation)) ' azimuth=' num2str(UTIL_rad2deg(azimuth))  ]);
    pressure(:)=0;
    return 
end

%Cerco quali sn gli angoli più vicini....pressure(c_h)
[ind_azimuth_l ind_azimuth_h]=UTIL_findAngleIndex(azimuth,speaker.polarPattern(1));

%disp(['-----  dx=',num2str(d_x),' dy=',num2str(d_y),' ang=',num2str(UTIL_rad2deg(ang))]);
%printPolarPattern(speaker.polarPattern(1))

%Eseguo un'interpolazione lineare...
%Dang: è il delta ang tra l'angolo al valore da interpolare e il valore più
%vicino e più piccolo del diagramma polare
%Iang; è l'intervallo tra il valore più grande e più piccolo in cui cade
%l'angolo da interpolare

if (ind_azimuth_h==1)
    %NOTA: se sn all'ultimo angolo devo considerare che a esso devo sommare
    %un angolo giro, altrimenti verrebe fuori che angolo(ind_azimuth_h) è più piccolo
    %di angolo(ind_azimuth_l)
    disp('getPressure: ind_azimuth_h is 1');
    azimuth_low=speaker.polarPattern(1).angle(ind_azimuth_l);
    azimuth_hi=speaker.polarPattern(1).angle(ind_azimuth_h)+2*pi;
    %ang=ang+2*pi;
    %if (ang > 2*pi) 
     %   ang=ang-2*pi;
    %end
    
    %TODO: verificare questa parte, nell'intorno dei 360 quando è stata
    %applicata una rotazione e ad esempio ang_inf=340 e ang_sup 20, c'è il  problema 
    %che l'angolo nn torna quando ang passa da <360 a 0 gradi.. così sembra che la cosa si risolva
    if azimuth < azimuth_low
        azimuth=azimuth+2*pi;
    end
    %disp(['---ind_azimuth_h==1 ang=',num2str(UTIL_rad2deg(ang)),' deg']);
    %disp(['Find low angle is ',num2str(UTIL_rad2deg(azimuth_low)),...
    % ' deg high angle is ',num2str(UTIL_rad2deg(azimuth_hi)),' deg']);
    
    %Iang=azimuth_hi-azimuth_low;
    %Dang=ang-azimuth_low;
    
    %disp(['Iang=',num2str(UTIL_rad2deg(Iang)), ' deg Dang=',num2str(UTIL_rad2deg(Dang)), ' deg']);
else
    azimuth_low=speaker.polarPattern(1).angle(ind_azimuth_l);
    azimuth_hi=speaker.polarPattern(1).angle(ind_azimuth_h);
end
%disp(['getPressure: Find low angle is ',num2str(UTIL_rad2deg(azimuth_low)),...
%      ' deg high angle is ',num2str(UTIL_rad2deg(azimuth_hi)),' deg']);
 

%Iang=azimuth_hi-azimuth_low;
%Dang=ang-azimuth_low;
if ((azimuth_hi-azimuth_low)==0)
    disp(['----Iang is 0!! dx=',num2str(d_x),' dy=',num2str(d_y),' ang=',num2str(UTIL_rad2deg(ang)),' deg']);
    disp(['Find low angle is ',num2str(UTIL_rad2deg(azimuth_low)),...
     ' deg high angle is ',num2str(UTIL_rad2deg(azimuth_hi)),' deg----']);
end

%TODO: eliminare questo ciclo for dovrebbe velocizzare notevolmente il
%tutto, però sembra essere complesso... mmmmmhhhhh

pres_hi=zeros(1,length(speaker.polarPattern));
pres_lo=zeros(1,length(speaker.polarPattern));
ph_hi=zeros(1,length(speaker.polarPattern));
ph_lo=zeros(1,length(speaker.polarPattern));

for nfreq=1:length(speaker.polarPattern)
    %interpolazione pressione
    pres_hi(nfreq)=speaker.polarPattern(nfreq).pressure(ind_azimuth_h);
    pres_lo(nfreq)=speaker.polarPattern(nfreq).pressure(ind_azimuth_l);
    
    %interpolazione fase
    ph_hi(nfreq)=speaker.polarPattern(nfreq).initPhase(ind_azimuth_h);
    ph_lo(nfreq)=speaker.polarPattern(nfreq).initPhase(ind_azimuth_l);
    if (nfreq > 26) 
        disp('');
    end
end


press=UTIL_interpolate(azimuth,pres_hi,pres_lo,azimuth_hi,azimuth_low);  %(pres_lo+kpres*Dang);
%disp(['getPressure: press_lo     ',num2str(pres_lo)]);
%disp(['getPressure: press_interp ',num2str(press)]);
%disp(['getPressure: press_hi     ',num2str(pres_hi)]);

    
%se la fase è arrotolata...
%ph=UTIL_interpolatePhase(ang,speaker.polarPattern(n).initPhase,ind_azimuth_h,ind_azimuth_l,azimuth_hi,azimuth_low);  
%altrimenti basta interpolazione lineare...
ph=UTIL_interpolate(azimuth,ph_hi,ph_lo,azimuth_hi,azimuth_low);
%disp(['getPressure: phase_lo     ',num2str(ph_lo)]);
%disp(['getPressure: phase_interp ',num2str(ph)]);
%disp(['getPressure: phase_hi     ',num2str(ph_hi)]);

%calcolo pressione interpolata e applico la fase iniziale
pressure=press.*exp(j.*ph);


%if (ind_azimuth_h==1) 
%    disp(['----']);
%end
%if pressure(n)==0 
%    disp(['pressure is 0 at dx=',num2str(d_x),' dy=',num2str(d_y),' ang=',num2str(UTIL_rad2deg(ang))]);
%end
    



%fprintf(1,'%f<%f<%f\n', (speaker.rad(r_l,ind_azimuth_l)),(ang),(speaker.rad(r_h,ind_azimuth_h)));
%fprintf(1,'%d - %d\n', ind_azimuth_l,ind_azimuth_h);

function printPolarPattern(polPat)

for n=1:length(polPat)
    fprintf(1,'pol pat @ %f Hz\n',polPat(n).freq);
    for (k=1:length(polPat(n)))
        fprintf(1,'-- ang=%f press=%f \t',polPat(n).angle,polPat(n).pressure);
    end
    fprintf(1,'\n');
end
