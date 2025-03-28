function plot_microwaves(err_vec_jac, iterations_jac, err_vec_gau, iterations_gau)
    figure;
    plot(iterations_jac, err_vec_jac, 'b', 'LineWidth', 2);
    xlabel('Liczba iteracji');
    ylabel('Błąd');
    xlim([0, 1000]);
    ylim([0, Inf]);
    title('Błąd residualny w zależności od liczby iteracji');
    legend('Metoda Jacobiego');
    grid on;
    print -dpng zadanie6v1.png 

    figure;
    plot(iterations_gau, err_vec_gau, 'r', 'LineWidth', 2);
    xlabel('Liczba iteracji');
    ylabel('Błąd');
    xlim([0, 1000]);
    ylim([0, 70000000000]);
    title('Błąd residualny w zależności od liczby iteracji');
    legend('Metoda Gaussa-Seidla');
    grid on;
    print -dpng zadanie6v2.png
end