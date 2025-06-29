% Indexação avançada (usando end)
A = [ 1,  2,  3,  4;
      5,  6,  7,  8;
      9, 10, 11, 12;
     13, 14, 15, 16];

% Extrair uma matriz de uma matriz (exemplo 1)
B = A(2:end, 3:end)

% Extrair uma matriz de uma matriz (exemplo 2)
C = A(1:end-2, 2:end-1)

% Extrair um vetor de uma matriz
D = A(end, :)

% Extrair um elemento de uma matriz
a = A(end, end)