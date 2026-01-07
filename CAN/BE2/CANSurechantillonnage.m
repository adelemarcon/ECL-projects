%%%
% Données: 
% - nus (fréquence d'échantillonnage)
% - R (facteur de suréchantillonnage)
% - Nbits (nombre de bits de codage)
% - ecoute (booléen pour activer le son)

Ncont = length(x);
Tscont = 1/nuscont;
tcont = (0:Ncont-1)*Tscont;

% Filtre antirepliement 
nuc = 0.8*nus/2;    % frequence de coupure (Hz)
ordre = 10;         % ordre du filtre
[B,A] = butter(ordre,2*nuc/nuscont);
y = filter(B,A,x);

% Echantillonnage à Nyquist et quantification uniforme %
rse = nuscont/nus;  % facteur de sous-echantillonnage vis a vis de nuscont
Ts = 1/nus;         % periode d'echantillonnage (sec)

% echantillonnage %
xstar = y(1:rse:end);
N = length(xstar);
t = (0:N-1)*Ts;
nu = (-N/2:N/2-1)*nus/N;
Sxstar = (1/N)*fftshift(abs(fft(xstar)).^2); % estimation DSP du signal échantillonné

% Quantification uniforme %
q = 2/(2^Nbit);   % pas de quantification
ix = min(2^Nbit-1, floor((xstar-min(xstar))/q));
xtild = min(xstar)+q/2+q*ix;
% Sxtild = (1/N)*fftshift(abs(fft(xtild)).^2); % estimation DSP du signal numérisé

% erreur de quantification %
equant = xtild-xstar;
Pequant = mean(equant.^2) % puissance de l'erreur de quantification
Sequant = (1/N)*fftshift(abs(fft(equant)).^2); % estimation DSP de l'erreur de quantification

%% Sur-echantillonnage et quantification uniforme 
rse = nuscont/nusR;   % facteur de sous-echantillonnage vis a vis de nuscont
TsR = 1/nusR;         % periode de sur-échantillonnage (sec)

% echantillonnage %
xstarR = y(1:rse:end);
NR = length(xstarR);
tR = (0:NR-1)*TsR;
nuR = (-NR/2:NR/2-1)*nusR/NR;
SxstarR = (1/NR)*fftshift(abs(fft(xstarR)).^2); % estimation DSP du signal sur-échantillonné

% Quantification uniforme %
qR = 2/(2^Nbit);  % pas de quantification 
ix = min(2^Nbit-1, floor((xstarR-min(xstarR))/qR));
xtildR = min(xstarR)+qR/2+qR*ix; % signal numérique
% SxtildR = (1/NR)*fftshift(abs(fft(xtildR)).^2); % estimation DSP du signal numérisé sur-échantillonné

% erreur de quantification %
equantR = xtildR-xstarR;
PequantR = mean(equantR.^2) % puissance de l'erreur de quantification
SequantR = (1/NR)*fftshift(abs(fft(equantR)).^2); % estimation DSP de l'erreur de quantification

%  Affichage des résultats 
figure,
    plot(tR,xtildR,'-mo',t,xtild,'-b*',tcont,y,'g');
    grid on
    xlim([t(1) t(end)]);
    xlabel('temps (sec)');
    ylabel('amplitude');
    legend('signal numérique surechantillonne','signal numérique','signal analogique')
    title('Représentation temporelle - signal analogique et signaux numériques');

figure,    
    plot(nuR,SxstarR,'--m',nu,Sxstar,'b');
    xlabel('frequence (Hz)');
    ylabel('Estimation densité spectrale de puissance');
    legend('signal sur-échantillonné','signal échantillonné')
    title('DSP - signaux échantillonné et sur-échantilllonné')

figure,
    plot(nuR,SequantR,'m',nu,Sequant,'b');
    ylabel('Estimation densité spectrale de puissance');
    legend('signal sur-échantillonné','signal échantillonné')
    xlabel('frequence (Hz)');
    title('DSP - erreurs de quantification');
