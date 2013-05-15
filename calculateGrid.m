 function space=calculateGrid(speakers, space, c)

  
    %Devo copiarmi la struttura space altrimenti nn funge un casso. Cioè le
    %modifiche effettuate su questa struttura vengono perse.. mah
space=struct(space);
for n_plane=1:length(space.geometry.plane)
    tPlane=space.geometry.plane(n_plane);
    disp(['calculateGrid - Calculating plane ' tPlane.name]);
    n_y=length(tPlane.coordinates.Y);
    n_x=length(tPlane.coordinates.X);
    n_tot=n_x*n_y;
    n_done=0;
    figure;
    hold on;
    for xn=1:n_x
       x=tPlane.coordinates.X(xn);
       for yn=1:n_y
           y=tPlane.coordinates.Y(yn);
           z=tPlane.coordinates.Z(yn,xn);
           for n=1:speakers.nSpeakers
                speaker=speakers.speaker(n);
                %DEBUG!!
                if (xn==1 && yn == 1) 
                    UTIL_displayPolarPattern(speaker.polarPattern,length(speaker.polarPattern));
                end
                    
                %debug only
                %[f_spk f_space]=compareFrequency(speakers.speaker(n), space);       
                %disp(['calculateGrid - ([num2str(n),'-f_spk=',num2str(f_spk)]);
                %disp(['calculateGrid - (['  f_grd=',num2str(f_space)]);

                d_x=x-speaker.X;
                d_y=y-speaker.Y;
                d_z=z-speaker.Z;
                dist=UTIL_linDistance(d_x,d_y,d_z);
                %TODO: Attenuazione, dovrebbe essercene 1 per ogni frequenza
                %(FENOMENO ATTENUAZIONE ALTE FREQUENZE)
                att=UTIL_calcAtt(dist);        
                %getPressure, deve ritornare un vettore di frequenze. 1 per per ogni
                %frequneza all'angolo descritto dal d_x e d_y e d_z
                %disp(['calculateGrid - X=' num2str(x) ' Y='  num2str(y) ' Z=' num2str(z) ]);
                pressure=getPressure(speaker,d_x,d_y,d_z);
                if (dist <= 1) disp(['calculateGrid - dx=' num2str(d_x) ' dy=' num2str(d_y) ' dz=' num2str(d_z) ...
                    ' dist=' num2str(dist) ' att=' num2str(dist) ' (ratio) pressure='  num2str(pressure) ]);
                end
                

        %TODO: pressure ha è un vettore di lunghezza nf!!! Tenerne conto x
        %ottimizare!!
                for nf=1:length(tPlane.freqSlice)
                    if pressure(nf)==0 
                        %tPlane.freqSlice(nf).point(yn,xn)=tPlane.freqSlice(nf).point(yn,xn);
                        if (nf==1) 
                            disp(['calculateGrid - Zero with dist=',num2str(dist) ' press=' ...
                                num2str(tPlane.freqSlice(nf).point(yn,xn)) ]); 
                        end                        
                    elseif isnan(pressure(nf))
                        disp(['calculateGrid - Pressure point is NAN!! @ ',num2str(tPlane.coordinates.X(xn)),' ',num2str(tPlane.coordinates.Y(yn)),' f=', num2str(tPlane.freqSlice(nf).f)]);
                        %tPlane.freqSlice(nf).point(yn,xn)=tPlane.freqSlice(nf).point(yn,xn);
                    else
                        fi=2*pi*tPlane.freqSlice(nf).f/c*dist;
                        prevValue=tPlane.freqSlice(nf).point(yn,xn);
                        tPlane.freqSlice(nf).point(yn,xn)=((pressure(nf)*att)*exp(j*fi))+prevValue;
                    end
                end
                plot3(x,y,pressure(length(tPlane.freqSlice)),'+');
                hold on
                
           end 
       end
       n_done=n_done+n_y;
       fprintf(1,'Done %d/%d (%f ) \n',n_done,n_tot,(n_done/n_tot)*100);
    end
    hold off;
    space.geometry.plane(n_plane)=tPlane;
  %  createPolarPatternFromPlane(speakers.speaker(1),tPlane)
end
%space.freqSlice(1).point(1,1)=100;
%space.freqSlice(nf).point

function createPolarPattern_XY_FromPlane(speaker, plane)
speaker.X;
speaker.Y;



function [f_spk f_grid]=compareFrequency(speaker, plane)

for n=1:length (speaker.polarPattern)
    f_spk(n)=speaker.polarPattern(n).freq;
end

for n=1:length(plane.freqSlice)
    f_grid(n)=plane.freqSlice(n).f;
end

