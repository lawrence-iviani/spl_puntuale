function [c_l c_h]=UTIL_findAngleIndex(ang,polarPattern)



%Trovo gli angoli inf e sup del diagramma polare rispetto all'angolo
%formato tra lo speaker e il punto di misura
%ang
[r_l,c_l]=find(polarPattern.angle<=ang,1,'last');
[r_h,c_h]=find(polarPattern.angle>ang,1,'first');

if (c_l==c_h) 
    disp(['mmmmm find the same angle, searched for ', num2str(UTIL_rad2deg(ang)),...
        ' deg find (low) ',num2str(UTIL_rad2deg(polarPattern.angle(c_l))),...
        ' deg (hi) ', num2str(UTIL_rad2deg(polarPattern.angle(c_l))), ' deg']);
    
end
%disp(['index l=',num2str(c_l) ,'  h=',num2str(c_h)]);
if (c_h==1) 
    c_l=length(polarPattern.angle);
    c_h=1;
elseif (c_l==length(polarPattern.angle)) 
    c_h=1;
    c_l=length(polarPattern.angle);
end

if (isempty(polarPattern.pressure(c_l)) )
    disp(['speaker.polarPattern(',num2str(1),').pressure(',num2str(c_l),') is empty for d_x=',num2str(d_x), ...
            ' d_y=',num2str(d_y)]);
    %printPolarPattern(speaker.polarPattern)
end
if (isempty(polarPattern.pressure(c_h)) )
    disp(['speaker.polarPattern(',num2str(1),').pressure(',num2str(c_h),') is empty for d_x=',num2str(d_x), ...
            ' d_y=',num2str(d_y)]);
    %printPolarPattern(speaker.polarPattern)
end

%disp(['ang=',num2str(UTIL_rad2deg(ang)), ...
%      ' low ang=', num2str(UTIL_rad2deg(polarPattern.angle(c_l))) , ...
%      ' hi ang=', num2str(UTIL_rad2deg(polarPattern.angle(c_h)))]);

