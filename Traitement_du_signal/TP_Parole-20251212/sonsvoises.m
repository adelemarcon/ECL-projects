load /home/adele/ECL-projects/Traitement_du_signal/TP_Parole-20251212/aaa_bob.mat % mettre le nom de votre fichier

N = 2*floor (length(yk)/2); % taille du signal (ech) (multiple de 2)
yk = yk(1:N); % troncature du signal à N échantillons
yk = yk/max(abs(yk)); % normalisation en amplitude

nus = 16000; % fréquence d'échantillonnage (Hz)
Ts = 1/nus ; % période d'échantillonnage (sec)

T = linspace(0,N*Ts,N);

figure(1);
plot(T, yk);
xlabel('Temps (s)');
ylabel('y*');
title('Signal y*');
grid on;

Yn = abs(fft(yk))';
nun = [-N/2:N/2 - 1]*nus/N;
Yest = Ts*[Yn(N/2+1:end) Yn(1:N/2)];

figure(2);
plot(nun,Yest);
xlabel('Fréquence (Hz)');
ylabel('fft(yk)');
title('Transformée de Fourier');
grid on;

figure(3);
semilogy(nun,Yest);
xlabel('Fréquence (Hz)');
ylabel('fft(yk)');
title('Transformée de Fourier - logarithmique');
grid on;

T0 = 1/84;
N0 = floor(T0/Ts);
n1 = 200;
ym = yk(n1:n1+N0-1);

T1 = linspace(0,T0,N0);
Yn1 = abs(fft(ym))';
nun1 = [-N0/2:N0/2 - 1]*nus/N0;
Yest1 = Ts*[Yn1(N0/2+1:end) Yn1(1:N0/2)];

figure(4);
plot(T1, ym);
xlabel('Temps (s)');
ylabel('y*');
title('Fonction motif ym*');
grid on;

figure(5);
plot(nun1,Yest1);
xlabel('Fréquence (Hz)');
ylabel('fft(ym)');
title('Transformée de Fourier de la fonction motif');
grid on;

figure(6);
semilogy(nun1,Yest1);
xlabel('Fréquence (Hz)');
ylabel('fft(yk)');
title('Transformée de Fourier de la fonction motif - logarithmique');
grid on;
%%
sound(yk,nus)
%%
figure(7)

na = 8;

[b0,a] = myaryule(ym,na,'det')
roots(a)
freqz(b0,a,nun1,nus);
hold on;

plot(nun1/1000,(log(Yest1)+10)*7.5);
grid on;
hold off;

title('Réponse fréquentielle du filtre générateur');

%%

Ta = 2;
N2 = Ta/Ts;

tk = 0:Ts:(N-1)*Ts;
xk = zeros(1, N);
N0 = round(T0 / Ts);
for k = 1:N0:N
    xk(k) = 1;
end

ysynth = filter(b0,a,xk);

figure(8)
plot(tk, ysynth);
hold on;
xlabel('Temps (s)');
ylabel('Signal synthétisé ysynth');
title('Signal Synthétisé');
grid on;

plot(T, yk);
legend('synth','réel')

hold off;

Ynsynth = abs(fft(ysynth))';
nun2 = [-N2/2:N2/2 - 1]*nus/N2;
Yest_synth = Ts*[Ynsynth(N2/2+1:end); Ynsynth(1:N2/2)];

figure(9);
plot(nun2,Yest_synth);
hold on;
xlabel('Fréquence (Hz)');
ylabel('fft(yk)');
title('Transformée de Fourier');
grid on;

plot(nun,Yest);
legend('synth','réel')

hold off;

%%
sound(ysynth,nus)

%%
Tw = 0.03; % durée de la fenêtre d analyse (sec)
Nw = 3*round(Tw/Ts/3) ; % taille de la fenetre (ech) ( multiple de 3)

figure(10)
subplot(1,2,1)
spectrogram(yk ,Nw,Nw/3,2*Nw,nus,'yaxis');
subplot(1,2,2)
spectrogram(ysynth ,Nw,Nw/3,2*Nw,nus,'yaxis');

%%

Tw_analyse = 0.03; % 30 msec - durée de la fenêtre d'analyse
decalage = 0.01; % 10 msec - décalage entre fenêtres
Nw_analyse = round(Tw_analyse / Ts); % Nombre d'échantillons par fenêtre
Ndecalage = round(decalage / Ts); % Décalage en échantillons
fenetre_hanning = hanning(Nw_analyse); % fenetre de Hanning
ysynt_tv = zeros(1, N); %initialise le vecteur tempsvariant
% Boucle
debut = 1;
while debut + Nw_analyse - 1 <= N % principe de construction spectrogramme
   segment = yk(debut : debut + Nw_analyse - 1);
  
   segment_fenetre = segment(:) .* fenetre_hanning;
  
   [b0_local, a_local] = myaryule(segment_fenetre, na, 'det');
  
   xk_local = zeros(Nw_analyse, 1);
   indices_imp = 1:N0:Nw_analyse;
   xk_local(indices_imp) = 1;
  
   segment_synt = filter(b0_local, a_local, xk_local);
  
   segment_synt = segment_synt .* fenetre_hanning;
  
   ysynt_tv(debut : debut + Nw_analyse - 1) = ...
       ysynt_tv(debut : debut + Nw_analyse - 1) + segment_synt';
  
   debut = debut + Ndecalage;
end
ysynt_tv = ysynt_tv / max(abs(ysynt_tv)); % normalisation
figure(11)
subplot(1,3,1)
yk_col = yk(:);
spectrogram(yk_col, Nw, Nw/3, 2*Nw, nus, 'yaxis');
title('Spectrogramme du signal original');
subplot(1,3,3)
ysynt_tv_col = ysynt_tv(:);
spectrogram(ysynt_tv_col, Nw, Nw/3, 2*Nw, nus, 'yaxis');
title('Spectrogramme - Synthèse temps-variant (fenêtre 30ms, décalage 10ms)');

subplot(1,3,2)
spectrogram(ysynth ,Nw,Nw/3,2*Nw,nus,'yaxis');