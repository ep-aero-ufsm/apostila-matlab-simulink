% Salvar e ler dados de arquivos texto
a = 42;
fid = fopen('saida.txt', 'w');
fprintf(fid, 'Valor de a: %d\n', a);
fclose(fid);

fid = fopen('saida.txt', 'r');
linha = fscanf(fid, '%s');
fclose(fid);
disp(linha)