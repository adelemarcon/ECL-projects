clear all
close all
data = readtable('/home/adele/ECL-projects/Matlab/Stat/temperatures.txt');
temperature = data.Temperature;
latitude = data.Latitude;
longitude = data.Longitude;

% Question 1

figure(1);
scatter(latitude, temperature, 'filled');
hold on;
xlabel('Latitude (°N)');
ylabel('Température (°C)');
title('Température moyenne vs Latitude');
grid on;

% Question 2

n = length(latitude);
X = [ones(n,1), latitude];
beta = X \ temperature;
b0 = beta(1);
b1 = beta(2);

% Qestion 3

fprintf('\n=== 2-3. MODÈLE ET PARAMÈTRES ===\n');
fprintf('Modèle : Température = β₀ + β₁ × Latitude + ε\n');
fprintf('β̂₀ = %.4f\n', b0);
fprintf('β̂₁ = %.4f\n', b1);
fprintf('Équation : Ŷ = %.4f + (%.4f) × Latitude\n', b0, b1);

% Question 4

lat_range = linspace(min(latitude), max(latitude), 100);
temp_pred_line = b0 + b1 * lat_range;
plot(lat_range, temp_pred_line);
legend('Données', 'Régression');

% Question 5

y_pred = X * beta;
SSres = sum((temperature - y_pred).^2);
SStot = sum((temperature - mean(temperature)).^2);
R2 = 1 - SSres/SStot;

fprintf('\n=== 5. VARIANCE EXPLIQUÉE ===\n');
fprintf('R² = %.4f (%.2f%%)\n', R2, R2*100);

% Question 6

alpha = 0.05;

s2 = SSres / (n-2);  % Variance résiduelle
s_beta1 = sqrt(s2 / sum((latitude - mean(latitude)).^2));
t_stat = b1 / s_beta1;
t_critical = tinv(1-alpha/2, n-2);  % t_{0.025, 32}
p_value = 2*(1 - tcdf(abs(t_stat), n-2));

fprintf('\n=== 6. TEST DE SIGNIFICATIVITÉ ===\n');
fprintf('H₀ : β₁ = 0  vs  H₁ : β₁ ≠ 0\n');
fprintf('Statistique t = %.4f\n', t_stat);
fprintf('Valeur critique t_{0.025,%d} = %.4f\n', n-2, t_critical);
fprintf('p-value = %.4e\n', p_value);
if abs(t_stat) > t_critical
    fprintf('Conclusion : On REJETTE H₀ (α=0.05). Effet significatif.\n');
else
    fprintf('Conclusion : On ne peut pas rejeter H₀.\n');
end

% Question 7

lat_zurich = 47.2;
temp_zurich_obs = 8.7;  % Température observée

% Prédiction ponctuelle
temp_pred_zurich = b0 + b1 * lat_zurich;

% Intervalle de confiance à 95%
se_conf = sqrt(s2 * (1/n + (lat_zurich - mean(latitude))^2 / sum((latitude - mean(latitude)).^2)));
IC_lower = temp_pred_zurich - t_critical * se_conf;
IC_upper = temp_pred_zurich + t_critical * se_conf;

% Intervalle de prédiction à 95%
se_pred = sqrt(s2 + se_conf^2);
IP_lower = temp_pred_zurich - t_critical * se_pred;
IP_upper = temp_pred_zurich + t_critical * se_pred;

fprintf('\n=== 7-8. PRÉDICTION POUR ZURICH (47.2°N) ===\n');
fprintf('Température prédite : %.2f°C\n', temp_pred_zurich);
fprintf('IC₉₅%% : [%.2f ; %.2f]°C\n', IC_lower, IC_upper);
fprintf('IP₉₅%% : [%.2f ; %.2f]°C\n', IP_lower, IP_upper);
fprintf('\nTempérature observée : %.1f°C\n', temp_zurich_obs);
fprintf('Erreur de prédiction : %.2f°C\n', abs(temp_zurich_obs - temp_pred_zurich));
if temp_zurich_obs >= IP_lower && temp_zurich_obs <= IP_upper
    fprintf('✓ La prédiction était BONNE (dans l''IP)\n');
else
    fprintf('✗ La prédiction était hors de l''IP\n');
end

model = 'Temperature ~ Latitude'
model_T = fitlm(data,model)
x0 = 47.2
x0 = data(x0,'Variable Normes',{'Latitude'})
[y_pred,IC] = product(model_T,x0,'production','observation')


fprintf('\n=== 9. AJOUT DE LA LONGITUDE ===\n');
X_multi = [ones(n,1), latitude, longitude];
beta_multi = X_multi \ temperature;
y_pred_multi = X_multi * beta_multi;
SSres_multi = sum((temperature - y_pred_multi).^2);
R2_multi = 1 - SSres_multi/SStot;

% Test pour β₂
s2_multi = SSres_multi / (n-3);
C = inv(X_multi' * X_multi);
s_beta2 = sqrt(s2_multi * C(3,3));
t_stat_longitude = beta_multi(3) / s_beta2;
p_value_longitude = 2*(1 - tcdf(abs(t_stat_longitude), n-3));

fprintf('Modèle : Temp = β₀ + β₁×Lat + β₂×Long + ε\n');
fprintf('β̂₂ (longitude) = %.4f\n', beta_multi(3));
fprintf('R² = %.4f (avant : %.4f)\n', R2_multi, R2);
fprintf('Test H₀:β₂=0  →  t = %.4f, p = %.4f\n', t_stat_longitude, p_value_longitude);
if abs(t_stat_longitude) > tinv(0.975, n-3)
    fprintf('Conclusion : La longitude a un effet SIGNIFICATIF.\n');
else
    fprintf('Conclusion : La longitude n''a PAS d''effet significatif.\n');
end




lon_range = linspace(min(longitude), max(longitude), 100);
temp_pred_line2 = beta_multi(1) + beta_multi(2) * lat_range + beta_multi(3)*lon_range;
plot(lat_range, temp_pred_line2);
legend('Données', 'Régression','Regression 2');