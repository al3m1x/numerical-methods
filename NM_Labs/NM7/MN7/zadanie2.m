function [integration_error, Nt, ft_5, integral_1000] = zadanie2()
    % Numeryczne całkowanie metodą trapezów.
    % Nt - wektor zawierający liczby podprzedziałów całkowania
    % integration_error - integration_error(1,i) zawiera błąd całkowania wyznaczony
    %   dla liczby podprzedziałów równej Nt(i). Zakładając, że obliczona wartość całki
    %   dla Nt(i) liczby podprzedziałów całkowania wyniosła integration_result,
    %   to integration_error(1,i) = abs(integration_result - reference_value),
    %   gdzie reference_value jest wartością referencyjną całki.
    % ft_5 - gęstość funkcji prawdopodobieństwa dla n=5
    % integral_1000 - całka od 0 do 5 funkcji gęstości prawdopodobieństwa
    %   dla 1000 podprzedziałów całkowania

    reference_value = 0.0473612919396179; % wartość referencyjna całki

    Nt = 5:50:10^4;
    integration_error = zeros(1, length(Nt));

    ft_5 = ft(5);
    integral_1000 = calkowanie_trapezami(@ft, 1000);

    for i = 1:length(Nt)
        integration_result = calkowanie_trapezami(@ft, Nt(i));
        integration_error(i) = abs(integration_result - reference_value);
    end
    
    loglog(Nt, integration_error);
    xlabel('Liczba podprzedziałów');
    ylabel('Błąd całkowania');
    title('Błąd całkowania metodą trapezów');
    grid on;
    saveas(gcf, 'zadanie2.png');

end

function [ft_value] = ft(t)
    small_sigma = 3;
    mi = 10;
    ft_value = exp(-((t-mi)^2)/(2*small_sigma^2)) / (small_sigma * sqrt(2*pi));
end

function suma = calkowanie_trapezami(f_handle, N)
    a = 0; % krańce przedziału
    b = 5;
    width = (b - a) / N; % szerokość podprzedziału
    suma = 0;

    for i = 0:N-1
        x_i = a + i * width;
        x_i_plus_1 = a + (i + 1) * width;
        suma = suma + (f_handle(x_i) + f_handle(x_i_plus_1)) * width / 2; % pole trapezu, (a+b)*h/2
    end
end