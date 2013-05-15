function fig=UTIL_displayPolarPattern(polarPattern, numberOfPattern)

%Visualizza su un grafico polare la risposta in frequenza di uno speaker
%(visualizza un certo numero di pattern)

maxVal=0;
for n=1:length(polarPattern) 
    tMax=max(polarPattern(n).pressure);
    maxVal=max(tMax , maxVal);
    %disp(['maxVal=' num2str(maxVal) ])
end
step=floor(length(polarPattern)/numberOfPattern);
color={'--blue'  '--green'  '--red' '--cyan' '--magenta' '--yellow'  '--black'};
ncolor=length(color);

for n=1:step:numberOfPattern
    intDivison=floor(n/ncolor);
    if (intDivison >= 1)
        tColor=char(color(n-intDivison*ncolor+1));
    else
        tColor=char(color(n));
    end
    ang=polarPattern(n).angle;
    pres=polarPattern(n).pressure;
    %disp([' maxpres=' num2str(max(pres)) ' ratio=' num2str(maxVal/max(pres)) ]);
    pres=pres*maxVal/max(pres);
    
    if (n==1)
        fig=polar(ang,pres,tColor);   
        hold on
    else
        polar(ang,pres,tColor);
    end
    
end
hold off
%figure(h(1));