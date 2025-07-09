% Gŕaficos em MATLAB
x = 0:0.1:2*pi;
y1 = sin(x);
y2 = cos(x);

figure
subplot(2,1,1)
plot(x, y1)
xlabel('x')
ylabel('sin(x)')
title('Gráfico do seno')

subplot(2,1,2)
plot(x, y2, 'r')
xlabel('x')
ylabel('cos(x)')
title('Gráfico do cosseno')