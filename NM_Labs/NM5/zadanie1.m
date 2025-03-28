function [V, original_Runge, original_sine, interpolated_Runge, interpolated_sine] = zadanie1()
    % Rozmiar tablic komórkowych (cell arrays) V, interpolated_Runge, interpolated_sine: [1,4].
    % V{i} zawiera macierz Vandermonde wyznaczoną dla liczby węzłów interpolacji równej N(i)
    % original_Runge - wektor wierszowy zawierający wartości funkcji Runge dla wektora x_fine=linspace(-1, 1, 1000)
    % original_sine - wektor wierszowy zawierający wartości funkcji sinus dla wektora x_fine
    % interpolated_Runge{i} stanowi wierszowy wektor wartości funkcji interpolującej 
    %       wyznaczonej dla funkcji Runge (wielomian stopnia N(i)-1) w punktach x_fine
    % interpolated_sine{i} stanowi wierszowy wektor wartości funkcji interpolującej
    %       wyznaczonej dla funkcji sinus (wielomian stopnia N(i)-1) w punktach x_fine
    N = 4:4:16; % liczba węzłów interpolacji
    x_fine = linspace(-1, 1, 1000); 
    original_Runge = 1 ./ (1 + 25 * x_fine.^2); % obliczamy oryginalne wartości funkcji

    figure;
    subplot(2,1,1);
    plot(x_fine, original_Runge, 'LineWidth', 2);
    hold on;
    interpolated_Runge = cell(1,length(N));
    for i = 1:length(N)
        V{i} = vandermonde_matrix(N(i)); % macierz Vandermonde
        x = linspace(-1,1,N(i)); % węzły interpolacji
        y = 1 ./ (1 + 25 * x.^2); % wartości funkcji interpolowanej w węzłach interpolacji
        c_runge = V{i} \ y'; % współczynniki wielomianu interpolującego
        interpolated_Runge{i} = polyval(flipud(c_runge), x_fine); % interpolacja, flipud odwraca kolejność wierszy, bo polyval bierze od największych potęg
        plot(x_fine, interpolated_Runge{i});
        xlabel('Wartości x');
        ylabel('Interpolowane wartości funkcji Runge');
        title('Interpolacja funkcji Runge');
        legend('Interpolowana funkcja Runge');
    end
    hold off

    original_sine = sin(2 * pi * x_fine);
    subplot(2,1,2);
    plot(x_fine, original_sine, 'LineWidth', 2);
    hold on;
    interpolated_sine = cell(1,length(N));
    for i = 1:length(N)
        x = linspace(-1,1,N(i)); % węzły interpolacji
        y = sin(2 * pi * x); % wartości funkcji sinus w węzłach interpolacji
        c_sine = V{i} \ y'; % współczynniki wielomianu interpolującego
        interpolated_sine{i} = polyval(flipud(c_sine), x_fine); % interpolacja
        plot(x_fine, interpolated_sine{i});
        xlabel('Wartości x');
        ylabel('Interpolowane wartości funkcji sinus');
        title('Interpolacja funkcji sinus');
        legend('Interpolowana funkcja sinus');
    end
    hold off

    saveas(gcf, 'zadanie1.png');
end

function V = vandermonde_matrix(N)
    % Generuje macierz Vandermonde dla N równomiernie rozmieszczonych w przedziale [-1, 1] węzłów interpolacji
    x_coarse = linspace(-1,1,N);
    V = ones(N,N);
    for i = 1:N
        V(:,i) = x_coarse.^(i-1); % wypełnienie kolumn macierzy 
    end
end
