
clear all;
close all;
clc;

% Paramètres
%------------------------------------------------------------%

% Parametres du signal continu
a  = 0.1;
b  = 2;
nu0 = 2.1;

% Parametres du signal discret
Ts = 0.02;  % Période d'échantillonnage
N  = 2500;  % Nombre d'échantillons mesurés
Ta = N*Ts;  % Temps d'acquisition
nus = 1/Ts; % Fréquence d'échantillonnage


% question 4
%------------------------------------------------------------%

% Calcul de N échantillons yk d'après l'expression analytique
tk = 0:Ts:(N-1)*Ts; % vecteur des temps discrets
yk = b*exp(-a*tk).*sin(2*pi*nu0*(tk+Ts));

% Calcul de N échantillons ykrec d'après l'équation de récurrence
a1 = -2*exp(-a*Ts)*cos(2*pi*nu0*Ts);
a2 = exp(-2*a*Ts);
b0 = b*sin(2*pi*nu0*Ts);  
ykrec(1) = b0; % initialisation des 2 premières valeurs
ykrec(2) = -a1*ykrec(1);
for k = 3:N
  ykrec(k) = -a1*ykrec(k-1) -a2*ykrec(k-2);
end

% Comparaison des échantillons obtenus
figure,
plot(tk, yk, '-b.', tk, ykrec, 'or');
grid on
xlabel('temps');
title('échantillons temporels');
legend('y_k - expression analytique','y_{krec} - équation de récurrence');


% question 5
%------------------------------------------------------------%

Yn = fft(yk);	
nu = -nus/2:10^(-5):nus/2;

% Calcul d'une estimation discrete du spectre de y à partir des yk
Yest = Ts*[Yn(N/2+1:end), Yn(1:N/2)];
nun = [-N/2:N/2 - 1]*nus/N;

figure
plot(nun, abs(Yest));
grid on;
xlabel('fréquence (Hz)');
ylabel('|Y_{est}(\nu_n)|');
title('Estimation discrete du spectre du signal analogique');

% question 7
%------------------------------------------------------------%

% Coefficients de la fonction de transfert F
% à compléter
B = [b*sin(2*pi*nu0*Ts)]  % coefficients du numérateur de F
A = [1,-2*exp(-a*Ts)*cos(2*pi*nu0*Ts),exp(-2*a*Ts)]  % coefficients du dénominateur F

% Calcul et tracé de la réponse fréquentielle H*
H = freqz(B, A, nu, 1/Ts);
figure,
plot(nu, abs(H), 'r'); hold on;
plot(nun, abs(Yest)/Ts); hold off;
grid on
ylim([0 600]);
xlabel('fréquence');
ylabel('|H*(nu)|');
title('réponse fréquentielle du filtre lié à l''équation de récurrence');

return
% question 9
%------------------------------------------------------------%

% Identification des paramètres du filtre à partir des N échantillons yk
na = 0;     % ordre de fonction de transfert à choisir
[b0yw,Ayw] = myaryule(yk, na, 'det');

% Calcul et tracé de la réponse fréquentielle obtenue Hyw*
Hyw = freqz(b0yw, Ayw, nu, 1/Ts);
figure, 
plot(nu, abs(Hyw), 'm');
grid on
ylim([0 600]);
xlabel('fréquence');
ylabel('|Hyw*(nu)|');
title('réponse fréquentielle du filtre générateur identifié par la méthode de YW');


return
%%
% Un nouveau signal !
%------------------------------------------------------------%

clear all;
close all;
clc;

load yk2data.mat
N = length(yk);
Ts = 0.1;  % Période d'échantillonnage
nus = 1/Ts;  % Fréquence d'échantillonnage

% à vous de jouer !


