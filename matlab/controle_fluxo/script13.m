% Estrutura switch-case
opcao = 2;

switch opcao
    case 1
        mensagem = "Opção 1 selecionada.";
    case 2
        mensagem = "Opção 2 selecionada.";
    case 3
        mensagem = "Opção 3 selecionada.";
    otherwise
        mensagem = "Opção inválida.";
end

disp(mensagem)