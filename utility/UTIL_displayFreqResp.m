function h=UTIL_displayFreqResp(spaceGrid , x, y)

%genero vettore di frequenze disponibili
freq=zeros(length(spaceGrid.freqSlice),1);
for n=1:length(spaceGrid.freqSlice)
    freq(n)=spaceGrid.freqSlice(n).f;
end

%Trovo gli indici del punto x,y basandomi sulle coordinate della griglia.
x_index=getIndex(x, spaceGrid.xCoord);
y_index=getIndex(y, spaceGrid.xCoord);

SPL=zeros(length(spaceGrid.freqSlice),1);
for n=1:length(spaceGrid.freqSlice)
    pressure(n)=spaceGrid.freqSlice(n).point(x_index,y_index);
end
h=figure();
PHASE=phase(pressure);
WRAP_PHASE=UTIL_rad2deg(wrapToPi(PHASE));
UNWRAP_PHASE=UTIL_rad2deg(PHASE);
SPL=UTIL_pressure2dbSPL(pressure);

%TODO: verificare time dealy
GROUP_DELAY(1)=-(PHASE(2)-PHASE(1))/(2*pi*(freq(2)-freq(1)));
for n=2:(length(PHASE)-1)
    GROUP_DELAY(n)=-(PHASE(n+1)-PHASE(n-1))/(2*pi*(freq(n+1)-freq(n-1)));
end
GROUP_DELAY(n+1)=-(PHASE(end)-PHASE(end-1))/(2*pi*(freq(end)-freq(end-1)));

xlim('manual')

subplot(411)
xlim([0.9*freq(1) 1.1*freq(n)])
semilogx(freq,SPL,'-s')
title(['SPL vs Freq @ (',num2str(spaceGrid.xCoord(x_index)), ',',num2str(spaceGrid.yCoord(y_index) ),')' ])
xlabel('Frequency (Hz)')
ylabel('Amplitude (dB SPL)')
subplot(412)
semilogx(freq,UNWRAP_PHASE,'-s')
title(['Unwrapped Phase vs Freq @ (',num2str(spaceGrid.xCoord(x_index)), ',',num2str(spaceGrid.yCoord(y_index) ),')' ])
xlabel('Frequency (Hz)')
ylabel('Phase (deg)')
subplot(413)
semilogx(freq,WRAP_PHASE,'-s')
title(['Wrapped Phase vs Freq @ (',num2str(spaceGrid.xCoord(x_index)), ',',num2str(spaceGrid.yCoord(y_index) ),')' ])
xlabel('Frequency (Hz)')
ylabel('Phase (deg)')
subplot(414)
semilogx(freq,GROUP_DELAY,'-s')
title(['Group delay vs Freq @ (',num2str(spaceGrid.xCoord(x_index)), ',',num2str(spaceGrid.yCoord(y_index) ),')' ])
xlabel('Frequency (Hz)')
ylabel('group delay (sec)')


function index=getIndex(x, xcoord)

[rx_l,cx_l]=find(xcoord<=x,1,'last');
[rx_h,cx_h]=find(xcoord>=x,1,'first');

if (isempty(cx_l))
    disp('WARNING: frequency response coordinates out of range, the graph will be approximate');
    cx_l=cx_h;
end
if (isempty(cx_h))
    disp('WARNING: frequency response coordinates out of range, the graph will be approximate');
    cx_h=cx_l;
end

if (cx_l==cx_h)
    index=cx_l;
else
    dx_l=abs(x-xcoord(cx_l));
    dx_h=abs(x-xcoord(cx_h));
    if (dx_l < dx_h) 
        index=cx_l;
    else
        index=cx_h;
    end
end