function ang=UTIL_getATAN(d_x,d_y)

%Ritorna l'arco tangente tra 0:2pi 
%determino correttamente l'angolo e riporto tutto nell'intervallo 0:2pi   
if (d_x==0)
   ang=atan(d_y/0.0000000001);
else
   ang=atan(d_y/d_x);
end

if (d_x >= 0 && d_y < 0)
    %disp(['Ang from ',num2str(ang),' to ',num2str(ang+2*pi)])
    ang=ang+2*pi;
end
if (d_x < 0 && d_y <= 0) ||  (d_y > 0 && d_x <0) 
    %disp(['Ang from ',num2str(ang),' to ',num2str(ang+pi)])
    ang=ang+pi;
end