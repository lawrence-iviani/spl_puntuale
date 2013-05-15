function polarOUT=UTIL_rotatePolarPattern(angle,polarIN)

%occhio che polarIN non sia una struttura
if (angle==0)     
    polarOUT=polarIN;
    return
end
if (angle < -2*pi || angle > 2*pi)
    disp('WARNING: angle out of range... Porbably something will go wrong');
end


for n=1:length(polarIN) 
    %Preparo l'array d'uscita 
    [ang index]=getAngle(angle,polarIN(n).angle);
    polarOUT(n).angle=ang;
    
    %disp(['index=',num2str(index),' and size(polarIN.pressure)=',num2str(size(polarIN(n).pressure))])
    polarOUT(n).pressure=circshift(polarIN(n).pressure',index)';
    polarOUT(n).initPhase=circshift(polarIN(n).initPhase',index)';
    polarOUT(n).freq=polarIN(n).freq;
    %disp(['Polar IN pattern angle is     ',num2str(polarIN(n).angle )]);
    %disp(['Polar OUT pattern angle is    ',num2str(polarOUT(n).angle )]);
    %disp(['Polar IN pattern pressure is  ',num2str(polarIN(n).pressure )]);
    %disp(['Polar OUT pattern pressure is ',num2str(polarOUT(n).pressure )]);
    %disp(['Polar IN pattern initPhase is  ',num2str(polarIN(n).initPhase )]);
    %disp(['Polar OUT pattern initPhase is ',num2str(polarOUT(n).initPhase)]);
end

function [angleOUT index]=getAngle(angle,angleIN)
%Calcola la nuova matrice angleOUT con la rotazione voluta e la riordina,
%ritorna anche l'indice di quantìè stata ruotata..
if angle==0
    angleOUT=angleIN;
    index=0;
    return
end

if (angle <-2*pi || angle > 2*pi) 
    disp('WARNING: rotation angle out of range');
end

disp(['Rotatiting - angle pattern ',num2str(UTIL_rad2deg(angleIN)),' deg of ',...
    num2str(UTIL_rad2deg(angle)) ,' deg']);
angleOUT=angleIN+angle;


if angle > 0
    [c r]=find(angleOUT>2*pi,1,'first');
    angleOUT(r:end)=angleOUT(r:end)-2*pi;
    index=-r+1;
else
    [c r]=find(angleOUT<0,1,'last');
    angleOUT(1:r)=angleOUT(1:r)+2*pi;
    index=-r;
end

disp(['Before circshift Pattern is ',num2str(UTIL_rad2deg(angleOUT)),' deg' ]);
angleOUT=circshift(angleOUT',index)';
disp(['And finally is              ', num2str(UTIL_rad2deg(angleOUT)),' deg' ]);

