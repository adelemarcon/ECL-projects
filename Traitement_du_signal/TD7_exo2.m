clear all;
close all;
clc;

Ts = 1/2;

% question 1
% Représentation de réalisations temporelles du signal aléatoire bruit
N = 10000;
bk  = randn(N,1);    % vecteur de N échantillons "pseudo"aléatoires 
                     % suivant une loi gausienne, moyenne 0, variance 1
figure(1), plot( (0:(N-1))*Ts, bk, '-xb' );
axis([0 N*Ts -6 6]);

return
% question 2
% Représentation des échantillons de l'autocorrélation du bruit
Rbk = xcorr(bk, 'biased');
figure(2), stem( (-N+1):(N-1), Rbk, '.b' );
axis([-N N -0.5 1.5]);

% Représentation de le la moyenne des échantillons de l'autocorrélation 
% du bruit
M = 100;
Rbkiter = zeros(2*N-1,1);	
for i = 1:M
   bk = randn(N,1);
   Rbkiter = Rbkiter + xcorr(bk, 'biased');
end
RbkM = 1/M * Rbkiter;
figure(3), stem( (-N+1):(N-1), RbkM, '.g' );
axis([-N N -0.5 1.5]);

return
% question 3
% calcul et représentation de la DSP 
% à partir de l'autocorrélation d'une réalisation

% a compléter

% à partir de la moyenne des autocorrélations de M réalisations

% a compléter


return

% question 4
% représentation des réponses bruit/fréquentielle de Fd
% Parametre de la fonction de transfert discrete
a  = 0.1;
w0 = 0.6;
yk = filter([1 0 0], [1, -2*exp(-a*Ts)*cos(w0*Ts), exp(-2*a*Ts)], bk);
figure(6), plot(yk, 'xm');
ylim([-40 40]);

[H, F] = freqz(1, [1, -2*exp(-a*Ts)*cos(w0*Ts), exp(-2*a*Ts) ], 1000, 1/Ts);
figure(7), plot(F, abs(H).^2);

% représentation de la DSP de la sortie de Fd pour entrée
% bruit blanc
Ryk = xcorr(yk, 'biased');
Syk = fft(Ryk);
figure(8), plot( (0:(N-1))/(2*N-1)/Ts, abs(Syk(1:(N))), '.m' );

% Représentation de le la moyenne des DSP
Rykiter = zeros(2*N-1,1);	
for i = 1:M
   bk      = randn(N,1);
   yk      = filter(1, [1, -2*exp(-a*Ts)*cos(w0*Ts), exp(-2*a*Ts) ], bk);
   Rykiter = Rykiter + xcorr(yk, 'biased');
end
RykM = 1/M * Rykiter;
SykM = fft(RykM);
figure(9), plot( (0:(N-1))/(2*N-1)/Ts, abs(SykM(1:(N))), '.g');

