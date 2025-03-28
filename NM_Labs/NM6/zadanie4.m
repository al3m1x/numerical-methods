function [country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse, msek] = zadanie4(energy)
% Głównym celem tej funkcji jest wyznaczenie danych na potrzeby analizy dokładności aproksymacji wielomianowej.
% 
% energy - struktura danych wczytana z pliku energy.mat
% country - [String] nazwa kraju
% source  - [String] źródło energii
% x_coarse - wartości x danych aproksymowanych
% x_fine - wartości, w których wyznaczone zostaną wartości funkcji aproksymującej
% y_original - dane wejściowe, czyli pomiary produkcji energii zawarte w wektorze energy.(country).(source).EnergyProduction
% y_yearly - wektor danych rocznych
% y_approximation - tablica komórkowa przechowująca wartości nmax funkcji aproksymujących dane roczne.
%   - nmax = length(y_yearly)-1
%   - y_approximation{1,i} stanowi aproksymację stopnia i
%   - y_approximation{1,i} stanowi wartości funkcji aproksymującej w punktach x_fine
% mse - wektor mający nmax wierszy: mse(i) zawiera wartość błędu średniokwadratowego obliczonego dla aproksymacji stopnia i.
%   - mse liczony jest dla aproksymacji wyznaczonej dla wektora x_coarse
% msek - wektor mający (nmax-1) wierszy: msek zawiera wartości błędów różnicowych zdefiniowanych w treści zadania 4
%   - msek(i) porównuj aproksymacje wyznaczone dla i-tego oraz (i+1) stopnia wielomianu
%   - msek liczony jest dla aproksymacji wyznaczonych dla wektora x_fine

country = 'Italy';
source = 'Hydro';
degrees = [];
x_coarse = [];
x_fine = [];
y_original = [];
y_yearly = [];
y_approximation = [];
mse = zeros(7,1);
msek = zeros(6,1);

% Sprawdzenie dostępności danych
if isfield(energy, country) && isfield(energy.(country), source)
    % Przygotowanie danych do aproksymacji
    dates = energy.(country).(source).Dates;
    y_original = energy.(country).(source).EnergyProduction;

    % Obliczenie danych rocznych
    n_years = floor(length(y_original) / 12);
    y_cut = y_original(end-12*n_years+1:end);
    y4sum = reshape(y_cut, [12 n_years]);
    y_yearly = sum(y4sum,1)';

    degrees = [1,3,5,7]

    N = length(y_yearly);
    P = (N-1)*10+1;
    x_coarse = linspace(-1, 1, N)';
    x_fine = linspace(-1, 1, P)';

    % Pętla po wielomianach różnych stopni
    for i = 1:N-1
        p = my_polyfit(x_coarse, y_yearly, i);
        y_approximation{i} = polyval(p, x_fine);

        y_approx_coarse = polyval(p, x_coarse);
        mse(i) = sum((y_approx_coarse - y_yearly).^2) / N;

        if i < N-1
            next_p = my_polyfit(x_coarse, y_yearly, i+1);
            y_approx_fine_next = polyval(next_p, x_fine);
            msek(i) = sum((y_approximation{i} - y_approx_fine_next).^2) / P;
        end
    end

    disp(['Aproksymacja dla kraju: ', country, ', źródło: ', source]);
    for i = 1:length(degrees)
        disp(['Stopień wielomianu: ', num2str(degrees(i)), ', MSE: ', num2str(mse(i))]);
    end

    figure('Position', [20, 0, 800, 800]);
    
    subplot(3, 1, 1);
    hold on;
    plot(x_coarse, y_yearly, 'bs-', 'DisplayName', 'Roczne dane rzeczywiste');
    for i = 1:length(degrees)
        plot(x_fine, y_approximation{degrees(i)}, 'DisplayName', ['Aproksymacja stopnia ' num2str(degrees(i))]);
    end
    legend('show', 'Location', 'eastoutside');
    title('Aproksymacje rocznych danych produkcji energii');
    xlabel('Czas');
    ylabel('Produkcja energii');
    hold off;

    subplot(3, 1, 2);
    semilogy(1:N-1, mse, 'bo-');
    title('Błąd średniokwadratowy (MSE) dla różnych stopni aproksymacji');
    xlabel('Stopień wielomianu');
    ylabel('Błąd średniokwadratowy');
    grid on;

    subplot(3, 1, 3);
    semilogy(1:N-2, msek, 'ro-');
    title('Zbieżność funkcji aproksymujących (msek)');
    xlabel('Numer aproksymacji');
    ylabel('Błąd różnicowy');
    grid on;

    saveas(gcf, 'zadanie4.png');
else
    disp(['Dane dla (country=', country, ') oraz (source=', source, ') nie są dostępne.']);
end

end

function p = my_polyfit(x, y, deg)  % metoda najmniejszych kwadratów
    V = zeros(length(x), deg + 1); % macierz Vandermorta
    for i = 0:deg
        V(:, deg + 1 - i) = x.^i;
    end
    
    p = (V' * V) \ (V' * y);
end