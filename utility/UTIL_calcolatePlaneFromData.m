function planeDescription=UTIL_calcolatePlaneFromData(planeData)
%planeData: is a struct containing 3 points A,B,C with relative coordinates
%in the for A=[x y z]. And a resolution value for x and y 
%planeDescription: return a struct contaning the 3 points and the
%coordinates in linear form for x,y and a matrix for z
syms x y z 
f(1,:)=[x-planeData.A(1) y-planeData.A(2) z-planeData.A(3)];
f(2,:)=[planeData.B(1)-planeData.A(1) planeData.B(2)-planeData.A(2) planeData.B(3)-planeData.A(3)];
f(3,:)=[planeData.C(1)-planeData.A(1) planeData.C(2)-planeData.A(2) planeData.C(3)-planeData.A(3)];
planeFunction=det(f);
%strFunc=strcat(planeFunction);
disp(['UTIL_calcolatePlaneFromData - plane equation: ' ]);
planeFunction
%trovo il volume (parallelepipedo) che contiene tutti i punti identificati
%dai 3 punti
for k=1:3
    p_max(k)=max([planeData.A(k) planeData.B(k) planeData.C(k)]);
    p_min(k)=min([planeData.A(k) planeData.B(k) planeData.C(k)]);
end
%disp('preparing x-y value');
xlin=p_min(1):planeData.resX:p_max(1);
ylin=p_min(2):planeData.resY:p_max(2);

%
if length(ylin)==1
    ylin(1)=p_min(2);
    ylin(2)=p_max(2);
end
if length(xlin)==1
    xlin(1)=p_min(1);
    xlin(2)=p_max(1);
end
%
%

try
    tFunction=solve(planeFunction,'z')
    %planeFunction=tFunction;
    zz=zeros(length(ylin),length(xlin));
    for ny=1:length(ylin)
        zz(ny,:)=subs(tFunction,  {x,y},{xlin, ylin(ny)});
    end
    planeDescription.coord.Z=zz;
catch ME
    variable=ME.message(20);  
    disp(['UTIL_calcolatePlaneFromData - Can''t resolve for z variable, explicit variable is ' variable]);
    %tFunction=solve(planeFunction,variable);
    if strcmp(variable,'y')
        zres=(p_max(3)-p_min(3))/(length(xlin)-1);
        zlin=p_min(3):zres:p_max(3);
        ylin=ones(1,length(zlin))*planeData.A(2);
        zz=zeros(length(zlin),length(zlin));
        for n=1:length(zlin)
            tz=ones(1,length(zlin))*zlin(n);
            zz(n,:)=tz;
        end
        planeDescription.coord.Z=zz;
        
    elseif strcmp(variable,'x')
        zres=(p_max(3)-p_min(3))/(length(ylin)-1);
        zlin=p_min(3):zres:p_max(3);
        xlin=ones(1,length(zlin))*planeData.A(1);
        zz=zeros(length(zlin),length(zlin));
        for n=1:length(ylin)
            tz=ones(1,length(zlin))*zlin(n);
            zz(:,n)=tz;
        end
        planeDescription.coord.Z=zz;
        
    else
        disp('UTIL_calcolatePlaneFromData - No z or x or y variable... The points are allineated?');
        planeDescription=[];
        return
    end
end

%calcolo quali sono i valori di z del piano identificato da xCoord e
%yCoord
%disp('preparing z value');
planeDescription.coord.X=xlin;
planeDescription.coord.Y=ylin;


