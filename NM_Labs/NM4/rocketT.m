a = 1;
b = 50;
ytolerance = 1e-12;
max_iterations = 100;

[time_bisection,fun_b,iter_b, xtab_b, xdif_b] = bisection_method(a, b, max_iterations, ytolerance, @rocket_velocity);

[time_secant, fun_s, iter_s, xtab_s, xdif_s] = secant_method(a, b, max_iterations, ytolerance, @rocket_velocity);

figure;
subplot(2,1,1);
plot(xtab_b, 'DisplayName', 'Bisection Method');
hold on;
plot(xtab_s, 'DisplayName', 'Secant Method');
xlabel('Liczba iteracji');
ylabel('Rozwiązanie [s]');
title('Przybliżenie rozwiązania dla danych iteracji (Czas rakiety do osiągnięcia prędkości 750 m/s)');
legend('Location', 'best');
grid on;

subplot(2,1,2);
semilogy(xdif_b, 'DisplayName', 'Bisection Method');
hold on;
semilogy(xdif_s, 'DisplayName', 'Secant Method');
xlabel('Liczba iteracji');
ylabel('Różnica rozwiązań');
title('Różnice między przybliżeniami rozwiązania dla danych iteracji (skala log)');
legend('Location', 'best');
grid on;
print('zad6.png', '-dpng');