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
% Question 1 : analyse du signal ECG dans le domaine temporel

load data
ystar = y;

N = length(ystar);      % taille du signal
Ta = 20;                % durée de l'enregistrement
Ts = Ta/N ;             % Période d'échantillonage
nus = 1/Ts;             % Fréquence d'échantillonage

T = linspace(0,Ta,N);   % Création de l'axe du temps

figure(1);
plot(T, ystar);
xlabel('Temps (s)');
ylabel('y*');
title('Signal mesuré y');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2 : analyse du signal ECG dans le domaine fréquentiel

nun = [-N/2:N/2 - 1]*nus/N;         % Plage de fréquence

alpha = 0.54;
tprime = (T-Ta/2)/Ta;
whamming = (abs(tprime)<1/2).*(alpha+(1-alpha)*cos(2*pi*tprime)); % fenêtre de Hamming
yTaHamming = ystar.*whamming;  % application de la fenêtre de Hamming au signal mesuré

YTaHamming = abs(fft(yTaHamming)); % Calcul du module de la TF du signal analogique y après fenêtrage
Yest = Ts*[YTaHamming(N/2+1:end) YTaHamming(1:N/2)]; % Reconstruction du module de la TF du signal y

figure(2)
plot(nun,Yest);
xlabel('fréquence (Hz)');
ylabel('|Y_{est}(\nu_n)|');
grid on;
title('Éstimation discrete du spectre du signal analogique avec fenêtrage temporel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 3/4 : analyse du signal bruit seul

load bruit
bstar = b;

B = abs(fft(bstar)); % Calcul du module de la TF du signal aléatoire b échantilloné
Best = Ts*[B(N/2+1:end) B(1:N/2)]; % Reconstruction du module de la TF du signal b

Sb = (Best.^2)/Ts; % Calcul de la densité spectrale de puissance du signal b à partir de celle de bstar
figure(3)
plot(nun,Sb);
xlabel('fréquence (Hz)');
ylabel('Sb(\nu)');
grid on;
title('Densité spectrale de puissance du bruit b');

fprintf('\n------Réponse à la Question 5------\n')
fprintf('Ces représentations temporelles et fréquentielles permettent de voir que le bruit b a un impact plutôt dans les hautes fréquences sur le signal y\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 5/6: interpolation et écoute du signal mesuré

M = 6;      % facteur d'interpolation
nusM = M*nus;
nunM = [-N*M/2:N*M/2 - 1]*nusM/(N*M); % Nouveau vecteur de fréquence pour le signal interpolé
Yn = fft(y);
YMstar = M*[Yn(1:N/2), zeros(1,(M-1)*N), Yn(N/2+1:N)];
yMstar = ifft(YMstar);
t = [0:M*N-1]*Ts/M;

figure(4)
plot(T,ystar);
hold on;
plot(t, yMstar);
xlabel('Temps (s)');
ylabel('y');
title('Signal y, interpolé et non interpolé');
legend('y*','yM*')
grid on;
hold off;

ReyM = real(yMstar);
sound(ReyM,nusM)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Partie II : Filtrage fréquentiel et diagnostic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 7/8: conception filtre RIF-PL par échantillonnage fréquentiel
fprintf('\n------Réponse à la Question 7------\n')
fprintf('On va choisir d''appliquer un filtre passe-bas pour extraire le signal x en éliminant b\n')

fc = 40;                    % Choix de la fréquence de coupure
tg = 0.05;                  % Choix d'un temps de groupe < 0,2s
Nh = round(2*tg/Ts) + 1;    % Calcul de l'ordre du filtre à partir du temps de groupe fixé (choix d'un entier) = nombre d"échantillons fréquentiels

n = 0:Nh-1;
nu_n = n./(Nh*Ts);

% Calcul des Nh échantillons fréquentiels de la réponse fréquentielle du filtre désiré
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

hk = ifft(Hn_complex,Nh); % Calcul des Nh échantillons temporels de la réponse impulsionelle du filtre
hk = real(hk);

[H_filter,f_filter] = freqz(hk,1,N,nus); % Conception finale du filtre RIF-PL

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 9: application du filtre et visualisation du résultat
z = conv(y,hk,'same');
Z = abs(fft(z));
Zest = Ts*[0,flip(Z(2:end)),Z];

figure(5)
% Signal original et filtré (domaine temporel)
subplot(2,1,1);
plot(T, ystar);
hold on;
plot(T, z);
grid on;
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal original vs filtré - représentation temporelle');
legend('Signal original', 'Signal filtré');

% Spectres des signaux
subplot(2,1,2);
nun2 = [-N:N - 1]*nus/N;
plot(nun, Yest);
hold on;
plot(nun2, Zest);
plot([fc fc], [0 max(Yest)], 'k--', 'LineWidth', 1.5);
plot([-fc -fc], [0 max(Yest)], 'k--', 'LineWidth', 1.5);
grid on;
xlabel('Fréquence (Hz)');
ylabel('Module');
title('Signal original vs filtré - représentation fréquentielle');
legend('Signal original', 'Signal filtré', sprintf('fc = %d Hz', fc));
xlim([-nus/2 nus/2]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 10: interpolation du signal filtré

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
title('Signal débruité - représentation temorelle');
legend('z: non interpolé','z_{M}')
grid on;
hold off;

RezM = real(zM);
sound(RezM,nusM2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 11/12 : Etude de l'intervalle RT
% detection des R par max sur un intervalle de taille T0 (= periode fondamentale)
% et détection des T par le max suivant dans l'intervalle R+[0.1;0.4]sec
fprintf('\n------Réponse à la Question 11------\n')
fprintf('On récupère la fréquence fondamentale en observant la réponse fréquentielle du signal y \nHypothèse: fréquence constante \n')

nu0 = 1.28;              % battements par seconde (frequence fondamentale en Hz)
T0 = 1/nu0;             % secondes par battement (periode fondamentale en sec)
N0 = round(T0/(Ts/M));  % echantillons par periode fondamentale (sur signaux M-interpolés)

% Calcul pour le signal y interpolé
yM = yMstar;
for i=0:24
    [maxi,TofR(i+1)] = max(yM(N0*i+1:N0*i+N0));
    [maxi,TofT(i+1)] = max(yM(N0*i+1+TofR(i+1)+round(M*nus*0.1):N0*i+1+TofR(i+1)+round(M*nus*0.4)));
    TofT(i+1) = TofT(i+1)+TofR(i+1)+round(M*nus*0.1);
end
sequenceRTy = (TofT-TofR)*(Ts/M);

% Calcul pour le signal z interpolé
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
ylabel('Durée de l''intervalle RT');
title('Diagnostic RT');
legend('Signal mesuré interpolé', 'Signal débruité interpolé');
hold off;

m1 = mean(sequenceRTy);
s1 = std(sequenceRTy);
m2 = mean(sequenceRTz);
s2 = std(sequenceRTz);

fprintf('\n------Réponse à la Question 12------\n')
fprintf('Signal mesuré interpolé: moyenne = %d, écart-type = %d\n', m1,s1);
fprintf('Signal débruité interpolé: moyenne = %d, écart-type = %d\n', m2,s2);
fprintf('Le débruitage permet d''écarter certaines valeurs abérrantes et donc de réduire l''écart-type\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 13: Etude du rythme cardiaque
signal = y;

min_distance = 0.1;  % Distance minimale entre pics (secondes)
min_height = 0.7 * max(signal);  % Hauteur minimale

[pks, locs] = findpeaks(signal,'MinPeakDistance', round(min_distance * nus),'MinPeakHeight', min_height);
temps_pics = locs / nus;
intervalles_RR = diff(temps_pics);
freq_cardiaque_y = 1 ./ intervalles_RR;
freq_cardiaque_bpm_y = 60 ./ intervalles_RR;

freq_moyenne_y = mean(freq_cardiaque_bpm_y);
freq_std_y = std(freq_cardiaque_bpm_y);

signal = z;

min_distance = 0.1;  % Distance minimale entre pics (secondes)
min_height = 0.7 * max(signal);  % Hauteur minimale

[pks, locs] = findpeaks(signal,'MinPeakDistance', round(min_distance * nus),'MinPeakHeight', min_height);
temps_pics = locs / nus;
intervalles_RR = diff(temps_pics);
freq_cardiaque_z = 1 ./ intervalles_RR;
freq_cardiaque_bpm_z = 60 ./ intervalles_RR;

freq_moyenne_z = mean(freq_cardiaque_bpm_z);
freq_std_z = std(freq_cardiaque_bpm_z);


k = [1:length(freq_cardiaque_y)];

figure(8)
subplot(211)
plot(k,freq_cardiaque_bpm_y, 'r', 'LineWidth', 1.5);
hold on;
plot(k,freq_cardiaque_bpm_z, 'b--', 'LineWidth', 1.5);
grid on;
xlabel('Indice de la fréquence cardiaque mesurée');
ylabel('Fréquence cardiaque en bpm');
title('Mesure de la fréquence cardiaque en direct');
legend('Signal mesuré', 'Signal débruité');
hold off;

subplot(212)
plot(k,freq_cardiaque_y, 'r', 'LineWidth', 1.5);
hold on;
plot(k,freq_cardiaque_z, 'b--', 'LineWidth', 1.5);
grid on;
xlabel('Indice de la fréquence cardiaque mesurée');
ylabel('Fréquence cardiaque en Hz');
title('Mesure de la fréquence cardiaque en direct');
legend('Signal mesuré', 'Signal débruité');
hold off;

fprintf('\n ------Réponse à la Question 13------ \n')
fprintf('Signal mesuré: moyenne = %d, écart-type = %d\n', freq_moyenne_y,freq_std_y);
fprintf('Signal débruité: moyenne = %d, écart-type = %d\n', freq_moyenne_z,freq_std_z);
fprintf('L''opération de débruitage ici n''a pas d''intérêt car la méthode choisie utilise le pic pricipal de battement, correspondant au complexe QRS. Ce complexe QRS n''est que très peu influencé par le bruit')