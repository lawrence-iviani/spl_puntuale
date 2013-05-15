function dbspl=pressure2dbSPL(p)

po=20*10^(-6);%Dalla definizione di dBspl
dbspl=20*log10(abs(p)/po);
