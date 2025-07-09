% Salvar e ler dados de arquivos .mat
a = 42;
b = [1, 2, 3];
save('dados.mat', 'a', 'b')
clear
load('dados.mat')