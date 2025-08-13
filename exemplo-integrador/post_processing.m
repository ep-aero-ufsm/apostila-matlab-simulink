% Carregando o vetor de Estados final da simulação
V_r = out.Estados(:,1);
A_r = out.Estados(:,2);
phi_r = out.Estados(:,3);
r = out.Estados(:,4);
lat = out.Estados(:,5);
long = out.Estados(:,6);
t = out.tout(:);
N = size(t,1);

phi_i = zeros(N,1);
A_i = zeros(N,1);
long_c = zeros(N,1);
R_i = zeros(N,3);
V_i = zeros(N,3);

% Transformações de coordenadas
for i=1:N
    [V_i(i), phi_i(i), A_i(i)] = Vrel2Vine(V_r(i), phi_r(i), A_r(i), we, r(i), lat(i));
    long_c(i) = long_ECEF2ECI(t(i), long(i), we, tg);
    [R_i(i,:), V_i(i,:)] = RvelPolar2RvelRet(V_i(i), A_i(i), phi_i(i), r(i), lat(i), long_c(i));
end

% Cálculo dos elementos keplerianos
[a,e,i,Omega,omega,M0,~,~,~] = ijk2keplerian(R_i(end,:),V_i(end,:));
r_perigeu = a*(1-e);

x_orbit = R_i(:,1);
y_orbit = R_i(:,2);
z_orbit = R_i(:,3);

figure;

% Magnitude da velocidade relativa
subplot(3, 2, 1);
plot(t, V_r);
grid on
title('Magnitude da Velocidade Relativa');
xlabel('Tempo (s)');
ylabel('Velocidade (m/s)');

% Azimute
subplot(3, 2, 2);
plot(t, rad2deg(A_r));
grid on
title('Azimute');
xlabel('Tempo (s)');
ylabel('Azimute (º)');

% Elevação
subplot(3, 2, 3);
plot(t, rad2deg(phi_r));
grid on
title('Elevação');
xlabel('Tempo (s)');
ylabel('Elevação (°)');

% Distância radial
subplot(3, 2, 4);
plot(t, r);
grid on
title('Distância Radial');
xlabel('Tempo (s)');
ylabel('Distância Radial (m)');

% Latitude
subplot(3, 2, 5);
plot(t, rad2deg(lat));
grid on
title('Latitude');
xlabel('Tempo (s)');
ylabel('Latitude (°)');

% Longitude
subplot(3, 2, 6);
plot(t, rad2deg(long));
grid on
title('Longitude');
xlabel('Tempo (s)');
ylabel('Longitude (°)');

% Gerando o gráfico 3D da trajetória
figure;
plot3(x_orbit, y_orbit, z_orbit, 'r-', 'LineWidth', 1.5);
hold on;
xlabel('X (km)');
ylabel('Y (km)');
zlabel('Z (km)');
title('Trajetória obtida');
grid on;

% Mostrando a Terra no gráfico para referência
theta = linspace(0, 2*pi, 100);
phi = linspace(0, pi, 100);
[Theta, Phi] = meshgrid(theta, phi);
X = Re * sin(Phi) .* cos(Theta);
Y = Re * sin(Phi) .* sin(Theta);
Z = Re * cos(Phi);
surf(X, Y, Z, 'FaceAlpha', 0.1, 'EdgeColor', 'none'); % Representação da Terra

% Adicionando a linha do Equador (círculo no plano z=0)
equator_radius = Re; % Raio da Terra (km)
equator_x = equator_radius * cos(theta); % Cálculo das coordenadas X do Equador
equator_y = equator_radius * sin(theta); % Cálculo das coordenadas Y do Equador
equator_z = zeros(size(equator_x)); % O Equador está no plano z = 0

% Plotando a linha pontilhada do Equador
plot3(equator_x, equator_y, equator_z, 'k--', 'LineWidth', 1.5);

% Ajustando o gráfico
axis equal;
view(3);
hold off;


if r_perigeu <= (Re+200e3)
    disp('Não foi possível atingir a órbita')
else
    disp('Órbita obtida:');
    disp(['Semi-eixo maior (a): ', num2str(a), ' m']);
    disp(['Excentricidade (e): ', num2str(e)]);
    disp(['Inclinação (i): ', num2str(i), ' graus']);
    disp(['Longitude do nodo ascendente (Ω): ', num2str(Omega), ' graus']);
    disp(['Argumento do perigeu (ω): ', num2str(omega), ' graus']);
    disp(['Anomalia média (M): ', num2str(M0), ' graus']);
end

function [vi, phii, Ai] = Vrel2Vine(vr, phir, Ar, we, r, dt)
    % Função para converter a velocidade, elevação e azimute da velocidade
    % relativa para a inercial
    % Entradas:
    % vr (m/s): velocidade relativa
    % phir (rad): inclinação da velocidade relativa
    % Ar (rad): azimute da velocidade relativa
    % we (rad/s): velocidade de rotação do referencial girante
    % r (m): distância radial até a origem do referencial inercial
    % dt (rad): latitude
    
    % Saídas:
    % vi (m/s): magnitude da velocidade com respeito ao referencial inercial
    % phii (rad): ângulo de elevação da velocidade inercial
    % Ai (rad): ângulo de azimute da velocidade inercial

    % Cálculos
    Ai = atan2(vr * cos(phir) * sin(Ar) + we * r * cos(dt), vr * cos(phir) * cos(Ar));
    
    if Ai < 0
        Ai = Ai + 2 * pi;
    end
    
    vi = sqrt(vr^2 + 2 * vr * cos(phir) * sin(Ar) * r * we * cos(dt) + r^2 * we^2 * cos(dt)^2);
    
    phii = atan2(sin(phir) * cos(Ai), cos(phir) * cos(Ar));
    
    if abs(phii) > pi / 2
        if phii < pi / 2
            phii = phii + pi;
        end
        if phii > pi / 2
            phii = phii - pi;
        end
    end
end

function long_c = long_ECEF2ECI(t, long, we, tg)
    % Função para calcular a longitude celeste a partir da longitude
    % fixa ao planeta.
    % Entradas:
    % t (s) - Tempo no qual se deseja saber a longitude celeste
    % long (rad) - Longitude relativa ao referencial fixo ao planeta
    % we (rad/s) - Velocidade de rotação do planeta
    % tg (s) - Tempo no qual o meridiano de referência tem longitude celeste nula
    
    % Saída:
    % long_c (rad) - Longitude celeste no tempo t
    
    % Cálculo da longitude celeste
    long_c = long + we * (t - tg);
    
end

function [R, V] = RvelPolar2RvelRet(v, A, phi, r, lat, long)
    % Função para converter a velocidade do sistema LVLH (coordenadas polares)
    % para o sistema ECI ou ECEF retangular.
    % Entradas:
    % v (m/s): Módulo do vetor velocidade
    % A (rad): Azimute da velocidade
    % phi (rad): Elevação da velocidade
    % r (m): Distância radial
    % lat (rad): Latitude
    % long (rad): Longitude no referencial desejado (ECI ou ECEF)
    
    % Saídas:
    % R = [R_X, R_Y, R_Z]^T (m): Vetor posição em coordenadas retangulares no
    % sistema ECI ou ECEF (dependendo da entrada de longitude)
    % V = [V_X, V_Y, V_Z]^T (m/s): Vetor velocidade em coordenadas retangulares no
    % sistema ECI ou ECEF (dependendo da entrada de longitude).
    
    % Cálculo da matriz de conversão do sistema ECI ou ECEF para o LVLH
    CLH = [cos(lat) * cos(long), cos(lat) * sin(long), sin(lat); ...
           -sin(long), cos(long), 0; ...
           -sin(lat) * cos(long), -sin(lat) * sin(long), cos(lat)];
       
    % Vetor velocidade em coordenadas cartesianas no sistema LVLH
    Vlvlh = [v * sin(phi); v * cos(phi) * sin(A); v * cos(phi) * cos(A)];
    
    % Transformação da velocidade para o sistema ECI ou ECEF em coordenadas retangulares
    V = CLH' * Vlvlh;
    
    % Vetor posição no sistema LVLH
    Rlvlh = [r; 0; 0];
    
    % Transformação da posição para o sistema ECI ou ECEF em coordenadas retangulares
    R = CLH' * Rlvlh;
end