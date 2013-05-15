function y=UTIL_interpolate(x, y_sup, y_inf, x_sup, x_inf)
%dato un array di fasi inferiori e superiori calcola il risulatato
%interpolato delle fasi per il valore X.
%Determina la pendenza della retta tra i diversi estremi dei vettori ph_in
%e ph_sup e i vettori scalari x_sup e x_inf

%TODO: è un casino se passa da -180 a 180, i conti verrebbero sbagliati.
%bisogna per forza di cose srotolarla e riarottolarla... sbatti...

m=((y_sup-y_inf)./(x_sup-x_inf));
q=y_inf-x_inf*m;
y=x*m+q;
