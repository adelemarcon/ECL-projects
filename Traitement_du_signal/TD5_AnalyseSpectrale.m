%----------------------------------------------------------------------%
%
% Ecole Centrale de Lyon
% STItc2 - Traitement du Signal
% Programme d'illustration pour le calcul d'un spectre par TFD
%
%----------------------------------------------------------------------%

clear all;
close all;
clc;


% Paramètres
%------------------------------------------------------------%

% Parametres du signal analogique
a = 0.1;
b = 2;
nu0 = 2.3;

% Parametres de la mesure
Ts = 0.05;  % Période d'échantillonnage (sec)
N = 1500;   % Nombre d'échantillons mesurés
Ta = N*Ts;  % Temps d'acquisition (sec)
nus = 1/Ts; % Fréquence d'échantillonnage (Hz)


% Analyse temporelle
%------------------------------------------------------------%

% Définition du signal analogique x
t = 0:10^(-5):Ta;
x = b*exp(-a*t).*sin(2*pi*nu0*t);

% Calcul des N échantillons mesurés xk
tk = 0:Ts:(N-1)*Ts;
xk = b*exp(-a*tk).*sin(2*pi*nu0*tk);

figure,
plot(t, x); hold on;
plot(tk, xk, 'x'); hold off;
grid on;
xlabel('temps (sec)');
ylabel('amplitude');
title('signal analogique x et échantillons mesurés x_k');


% Analyse fréquentielle
%------------------------------------------------------------%

% Calcul de la TFD des échantillons mesurés xk
Xn = fft(xk);	

figure 
plot([0:N-1], abs(Xn), 'x');
grid on;
xlabel('indice n');
ylabel('|X_n|');
title('TFD des échantillons mesurés x_k');


% Calcul d'une estimation discrete du spectre de x à partir des xk
Xest = Ts*[Xn(N/2+1:end), Xn(1:N/2)];
nun = [-N/2:N/2 - 1]*nus/N;

figure
plot(nun, abs(Xest));
grid on;
xlabel('fréquence (Hz)');
ylabel('|X_{est}(\nu_n)|');
title('Estimation discrete du spectre du signal analogique');

% Comparaison entre le spectre de x et son estimation discrete
nu = -nus/2:10^(-5):nus/2;
X = b/2*(1./(a+1i*2*pi*(nu-nu0))+1./(a+1i*2*pi*(nu+nu0)));

figure
plot(nu, abs(X)); hold on;
plot(nun, abs(Xest)); hold off
grid on;
xlabel('fréquence (Hz)');
ylabel('|X(\nu)| et |X_{est}(\nu_n)|');
title('Spectre du signal analogique et son estimation discrete');


