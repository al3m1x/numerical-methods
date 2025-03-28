function [integration_error, Nt, ft_5, xr, yr, yrmax] = zadanie4()
    % Numeryczne całkowanie metodą Monte Carlo.
    %
    %   integration_error - wektor wierszowy. Każdy element integration_error(1,i)
    %       zawiera błąd całkowania obliczony dla liczby losowań równej Nt(1,i).
    %       Zakładając, że obliczona wartość całki dla Nt(1,i) próbek wynosi
    %       integration_result, błąd jest definiowany jako:
    %       integration_error(1,i) = abs(integration_result - reference_value),
    %       gdzie reference_value to wartość referencyjna całki.
    %
    %   Nt - wektor wierszowy zawierający liczby losowań, dla których obliczano
    %       wektor błędów całkowania integration_error.
    %
    %   ft_5 - gęstość funkcji prawdopodobieństwa dla n=5
    %
    %   xr - komórki zawierające współrzędne x wylosowanych punktów dla każdej iteracji
    %   yr - komórki zawierające współrzędne y wylosowanych punktów dla każdej iteracji
    %   yrmax - maksymalna dopuszczalna wartość współrzędnej y losowanych punktów

    reference_value = 0.0473612919396179; % wartość referencyjna całki

    Nt = 5:50:10000; % wektor liczby losowań
    integration_error = zeros(1, length(Nt));

    ft_5 = ft(5); % gęstość funkcji prawdopodobieństwa dla n=5
    
    xr = cell(1, length(Nt));
    yr = cell(1, length(Nt));
    yrmax = 2*ft_5;

    for i = 1:length(Nt)
        [integration_result, x_random, y_random] = calkowanie_montecarlo(@ft, Nt(i), yrmax);
        integration_error(i) = abs(integration_result - reference_value);
        
        xr{i} = x_random;
        yr{i} = y_random;
        
        if max(y_random) > yrmax
            yrmax = max(y_random);
        end
    end
    
    loglog(Nt, integration_error);
    xlabel('Liczba losowań');
    ylabel('Błąd całkowania');
    title('Błąd całkowania metodą Monte Carlo');
    grid on;
    saveas(gcf, 'zadanie4.png');
end

function [ft_value] = ft(t)
    small_sigma = 3;
    mi = 10;
    ft_value = exp(-((t - mi).^2) / (2 * small_sigma^2)) / (small_sigma * sqrt(2 * pi));
end

function [suma, x_random, y_random] = calkowanie_montecarlo(f_handle, N, yrmax)
    a = 0; % krańce przedziału
    b = 5;

    x_random = a + (b - a) * rand(N, 1); 
    y_random = yrmax * rand(N, 1);
    
    points_under_curve = sum(f_handle(x_random) >= y_random);
    
    S = b - a;
    suma = S * yrmax * points_under_curve / N;
    
    x_random = x_random.';
    y_random = y_random.';
end
