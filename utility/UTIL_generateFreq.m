function freq=UTIL_generateFreq(LoF,HiF, resolution)

%Genera un array di frequenze nella banda LoF, Hif con resoluzione voluta
%LoF: frequenza inferiore della banda
%HiF: frequenza superiore della banda
%resolution: la risoluzione voluta in termini d'ottava (es 1/3 per terzi
%d'ottava


%2^n=HiF/LoF; n è il numero di ottave
nOctave=log2(HiF/LoF);
freqBin=floor(nOctave*(1/resolution));
n=0:freqBin;
freq=LoF*2.^(n*resolution);

