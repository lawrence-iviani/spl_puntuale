function h=UTIL_displayAllPlaneSPL(geometry,nFreqSlice,zminSPL,zmaxSPL)


h=figure;
%ax=[0 spaceGrid.geometry.X  0 spaceGrid.geometry.Y];%zminSPL zmaxSPL]
%axis manual 
%axis(ax);
hidden on;
colormap(jet);
%shading ('flat');
%title(h,['Peak and dip at ', num2str(plane.freqSlice(nFreqSlice).f),' Hz']);
xlabel('(X) meter')
ylabel('(Y) meter')
zlabel('(Z) meter');
colLim=[zminSPL zmaxSPL];
set(gca,'CLim',colLim);
hold on
for n=1:length(geometry.plane)
    tplane=geometry.plane(n);
    %[X Y]=meshgrid(tplane.coordinates.X,tplane.coordinates.Y);
    surf(tplane.coordinates.X,tplane.coordinates.Y,tplane.coordinates.Z,UTIL_pressure2dbSPL(tplane.freqSlice(nFreqSlice).point),...
        'FaceColor','interp',...
        'EdgeColor','none',...
        'FaceLighting','phong');
end
%zlim([zminSPL,zmaxSPL])
%caxis([zminSPL,zmaxSPL])

hold off


colorbar;