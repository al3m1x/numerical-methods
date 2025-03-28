function plot_problem_5(N, time_Jacobi, time_Gauss_Seidel, iterations_Jacobi, iterations_Gauss_Seidel)
    % Opis wektorów stanowiących parametry wejściowe:
    % N - rozmiary analizowanych macierzy
    % time_Jacobi - czasy wyznaczenia rozwiązania metodą Jacobiego
    % time_Gauss_Seidel - czasy wyznaczenia rozwiązania metodą Gaussa-Seidla
    % iterations_Jacobi - liczba iteracji wymagana do wyznaczenia rozwiązania metodą Jacobiego
    % iterations_Gauss_Seidel - liczba iteracji wymagana do wyznaczenia rozwiązania metodą Gauss-Seidla
    figure;
    subplot(2,1,1);
    plot(N, time_Jacobi, '-o');
    hold on;
    plot(N, time_Gauss_Seidel, '-s');
    hold off;
    title('Czas obliczeń w zależności od wielkości macierzy');
    xlabel('Wielkość macierzy [N]');
    ylabel('Czas [s]');
    legend('Metoda Jacobiego', 'Metoda Gaussa-Seidla', 'Location', 'eastoutside');
    grid on;

    subplot(2,1,2);
    bar_data = [iterations_Jacobi; iterations_Gauss_Seidel];
    bar(N, bar_data);
    title('Liczba iteracji w zależności od rozmiaru macierzy');
    xlabel('Wielkość macierzy [N]');
    ylabel('Liczba iteracji');
    legend('Metoda Jacobiego', 'Metoda Gaussa-Seidla', 'Location', 'eastoutside');

    print -dpng zadanie5.png 
end
