%% Fonction logistique
clear all;
close all;
clc;

n = 2;
N = 10;
I = 1000;
lambda = zeros(1,N);
v= 0;
for i=1:N
    v = v + I/N;
    lambda(i) = v;
end

b = 1;
w11 = 0;
w12 = 1;
w21 = 1;
w22 = 0;
W = [w11, w12 ; w21, w22];
B = [0.5; 0.5];
s0 = [5 ; 10];

Phi2 = @(x) 1 ./ (1 + exp(-b*x));

ed = cell(1,N);
s = cell(1,N);
t = cell(1,N);
tspan = [0 0.1];
for i=1:N
    ed{i} = @(t,s) -lambda(i) * s + Phi2(W * s + B);
    [t{i}, s{i}] = ode45(ed{i}, tspan, s0);
end

figure('Position', [100 100 1400 500]);

for i = 1:N
    plot(t{1,i}, s{i}, 'LineWidth', 2);
    xlabel('Temps (t)', 'FontSize', 12);
    ylabel('États s_i(t)', 'FontSize', 12);
    grid on;
    legend(['s_1' num2str(i) '(t)'],['s_2' num2str(i) '(t)'], 'Location', 'best', 'FontSize', 11);
    hold on
end

hold off

%% Fonction positive
clear all;
close all;
clc;

n = 2;
b = 1;
w11 = 0;
w12 = 1;
w21 = 1;
w22 = 0;
W = [w11, w12 ; w21, w22];
B = [0.5; 0.5];

lambda1 = 0.1;
lambda2 = 1;
lambda3 = 10;

Phi1 =  @(x) max(0,x);

ed1 = @(t1, s1) -lambda1 * s1 + Phi1(W * s1 + B);
ed2 = @(t2, s2) -lambda2 * s2 + Phi1(W * s2 + B);
ed3 = @(t3, s3) -lambda3 * s3 + Phi1(W * s3 + B);
s0 = [0 ; 10];
tspan = [0 2];

[t1, s1] = ode45(ed1, tspan, s0);
[t2, s2] = ode45(ed2, tspan, s0);
[t3, s3] = ode45(ed3, tspan, s0);

figure('Position', [100 100 1400 500]);

% Graphique 1
subplot(1, 3, 1);
plot(t1, s1, 'LineWidth', 2);
xlabel('Temps (t)', 'FontSize', 12);
ylabel('États s_i(t)', 'FontSize', 12);
grid on;
legend('s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);

% Graphique 2
subplot(1, 3, 2);
plot(t2, s2, 'LineWidth', 2);
xlabel('Temps (t)', 'FontSize', 12);
ylabel('États s_i(t)', 'FontSize', 12);
grid on;
legend('s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);


% Graphique 3
subplot(1, 3, 3);
plot(t3, s3, 'LineWidth', 2);
xlabel('Temps (t)', 'FontSize', 12);
ylabel('États s_i(t)', 'FontSize', 12);
grid on;
legend('s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);

%%

% QUESTION 1

% Le but est de tracer les solutions de l'équation tout en ayant la
% possibilité de faire varier les paramètres directement sur les graphes
% sans avoir à relancer le programme à chaque fois que l'on fait varier un
% paramètre.


clear all;
close all;
clc;

% Choix de la fonction
Phi =  @(x) max(0,x);


function [t, s] = euler(W, B, s0, lambda, tspan)
    Phi =  @(x) max(0,x);

    N = 1000;
    pas = tspan(2)/N;

    f = @(t, s) -lambda * s + Phi(W * s + B);  % equation 

    t = zeros(N + 1, 1);
    s = zeros(N + 1, 2);

    t(1) = tspan(1);
    s(1, :) = s0;
    
    % Euler 
    for i = 1:N
        f_i = f(t(i), s(i, :)'); 
        
        s(i+1, :) = s(i, :) + pas * f_i'; 
        
        t(i+1) = t(i) + pas;
    end
end



tracer;

function tracer

    fig = uifigure('Name', 'Tracé', 'Position', [100, 100, 1000, 800]);
    
    %%% Partie création des sliders %%%

    % Lambda
    lambda = uislider(fig,...
                 'Position',[120 40 300 3],...
                 'Limits',[0 20],...
                 'Value',2,...
                 'ValueChangedFcn',@maj_lambda);
    label_lambda = uilabel(fig, 'Position', [20 30 80 22], ...
                 'Text', ['lambda = ' num2str(lambda.Value)]);
    
    % Conditions initiales 
    s_01 = uislider(fig,...
                 'Position',[120 240 300 3],...
                 'Limits',[0 30],...
                 'Value',1,...
                 'ValueChangedFcn',@maj_s_01);
    label_s_01 = uilabel(fig, 'Position', [20 230 80 22], ...
                 'Text', ['s_01 = ' num2str(s_01.Value)]);
    s_02 = uislider(fig,...
                 'Position',[120 190 300 3],...
                 'Limits',[0 30],...
                 'Value',1,...
                 'ValueChangedFcn',@maj_s_02);
    label_s_02 = uilabel(fig, 'Position', [20 180 80 22], ...
                 'Text', ['s_02 = ' num2str(s_02.Value)]);
    
    % Conditions extérieures
    B1 = uislider(fig,...
                 'Position',[120 140 300 3],...
                 'Limits',[0 30],...
                 'Value',1,...
                 'ValueChangedFcn',@maj_B1);
    label_B1 = uilabel(fig, 'Position', [20 130 80 22], ...
                 'Text', ['B1 = ' num2str(B1.Value)]);
    B2 = uislider(fig,...
                 'Position',[120 90 300 3],...
                 'Limits',[0 30],...
                 'Value',1,...
                 'ValueChangedFcn',@maj_B2);
    label_B2 = uilabel(fig, 'Position', [20 80 80 22], ...
                 'Text', ['B2 = ' num2str(B2.Value)]);

    % La matrice W
    w11 = uislider(fig,...
                 'Position',[600 240 300 3],...
                 'Limits',[0 30],...
                 'Value',1,...
                 'ValueChangedFcn',@maj_w11);
    label_w11 = uilabel(fig, 'Position', [500 230 80 22], ...
                 'Text', ['w11 = ' num2str(w11.Value)]);

    w12 = uislider(fig,...
                 'Position',[600 190 300 3],...
                 'Limits',[0 30],...
                 'Value',1,...
                 'ValueChangedFcn',@maj_w12);
    label_w12 = uilabel(fig, 'Position', [500 180 80 22], ...
                 'Text', ['w12 = ' num2str(w12.Value)]);

    w21 = uislider(fig,...
                 'Position',[600 140 300 3],...
                 'Limits',[0 30],...
                 'Value',1,...
                 'ValueChangedFcn',@maj_w21);
    label_w21 = uilabel(fig, 'Position', [500 130 80 22], ...
                 'Text', ['w21 = ' num2str(w21.Value)]);

    w22 = uislider(fig,...
                 'Position',[600 90 300 3],...
                 'Limits',[0 30],...
                 'Value',1,...
                 'ValueChangedFcn',@maj_w22);
    label_w22 = uilabel(fig, 'Position', [500 80 80 22], ...
                 'Text', ['w22 = ' num2str(w22.Value)]);

    
    %%% Initialisation %%%

    ax = uiaxes(fig,'Position',[20 270 750 500]);

    W = [w11.Value, w12.Value ; w21.Value, w22.Value];
    
    B = [B1.Value; B2.Value];
    
    s0 = [s_01.Value; s_02.Value];

    tspan = [0 10];
    
    [t, s] = euler(W, B, s0, lambda.Value, tspan);

    plot(ax, t, s, 'LineWidth', 2);
    xlabel(ax, 'Temps (t)', 'FontSize', 12);
    ylabel(ax, 'États s_i(t)', 'FontSize', 12);    
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
    title(ax,'Modélisation de l''activité électrique du cerveau');


    %%% Partie mise à jour des courbes %%%

    % Lambda
    function maj_lambda(src, event)
        l = event.Value;
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_lambda.Text = ['lambda = ' num2str(l)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end
    
    % Conditions initiales
    function maj_s_01(src, event)
        s0 = [event.Value; s_02.Value];
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_s_01.Text = ['s_01 = ' num2str(event.Value)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end
    function maj_s_02(src, event)
        s0 = [s_01.Value; event.Value];
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_s_02.Text = ['s_02 = ' num2str(event.Value)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end
    
    % Conditions extérieures
    function maj_B1(src, event)
        B = [event.Value; B2.Value];
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_B1.Text = ['B1 = ' num2str(event.Value)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end
    function maj_B2(src, event)
        B = [B1.Value; event.Value];
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_B2.Text = ['B2 = ' num2str(event.Value)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end

    % la matrice W
    function maj_w11(src, event)
        W = [event.Value, w12.Value ; w21.Value, w22.Value];
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_w11.Text = ['w11 = ' num2str(event.Value)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end
    function maj_w12(src, event)
        W = [w11.Value, event.Value ; w21.Value, w22.Value];
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_w12.Text = ['w12 = ' num2str(event.Value)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end
    function maj_w21(src, event)
        W = [w11.Value, w12.Value ; event.Value, w22.Value];
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_w21.Text = ['w21 = ' num2str(event.Value)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end
    function maj_w22(src, event)
        W = [w11.Value, w12.Value ; w21.Value, event.Value];
        [t, s] = euler(W, B, s0, lambda.Value, tspan);
        plot(ax, t, s, 'LineWidth', 2);
        label_w22.Text = ['w22 = ' num2str(event.Value)];
        legend(ax,'s_1(t)', 's_2(t)', 'Location', 'best', 'FontSize', 11);
        title(ax,'Modélisation de l''activité électrique du cerveau');
    end

end

%% Question 2
clear all;
close all;
clc;
% Question 2

clear all;
close all;
clc;

n = 5;

% Début programme
tracer_n_equations(n);



% Fonction étudiée - Commenter / décommenter pour choisir la fonction
% voulue 
function Phi = get_activation_function(type, beta)
    % Renvoie la fonction d'activation choisie (Sigmoïde ou ReLU)
    if strcmp(type, 'Sigmoide')
        Phi = @(x) 1 ./ (1 + exp(-beta * x));
    else % Par défaut ou si 'ReLU'
        Phi = @(x) max(0, x);
    end
end


% méthode d'Euler 
function [t, s] = euler(W, B, s0, lambda, tspan, activation_type, beta)
    n = length(s0);
    N = 1000;
    pas = (tspan(2) - tspan(1)) / N;

    Phi = get_activation_function(activation_type, beta);
    
    f = @(t, s) -lambda * s + Phi(W * s + B); 
    
    t = zeros(N + 1, 1);
    s = zeros(N + 1, n);
    s(1, :) = s0';
    
    for i = 1:N
        f_i = f(t(i), s(i, :)'); 
        s(i+1, :) = s(i, :) + pas * f_i'; 
        t(i+1) = t(i) + pas;
    end
end

% Interface graphique 
function tracer_n_equations(n)
    
    % Initialisation des données
    app.beta = 1;
    app.n = n;
    app.tspan = [0 10];
    app.lambda = 2;
    app.s0 = ones(n, 1);
    app.B = ones(n, 1);
    app.W = ones(n, n); 
    app.W_fields = cell(n, n);
    app.activation_type = 'ReLU';
    
    % Figure principale
    fig = uifigure('Name', ['Résolution du Système Différentiel à n=' num2str(n)], 'Position', [100, 100, 1000, 800]);
    app.fig_main = fig; % Pour rajouter la figure à l'app
    
    % Axes pour le tracé
    app.ax = uiaxes(fig, 'Position', [350 150 600 600]);    % sysème d'axe moderne utile pour notre interface graphique 
    title(app.ax, 'Solutions du Système');
    xlabel(app.ax, 'Temps (t)');
    ylabel(app.ax, 'États s_i(t)');    
    app.ax.XGrid = 'on';
    app.ax.YGrid = 'on';
    
    % Champs de saisie
    y_start = 750;
    
    % Sélecteur fonction 
    uilabel(fig, 'Position', [20 y_start-30 150 22], 'Text', 'Fonction $\Phi$:', 'Interpreter', 'latex');
    app.change_Phi = uidropdown(fig, 'Position', [180 y_start-30 150 22], ...
        'Items', {'ReLU', 'Sigmoide'}, ...
        'Value', app.activation_type, ...
        'ValueChangedFcn', @maj_parametres);
    
    % Paramètre Lambda
    uilabel(fig, 'Position', [20 y_start-70 150 22], 'Text', 'Paramètre $\lambda$:', 'Interpreter', 'latex');
    app.change_lambda = uieditfield(fig, 'Position', [180 y_start-70 150 22], ...
        'Value', num2str(app.lambda), ...
        'ValueChangedFcn', @maj_parametres); 
        
    % Paramètre Beta
    uilabel(fig, 'Position', [20 y_start-110 150 22], 'Text', 'Paramètre $\beta$ (Sigmoïde):', 'Interpreter', 'latex');
    app.change_beta = uieditfield(fig, 'Position', [180 y_start-110 150 22], ...
        'Value', num2str(app.beta), ...
        'ValueChangedFcn', @maj_parametres); 

    % Conditions Initiales (s0)
    uilabel(fig, 'Position', [20 y_start-150 150 22], 'Text', 'Conditions Initiales $\mathbf{s}_0$:', 'Interpreter', 'latex');
    app.change_s0 = uieditfield(fig, 'Position', [180 y_start-150 150 22], ...
        'Value', strtrim(sprintf('%.2f ', app.s0)), ... 
        'ValueChangedFcn', @maj_parametres);
    
    % Vecteur B
    uilabel(fig, 'Position', [20 y_start-190 150 22], 'Text', 'Vecteur $\mathbf{B}$:', 'Interpreter', 'latex');
    app.change_B = uieditfield(fig, 'Position', [180 y_start-190 150 22], ...
        'Value', strtrim(sprintf('%.2f ', app.B)), ... 
        'ValueChangedFcn', @maj_parametres);
    


    % Figure pour W - On affiche chaque coefficient dans une case d'entrée
    % pour le modifier facielement, en ayant quelque chose de visuel
    % ressemblant à une matrice : 

    % taille de la fenêtre s'ajuste à la taille de la matrice 
    app.fig_W = uifigure('Name', ['Matrice W (' num2str(n) 'x' num2str(n) ')'], 'Position', [1150, 100, 100 + n * 80, 150 + n * 30]);
    
    uilabel(app.fig_W, 'Position', [10 app.fig_W.Position(4)-30 300 22], 'Text', ['Coefficients de W']);
    
    % Dimensions de la grille de la matrice
    grid_start_x = 10;
    field_width = 70;
    field_height = 22;
    padding = 10;
    
    for i = 1:n % lignes
        for j = 1:n % colonnes
            x_pos = grid_start_x + (j - 1) * (field_width + padding);
            % On travaille depuis le bas de la figure pour le placement relatif
            y_pos = app.fig_W.Position(4) - 50 - (i - 1) * (field_height + padding); 
            
            % Création du champ pour W(i, j) dans la figure secondaire
            app.W_fields{i, j} = uieditfield(app.fig_W, 'Position', [x_pos y_pos field_width field_height], ...
                'Value', num2str(app.W(i, j), '%.f'), ...
                'Tag', ['W_' num2str(i) '_' num2str(j)], ... 
                'ValueChangedFcn', @maj_parametres_W_grid);
        end
    end



    % Stocker la structure 'app' dans les deux figures pour accès mutuel
    fig.UserData = app;
    app.fig_W.UserData = fig; % La figure W pointe vers la figure principale
    



    % tracé 1 
    plot_solutions(fig);
    
    % Fonction de maj pour W 
    function maj_parametres_W_grid(src, event)
        % Récupère le handle de la figure principale (stocké dans UserData de la figure W)
        fig_main = src.Parent.UserData; 
        app = fig_main.UserData;
        
        try
            % Lecture de tous les W(i, j)
            new_W = zeros(app.n, app.n);
            for i = 1:app.n
                for j = 1:app.n
                    val = str2double(app.W_fields{i, j}.Value);
                    if isnan(val)
                        error(['La valeur pour W(' num2str(i) ',' num2str(j) ') est invalide.']);
                    end
                    new_W(i, j) = val;
                end
            end
            app.W = new_W;
            
            % Mettre à jour la structure et tracer
            fig_main.UserData = app;
            plot_solutions(fig_main);
            
        catch ME
            uialert(app.fig_W, ME.message, 'Erreur de Saisie dans la Matrice W');
        end
    end

    % Fonction de maj pour les autres paramètres (s0, B, lambda)
    function maj_parametres(src, event)
        fig = src.Parent;
        app = fig.UserData;
        
        try
            % 1. Lecture du type d'activation (DropDown)
            app.activation_type = app.change_Phi.Value;
            
            % 2. Lecture et validation de Lambda
            new_lambda = str2double(app.change_lambda.Value);
            if isnan(new_lambda) || new_lambda < 0
                error('Lambda doit être un nombre positif.');
            end
            app.lambda = new_lambda;
            
            % 3. Lecture et validation de Beta
            new_beta = str2double(app.change_beta.Value);
            if isnan(new_beta)
                error('Beta doit être un nombre valide.');
            end
            app.beta = new_beta;

            % 4. Lecture et validation de s0
            new_s0_flat = str2num(strtrim(app.change_s0.Value)); %#ok<ST2NM>
            if ~isvector(new_s0_flat) || length(new_s0_flat) ~= app.n
                error(['s0 doit contenir ' num2str(app.n) ' valeurs séparées par des espaces.']);
            end
            app.s0 = new_s0_flat(:); 
            
            % 5. Lecture et validation de B
            new_B_flat = str2num(strtrim(app.change_B.Value)); %#ok<ST2NM>
            if ~isvector(new_B_flat) || length(new_B_flat) ~= app.n
                error(['B doit contenir ' num2str(app.n) ' valeurs séparées par des espaces.']);
            end
            app.B = new_B_flat(:); 
            
            % Mettre à jour la structure et tracer
            fig.UserData = app;
            plot_solutions(fig);
            
        catch ME
            uialert(fig, ME.message, 'Erreur de Saisie de Paramètre (Lambda, s0 ou B)');
        end
    end

    % Fonction de tracé des solutions 
    function plot_solutions(fig)
        app = fig.UserData;
        
        % Résolution du système
        [t, s] = euler(app.W, app.B, app.s0, app.lambda, app.tspan, app.activation_type, app.beta);
        
        % Tracé
        plot(app.ax, t, s, 'LineWidth', 2);
        
        % Création de la légende
        legend_labels = arrayfun(@(i) ['s_' num2str(i) '(t)'], 1:app.n, 'UniformOutput', false);
        legend(app.ax, legend_labels, 'Location', 'northeast', 'Interpreter', 'latex');
        
        % Mise à jour du titre
        title_str = sprintf('Solutions pour $\\lambda=%.2f$, $\\mathbf{s}_0=[%s]$, $\\mathbf{B}=[%s]$', ...
                            app.lambda, ...
                            sprintf('%.2f ', app.s0(1:min(app.n, 3))'), ...
                            sprintf('%.2f ', app.B(1:min(app.n, 3))'));
        if app.n > 3
             title_str = [title_str, '...'];
        end
        title(app.ax, title_str, 'Interpreter', 'latex', 'FontSize', 12);
    end
end

%%

% Question 2

clear all;
close all;
clc;

n = 5;

% Début programme
tracer_n_equations(n);



% Fonction étudiée - Commenter / décommenter pour choisir la fonction
% voulue 
function Phi = get_activation_function(type, beta)
    % Renvoie la fonction d'activation choisie (Sigmoïde ou ReLU)
    if strcmp(type, 'Sigmoide')
        Phi = @(x) 1 ./ (1 + exp(-beta * x));
    else % Par défaut ou si 'ReLU'
        Phi = @(x) max(0, x);
    end
end


% méthode d'Euler 
function [t, s] = euler(W, B, s0, lambda, tspan, activation_type, beta)
    n = length(s0);
    N = 1000;
    pas = (tspan(2) - tspan(1)) / N;

    Phi = get_activation_function(activation_type, beta);
    
    f = @(t, s) -lambda * s + Phi(W * s + B); 
    
    t = zeros(N + 1, 1);
    s = zeros(N + 1, n);
    s(1, :) = s0';
    
    for i = 1:N
        f_i = f(t(i), s(i, :)'); 
        s(i+1, :) = s(i, :) + pas * f_i'; 
        t(i+1) = t(i) + pas;
    end
end

% Interface graphique 
function tracer_n_equations(n)
    
    % Initialisation des données
    app.beta = 1;
    app.n = n;
    app.tspan = [0 10];
    app.lambda = 2;
    app.s0 = ones(n, 1);
    app.B = ones(n, 1);
    app.W = ones(n, n); 
    app.W_fields = cell(n, n);
    app.activation_type = 'ReLU';
    
    % Figure principale
    fig = uifigure('Name', ['Résolution du Système Différentiel à n=' num2str(n)], 'Position', [100, 100, 1000, 800]);
    app.fig_main = fig; % Pour rajouter la figure à l'app
    
    % Axes pour le tracé
    app.ax = uiaxes(fig, 'Position', [350 150 600 600]);    % sysème d'axe moderne utile pour notre interface graphique 
    title(app.ax, 'Solutions du Système');
    xlabel(app.ax, 'Temps (t)');
    ylabel(app.ax, 'États s_i(t)');    
    app.ax.XGrid = 'on';
    app.ax.YGrid = 'on';
    
    % Champs de saisie
    y_start = 750;
    
    % Sélecteur fonction 
    uilabel(fig, 'Position', [20 y_start-30 150 22], 'Text', 'Fonction $\Phi$:', 'Interpreter', 'latex');
    app.change_Phi = uidropdown(fig, 'Position', [180 y_start-30 150 22], ...
        'Items', {'ReLU', 'Sigmoide'}, ...
        'Value', app.activation_type, ...
        'ValueChangedFcn', @maj_parametres);
    
    % Paramètre Lambda
    uilabel(fig, 'Position', [20 y_start-70 150 22], 'Text', 'Paramètre $\lambda$:', 'Interpreter', 'latex');
    app.change_lambda = uieditfield(fig, 'Position', [180 y_start-70 150 22], ...
        'Value', num2str(app.lambda), ...
        'ValueChangedFcn', @maj_parametres); 
        
    % Paramètre Beta
    uilabel(fig, 'Position', [20 y_start-110 150 22], 'Text', 'Paramètre $\beta$ (Sigmoïde):', 'Interpreter', 'latex');
    app.change_beta = uieditfield(fig, 'Position', [180 y_start-110 150 22], ...
        'Value', num2str(app.beta), ...
        'ValueChangedFcn', @maj_parametres); 

    % Conditions Initiales (s0)
    uilabel(fig, 'Position', [20 y_start-150 150 22], 'Text', 'Conditions Initiales $\mathbf{s}_0$:', 'Interpreter', 'latex');
    app.change_s0 = uieditfield(fig, 'Position', [180 y_start-150 150 22], ...
        'Value', strtrim(sprintf('%.2f ', app.s0)), ... 
        'ValueChangedFcn', @maj_parametres);
    
    % Vecteur B
    uilabel(fig, 'Position', [20 y_start-190 150 22], 'Text', 'Vecteur $\mathbf{B}$:', 'Interpreter', 'latex');
    app.change_B = uieditfield(fig, 'Position', [180 y_start-190 150 22], ...
        'Value', strtrim(sprintf('%.2f ', app.B)), ... 
        'ValueChangedFcn', @maj_parametres);
    


    % Figure pour W - On affiche chaque coefficient dans une case d'entrée
    % pour le modifier facielement, en ayant quelque chose de visuel
    % ressemblant à une matrice : 

    % taille de la fenêtre s'ajuste à la taille de la matrice 
    app.fig_W = uifigure('Name', ['Matrice W (' num2str(n) 'x' num2str(n) ')'], 'Position', [1150, 100, 100 + n * 80, 150 + n * 30]);
    
    uilabel(app.fig_W, 'Position', [10 app.fig_W.Position(4)-30 300 22], 'Text', ['Coefficients de W']);
    
    % Dimensions de la grille de la matrice
    grid_start_x = 10;
    field_width = 70;
    field_height = 22;
    padding = 10;
    
    for i = 1:n % lignes
        for j = 1:n % colonnes
            x_pos = grid_start_x + (j - 1) * (field_width + padding);
            % On travaille depuis le bas de la figure pour le placement relatif
            y_pos = app.fig_W.Position(4) - 50 - (i - 1) * (field_height + padding); 
            
            % Création du champ pour W(i, j) dans la figure secondaire
            app.W_fields{i, j} = uieditfield(app.fig_W, 'Position', [x_pos y_pos field_width field_height], ...
                'Value', num2str(app.W(i, j), '%.f'), ...
                'Tag', ['W_' num2str(i) '_' num2str(j)], ... 
                'ValueChangedFcn', @maj_parametres_W_grid);
        end
    end



    % Stocker la structure 'app' dans les deux figures pour accès mutuel
    fig.UserData = app;
    app.fig_W.UserData = fig; % La figure W pointe vers la figure principale
    



    % tracé 1 
    plot_solutions(fig);
    
    % Fonction de maj pour W 
    function maj_parametres_W_grid(src, event)
        % Récupère le handle de la figure principale (stocké dans UserData de la figure W)
        fig_main = src.Parent.UserData; 
        app = fig_main.UserData;
        
        try
            % Lecture de tous les W(i, j)
            new_W = zeros(app.n, app.n);
            for i = 1:app.n
                for j = 1:app.n
                    val = str2double(app.W_fields{i, j}.Value);
                    if isnan(val)
                        error(['La valeur pour W(' num2str(i) ',' num2str(j) ') est invalide.']);
                    end
                    new_W(i, j) = val;
                end
            end
            app.W = new_W;
            
            % Mettre à jour la structure et tracer
            fig_main.UserData = app;
            plot_solutions(fig_main);
            
        catch ME
            uialert(app.fig_W, ME.message, 'Erreur de Saisie dans la Matrice W');
        end
    end

    % Fonction de maj pour les autres paramètres (s0, B, lambda)
    function maj_parametres(src, event)
        fig = src.Parent;
        app = fig.UserData;
        
        try
            % 1. Lecture du type d'activation (DropDown)
            app.activation_type = app.change_Phi.Value;
            
            % 2. Lecture et validation de Lambda
            new_lambda = str2double(app.change_lambda.Value);
            if isnan(new_lambda) || new_lambda < 0
                error('Lambda doit être un nombre positif.');
            end
            app.lambda = new_lambda;
            
            % 3. Lecture et validation de Beta
            new_beta = str2double(app.change_beta.Value);
            if isnan(new_beta)
                error('Beta doit être un nombre valide.');
            end
            app.beta = new_beta;

            % 4. Lecture et validation de s0
            new_s0_flat = str2num(strtrim(app.change_s0.Value)); %#ok<ST2NM>
            if ~isvector(new_s0_flat) || length(new_s0_flat) ~= app.n
                error(['s0 doit contenir ' num2str(app.n) ' valeurs séparées par des espaces.']);
            end
            app.s0 = new_s0_flat(:); 
            
            % 5. Lecture et validation de B
            new_B_flat = str2num(strtrim(app.change_B.Value)); %#ok<ST2NM>
            if ~isvector(new_B_flat) || length(new_B_flat) ~= app.n
                error(['B doit contenir ' num2str(app.n) ' valeurs séparées par des espaces.']);
            end
            app.B = new_B_flat(:); 
            
            % Mettre à jour la structure et tracer
            fig.UserData = app;
            plot_solutions(fig);
            
        catch ME
            uialert(fig, ME.message, 'Erreur de Saisie de Paramètre (Lambda, s0 ou B)');
        end
    end

    % Fonction de tracé des solutions 
    function plot_solutions(fig)
        app = fig.UserData;
        
        % Résolution du système
        [t, s] = euler(app.W, app.B, app.s0, app.lambda, app.tspan, app.activation_type, app.beta);
        
        % Tracé
        plot(app.ax, t, s, 'LineWidth', 2);
        
        % Création de la légende
        legend_labels = arrayfun(@(i) ['s_' num2str(i) '(t)'], 1:app.n, 'UniformOutput', false);
        legend(app.ax, legend_labels, 'Location', 'northeast', 'Interpreter', 'latex');
        
        % Mise à jour du titre
        title_str = sprintf('Solutions pour $\\lambda=%.2f$, $\\mathbf{s}_0=[%s]$, $\\mathbf{B}=[%s]$', ...
                            app.lambda, ...
                            sprintf('%.2f ', app.s0(1:min(app.n, 3))'), ...
                            sprintf('%.2f ', app.B(1:min(app.n, 3))'));
        if app.n > 3
             title_str = [title_str, '...'];
        end
        title(app.ax, title_str, 'Interpreter', 'latex', 'FontSize', 12);
    end
end
