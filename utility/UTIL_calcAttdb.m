function dbAtt=UTIL_calcAttdb(distance)

%data una distanza in metri ritorna l'attenuazione in db calcolata secondo
%il metodo dell'inverso del quadrato.

dbAtt=20*log10(distance);