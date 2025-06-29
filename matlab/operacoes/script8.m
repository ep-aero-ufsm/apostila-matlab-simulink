% Operações vetoriais e matriciais
a = 2;
v1 = [1, 2];
v2 = [3; 4];
M1 = [1, 2; 
      3, 4];
M2 = [5, 6;
      7, 8];
% Escalar x vetor
res1 = a * v

% Escalar x matriz
res2 = a * M1

% Vetor x vetor
res3 = v1 * v2  % v1 vetor-linha, v2 vetor-coluna

% Vetor x matriz
res4 = v * M1

% Matriz x matriz
res5 = M1 * M2

% Matriz x matriz (elemento à elemento)
res6 = M1 .* M2
