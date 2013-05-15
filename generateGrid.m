function space=generateGrid(f,roomGeometry)
%NEW CODE
space=struct();
space.geometry=roomGeometry;
%Determino per ogni piano una griglia

for nplane=1:length(roomGeometry.plane)
    disp( ['generateGrid - Generating plane: '  roomGeometry.plane(nplane).name] ); 
    nx=length(roomGeometry.plane(nplane).coordinates.X);
    ny=length(roomGeometry.plane(nplane).coordinates.Y);
    for nf=1:length(f)
        freqSlice=struct();
        freqSlice.point=zeros(ny,nx);
        freqSlice.f=f(nf);
        space.geometry.plane(nplane).freqSlice(nf)=freqSlice;
    end
end

