function phaseInterp=UTIL_interpolatePhase(x, phase , index_h, index_l, x_sup, x_inf)
%dato un array di fasi inferiori e superiori calcola il risulatato
%interpolato delle fasi per il valore X.
%Determina la pendenza della retta tra i diversi estremi dei vettori ph_in
%e ph_sup e i vettori scalari x_sup e x_inf

%Unwrap phase, per poter interpolare senza i salti tra -pi e pi che
%potrebbereo creare grossi problemi
phaseUnwrap=unwrap(phase')';
ph_h=phaseUnwrap(:,index_h);
ph_l=phaseUnwrap(:,index_l);
phaseInterpUnwraped=UTIL_interpolate(x,ph_h,ph_l,x_sup,x_inf);
%ora bisogna arrotolo la fase nuovamente!!
phaseWrapped(:,:)=wrapToPi([phaseUnwrap(:,1:index_l) phaseInterpUnwraped phaseUnwrap(:,index_h:end)]);
phaseInterp=phaseWrapped(:,index_l+1);
