a = 1;
b = 50;
ytolerance = 1e-12;
max_iterations = 100;

[omega_bisection,fun_b,iter_b, xtab_b, xdif_b] = bisection_method(a, b, max_iterations, ytolerance, @impedance_magnitude);

[omega_secant, fun_s, iter_s, xtab_s, xdif_s] = secant_method(a, b, max_iterations, ytolerance, @impedance_magnitude);

figure;
subplot(2,1,1); % liczba wierszów, liczba kolumn, numer aktualnego wykresu
plot(xtab_b, 'DisplayName', 'Bisection');
hold on;
plot(xtab_s, 'DisplayName', 'Secant');
xlabel('Liczba iteracji');
ylabel('Rozwiązanie [rad/s]');
title('Przybliżenie rozwiązania dla danych iteracji (omega w obwodzie RLC)');
legend('Location', 'best');
grid on;

subplot(2,1,2);
semilogy(xdif_b, 'DisplayName', 'Bisection'); % wykres w skali logarytmicznej na osi y
hold on;
semilogy(xdif_s, 'DisplayName', 'Secant');
xlabel('Liczba iteracji');
ylabel('Różnica rozwiązań');
title('Różnice między przybliżeniami rozwiązania dla danych iteracji (skala log)');
legend('Location', 'best');
grid on;
print('zad4.png', '-dpng');