%
% Ecole Centrale de Lyon
% STItc2 - Traitement du Signal
%
% Autonomie : Traitement des signaux ECG
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Nom : Marcon
% Prénom : Adèle
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Partie I : Analyse du signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : analyse du signal ECG dans le domaine temporel

load data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : analyse du signal ECG dans le domaine fréquentiel

% Question 1
N =length(y);      % taille du signal
Ta = 20;             % durée de l'enregistrement
Ts = Ta/N ;          % Période d'échantillonage
nus = 1/Ts;          % Fréquence d'échantillonage

T = linspace(0,Ta,N);

figure(1);
plot(T, y);
xlabel('Temps (s)');
ylabel('yk');
title('Signal yk');
grid on;

% Question 2
Y = abs(fft(y));
nun = [-N/2:N/2 - 1]*nus/N;
Yest = Ts*[Y(N/2+1:end) Y(1:N/2)];

alpha = 0.54;
tprime = (T-Ta/2)/Ta;
whamming = (abs(tprime)<1/2).*(alpha+(1-alpha)*cos(2*pi*tprime)); % fenêtre de Hamming
yTaHamming = y.*whamming;  % application de la fenêtre de Hamming au signal mesuré

YTaHamming = abs(fft(yTaHamming));
Yest1 = Ts*[YTaHamming(N/2+1:end) YTaHamming(1:N/2)];

figure(2)
plot(nun,Yest);
hold on;
plot(nun, Yest1);

xlabel('fréquence (Hz)');
ylabel('|Y_{est}(\nu_n)|');
grid on;
title('Estimation discrete du spectre du signal analogique');
legend('Y_{est}','Y_{est1}')
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : analyse du signal bruit seul

load bruit

% Question 3
B = abs(fft(b));
Best = Ts*[B(N/2+1:end) B(1:N/2)];

Sb = Best.^2;
figure(3)
plot(nun,Sb);
xlabel('fréquence (Hz)');
ylabel('Sb(nu)');
grid on;
title('Densité spectrale d''énergie du bruit');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : interpolation et écoute du signal mesuré

M = 6;      % facteur d'interpolation
nusM = M*nus;
nunM = [-N*M/2:N*M/2 - 1]*nusM/(N*M);
Yn = fft(y);
YM = M*[Yn(1:N/2), zeros(1,(M-1)*N), Yn(N/2+1:N)];
yM = ifft(YM);
t = [0:M*N-1]*Ts/M;

figure(4)
plot(T,y);
hold on;
plot(t, yM);
xlabel('Temps (s)');
ylabel('yk');
title('Signal yk');
legend('y','yM')
grid on;
hold off;

ReyM = real(yM);
sound(ReyM,nusM)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Partie II : Filtrage fréquentiel et diagnostic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : conception filtre RIF-PL par échantillonnage fréquentiel

fc = 40;
tg = 0.05;
Nh = round(2*tg/Ts) + 1;

n = 0:Nh-1;
nu_n = n./(Nh*Ts);

Hn = zeros(1,Nh);
for i = 1:Nh
    if nu_n(i) <= fc
        Hn(i) = 1;
    else
        Hn(i) = 0;
    end
end

phase = -2*pi*nu_n*(Nh-1)*Ts/2;
Hn_complex = Hn.*exp(1j*phase);

hk = ifft(Hn_complex,Nh);
hk = real(hk);

[H_filter,f_filter] = freqz(hk,1,N,nus);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : application du filtre et visualisation du résultat
z = conv(y,hk,'same');
Z = abs(fft(z));
Zest = Ts*[0,flip(Z(2:end)),Z];

figure(5)
% Signal original et filtré (domaine temporel)
subplot(2,1,1);
plot(T, y, 'b', 'LineWidth', 1);
hold on;
plot(T, z, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal original vs filtré');
legend('Signal original', 'Signal filtré');

% Spectres des signaux
subplot(2,1,2);
nun2 = [-N:N - 1]*nus/N;
plot(nun, Yest, 'b', 'LineWidth', 1);
hold on;
plot(nun2, Zest, 'r', 'LineWidth', 1.5);
plot([fc fc], [0 max(Yest)], 'k--', 'LineWidth', 1.5);
plot([-fc -fc], [0 max(Yest)], 'k--', 'LineWidth', 1.5);
grid on;
xlabel('Fréquence (Hz)');
ylabel('Magnitude (dB)');
title('Spectres : original vs filtré');
legend('Signal original', 'Signal filtré', sprintf('fc = %d Hz', fc));
xlim([-nus/2 nus/2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : interpolation du signal filtré
M2 = 6;      % facteur d'interpolation
nusM2 = M2*nus;
nunM2 = [-N*M2/2:N*M2/2 - 1]*nusM2/(N*M2);
Zn = fft(z);
Zn = [Zn,flip(Zn)];
ZM = M*[Zn(1:N/2), zeros(1,(M2-1)*N), Zn(N/2+1:N)];
zM = ifft(ZM);
t = [0:M2*N-1]*Ts/M2;

figure(6)
plot(T,z);
hold on;
plot(t, zM);
xlabel('Temps (s)');
ylabel('yk');
title('Signal z');
legend('z','zmstar')
grid on;
hold off;

RezM = real(zM);
%sound(Rezmstar,nusM)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : Etude de l'intervalle RT
% detection des R par max sur un intervalle de taille T0 (= periode fondamentale)
% et détection des T par le max suivant dans l'intervalle R+[0.1;0.4]sec

nu0 = 1.3;       % battements par seconde (frequence fondamentale en Hz)
T0 = 1/nu0;             % secondes par battement (periode fondamentale en sec)
N0 = round(T0/(Ts/M));  % echantillons par periode fondamentale (sur signaux M-interpolés)
for i=0:24
    [maxi,TofR(i+1)] = max(yM(N0*i+1:N0*i+N0));
    [maxi,TofT(i+1)] = max(yM(N0*i+1+TofR(i+1)+round(M*nus*0.1):N0*i+1+TofR(i+1)+round(M*nus*0.4)));
    TofT(i+1) = TofT(i+1)+TofR(i+1)+round(M*nus*0.1);
end
sequenceRTy = (TofT-TofR)*(Ts/M);

for i=0:24
    [maxi,TofR(i+1)] = max(zM(N0*i+1:N0*i+N0));
    [maxi,TofT(i+1)] = max(zM(N0*i+1+TofR(i+1)+round(M*nus*0.1):N0*i+1+TofR(i+1)+round(M*nus*0.4)));
    TofT(i+1) = TofT(i+1)+TofR(i+1)+round(M*nus*0.1);
end
sequenceRTz = (TofT-TofR)*(Ts/M);

k = [1:25];

figure(7)
plot(k,sequenceRTy, 'r', 'LineWidth', 1.5);
hold on;
plot(k,sequenceRTz, 'b--', 'LineWidth', 1.5);
grid on;
xlabel('Numéro de Battement');
ylabel('Durée séparat R-T');
title('Diagnostic RT');
legend('Signal mesuré interpolé', 'Signal débruité interpolé');
hold off;

m1 = mean(sequenceRTy);
s1 = std(sequenceRTy);
m2 = mean(sequenceRTz);
s2 = std(sequenceRTz);

fprintf('\n --- Résultats--- \n')
fprintf('Signal mesuré interpolé: moyenne = %d, écart-type = %d\n', m1,s1);
fprintf('Signal débruité interpolé: moyenne = %d, écart-type = %d\n', m2,s2);
fprintf('Le débruitage permet d''écarter certaines valeurs abérrantes et donc de réduire l''écart-type\n')

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% question : Etude du rythme cardiaque
signal = y;
Fs = nus;

min_distance = 1;  % Distance minimale entre pics (secondes)
min_height = 0.7 * max(signal);  % Hauteur minimale = 50% du max

[pks, locs] = findpeaks(signal,'MinPeakDistance', round(0.4 * Fs),'MinPeakHeight', 0.5 * max(signal));
temps_pics = locs / Fs;
intervalles_RR = diff(temps_pics);
freq_cardiaque_y = 1 ./ intervalles_RR;
freq_cardiaque_bpm_y = 60 ./ intervalles_RR;

freq_moyenne_y = mean(freq_cardiaque_bpm);
freq_std_y = std(freq_cardiaque_bpm);


signal = z;
Fs = nus;

min_distance = 1;  % Distance minimale entre pics (secondes)
min_height = 0.7 * max(signal);  % Hauteur minimale = 50% du max

[pks, locs] = findpeaks(signal,'MinPeakDistance', round(0.4 * Fs),'MinPeakHeight', 0.5 * max(signal));
temps_pics = locs / Fs;
intervalles_RR = diff(temps_pics);
freq_cardiaque_z = 1 ./ intervalles_RR;
freq_cardiaque_bpm_z = 60 ./ intervalles_RR;

freq_moyenne_z = mean(freq_cardiaque_bpm);
freq_std_z = std(freq_cardiaque_bpm);


k = [1:length(freq_cardiaque_y)];

figure(8)
plot(k,freq_cardiaque_bpm_y, 'r', 'LineWidth', 1.5);
hold on;
plot(k,freq_cardiaque_bpm_z, 'b--', 'LineWidth', 1.5);
grid on;
xlabel('indice de la fréquence cardiaque mesurée');
ylabel('Fréquence cardiaque');
title('Mesure de la fréquence cardiaque en direct');
legend('Signal mesuré', 'Signal débruité');
hold off;

fprintf('\n --- Résultats--- \n')
fprintf('Signal mesuré: moyenne = %d, écart-type = %d\n', freq_moyenne_y,freq_std_y);
fprintf('Signal débruité: moyenne = %d, écart-type = %d\n', freq_moyenne_z,freq_std_z);













