a = 1;
b = 60000;
ytolerance = 1e-12;
max_iterations = 100;

[n_bisection,fun_b,iter_b, xtab_b, xdif_b] = bisection_method(a, b, max_iterations, ytolerance, @estimate_execution_time);

[n_secant, fun_s, iter_s, xtab_s, xdif_s] = secant_method(a, b, max_iterations, ytolerance, @estimate_execution_time);

figure;
subplot(2,1,1);
plot(xtab_b, 'DisplayName', 'Bisection');
hold on;
plot(xtab_s, 'DisplayName', 'Secant');
xlabel('Liczba iteracji');
ylabel('Rozwiązanie [N]');
title('Przybliżenie rozwiązania dla danych iteracji (wyznaczenie liczby parametrów N)');
legend('Location', 'best');
grid on;

subplot(2,1,2);
semilogy(xdif_b, 'DisplayName', 'Bisection');
hold on;
semilogy(xdif_s, 'DisplayName', 'Secant');
xlabel('Liczba iteracji');
ylabel('Różnica rozwiązań');
title('Różnice między przybliżeniami rozwiązania dla danych iteracji (skala log)');
legend('Location', 'best');
grid on;
print('zad8.png', '-dpng');