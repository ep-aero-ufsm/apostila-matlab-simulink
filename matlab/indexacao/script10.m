% Indexação avançada
A = [ 1,  2,  3,  4;
      5,  6,  7,  8;
      9, 10, 11, 12;
     13, 14, 15, 16];

% Extrair uma matriz de uma matriz (maneira 1)
B = A(1:2, 3:4) % Linhas 1 até 2, colunas 3 até 4 (matriz 2x2 no canto superior direito de A)

% Extrair uma matriz de uma matriz (maneira 2)
C = A([1, 3], [2, 4]) % Linhas 1 e 3, colunas 2 e 4

% Extrair uma matriz de uma matriz (maneira 3)
D = A(:, 1:2) % Todas as linhas, colunas 1 até 2

% Extrair um vetor-linha de uma matriz
v_linha = A(1, :)

% Extrair um vetor-coluna de uma matriz
v_coluna = A(:, 1)

% Linearizar uma matriz
v = A(:)