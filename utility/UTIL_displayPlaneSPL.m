function h=UTIL_displayPlaneSPL(plane,nFreqSlice,zminSPL,zmaxSPL)

[X Y]=meshgrid(plane.coordinates.X,plane.coordinates.Y);
h=figure;
%ax=[0 spaceGrid.geometry.X  0 spaceGrid.geometry.Y];%zminSPL zmaxSPL]
%axis manual 
%axis(ax);
hidden on;
colormap(jet);
surf(X',Y',plane.coordinates.Z,UTIL_pressure2dbSPL(plane.freqSlice(nFreqSlice).point));
%zlim([zminSPL,zmaxSPL])
caxis([zminSPL,zmaxSPL])
%clim([0 1])
shading flat;
title(['Peak and dip at ', num2str(plane.freqSlice(nFreqSlice).f),' Hz']);
xlabel('(X) meter')
ylabel('(Y) meter')
zlabel('(Z) meter');
colorbar;