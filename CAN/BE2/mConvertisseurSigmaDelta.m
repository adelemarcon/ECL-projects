
%%%%
% Données: 
% Nbit : nombre de bits de quantification
% L  :  ordre du filtre 
% gk :  coefficients de la réponse impulsionnelle du filtre
% R  : facteur de sur-echantillonnage


Ts = 1/nus;   % periode d'echantillonnage 

% Filtre anti-repliement
nuc = 0.95*nus/2;
ordre = 15;
[B,A] = butter(ordre,2*pi*nuc,'s');

% Surechantillonnage
TsR = Ts/R;     % periode de sur-echantillonnage (sec)
nusR = 1/TsR;     % frequence de sur-echantillonnage (Hz)

% Simulation du convertisseur Sigma-Delta
Tsim = R*TsR*round(nusR/nu0) - TsR;    % temps de simulation (sec)
sim('ConvertisseurSigmaDelta');    % lancement du schema simulink
tx = input.time;        % recuperation des donnees : vecteur temps de l'entree
x = input.data;         % recuperation des donnees : signal d'entree
txtilde = output.time;  % recuperation des donnees : vecteur temps de la sortie
xtilde = output.data;   % recuperation des donnees : signal de sortie

% Définition de xstar
xstar = x(1:R:end);

% Analyse des signaux en entrée et en sortie du convertisseur
Nx = length(tx);
nux = (-Nx/2:Nx/2-1)/(TsR*Nx);
Sx = (1/Nx)*fftshift(abs(fft(x)).^2);
Nxtilde = length(txtilde);
nuxtilde = (-Nxtilde/2:Nxtilde/2-1)/(Ts*Nxtilde);
Sxtilde = (1/Nxtilde)*fftshift(abs(fft(xtilde)).^2);

figure,
stairs(txtilde,xtilde,'b'); hold on;
plot(tx,x,'r'); hold off;
legend('sortie xtilde','entree x');
ylim([-1.5 1.5]);
grid on;
xlabel('temps (sec)');
ylabel('amplitude');
title('signaux en entrée et en sortie du convertisseur \Sigma\Delta');

figure,
plot(nuxtilde,Sxtilde/max(Sxtilde),'b',nux,Sx/max(Sx),'--r');
xlim([-1 1]*nus/2);
legend('S_{xtilde}','S_x');
xlabel('frequence (Hz)');
ylabel('Densité spectrale de puissance normalisée');
title('DSP normalisée des signaux en entrée et en sortie du convertisseur \Sigma\Delta');


