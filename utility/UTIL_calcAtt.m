function att=UTIL_calcAtt(distance)

%data una distanza in metri ritorna l'attenuazione in db calcolata secondo
%il metodo dell'inverso del quadrato.

%TODO: verificare le attenuazioni...
if (distance < 0) 
    warning('UTIL_calcAtt.m: Distance is less than 0... CHECK!');
    att=0;
else
    att=1/((distance));
end