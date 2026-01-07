
%%%
Ts = 1/nus;     % periode d'echantillonnage (sec)
TsR = Ts/R;     % periode de sur-echantillonnage (sec)
nusR = 1/TsR;   % frequence de sur-echantillonnage (Hz)

% Simulation du modulateur Sigma-Delta 
Tsim = R*TsR*round(nusR/nu0) - TsR;    % temps de simulation (sec)
sim('ModulateurSigmaDelta');    % lancement du schema simulink
t = input.time;        % recuperation des donnees
x = input.data;         % recuperation des donnees
ytilde = output.data;   % recuperation des donnees

% Analyse des signaux 
N = length(t);
nu = (-N/2:N/2-1)/(N*TsR);
Sx = (1/N)*fftshift(abs(fft(x)).^2);
Sytilde = (1/N)*fftshift(abs(fft(ytilde)).^2);

figure,
plot(t,ytilde,'b',t,x,'r');
legend('sortie ytilde','entree x');
ylim([-1.5 1.5]);
grid on;
xlabel('temps (sec)');
ylabel('amplitude');
title('signaux en entrée et en sortie du modulateur \Sigma\Delta');

figure,
plot(nu,Sytilde,'b',nu,Sx,'--r');
xlim([-1 1]*nusR/2);
legend('S_{ytilde}','S_x');
xlabel('frequence (Hz)');
ylabel('Densité spectrale de puissance');
title('DSP des signaux en entrée et en sortie du modulateur \Sigma\Delta');
