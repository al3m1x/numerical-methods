function [country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse] = zadanie3(energy)
% Głównym celem tej funkcji jest wyznaczenie aproksymacji rocznych danych o produkcji energii elektrycznej w wybranym kraju i z wybranego źródła energii.
% Wybór kraju i źródła energii należy określić poprzez nadanie w tej funkcji wartości zmiennym typu string: country, source.
% Dopuszczalne wartości tych zmiennych można sprawdzić poprzez sprawdzenie zawartości struktury energy zapisanej w pliku energy.mat.
% 
% energy - struktura danych wczytana z pliku energy.mat
% country - [String] nazwa kraju
% source  - [String] źródło energii
% degrees - wektor zawierający cztery stopnie wielomianu dla których wyznaczono aproksymację
% x_coarse - wartości x danych aproksymowanych; wektor o rozmiarze [N,1].
% x_fine - wartości, w których wyznaczone zostaną wartości funkcji aproksymującej; wektor o rozmiarze [P,1].
% y_original - dane wejściowe, czyli pomiary produkcji energii zawarte w wektorze energy.(country).(source).EnergyProduction
% y_yearly - wektor danych rocznych (wektor kolumnowy).
% y_approximation - tablica komórkowa przechowująca cztery wartości funkcji aproksymującej dane roczne.
%   - y_approximation{i} stanowi aproksymację stopnia degrees(i)
%   - y_approximation{i} stanowi wartości funkcji aproksymującej w punktach x_fine.
% mse - wektor o rozmiarze [4,1]: mse(i) zawiera wartość błędu średniokwadratowego obliczonego dla aproksymacji stopnia degrees(i).

country = 'Italy';
source = 'Hydro';
degrees = 1:4;
x_coarse = [];
x_fine = [];
y_original = [];
y_yearly = [];
y_approximation = [];
mse = zeros(1,4);

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

    degrees = 1:4;

    N = length(y_yearly);
    P = 10*N;
    x_coarse = linspace(-1, 1, N)';
    x_fine = linspace(-1, 1, P)';

    % Pętla po wielomianach różnych stopni
    for i = 1:length(degrees)
        p = my_polyfit(x_coarse, y_yearly, degrees(i))
        y_approximation{i} = polyval(p, x_fine)
        y_approx_coarse = polyval(p, x_coarse);
        mse(i) = sum((y_approx_coarse - y_yearly).^2) / N;

    end

    disp(['Aproksymacja dla kraju: ', country, ', źródło: ', source]);
    for i = 1:length(degrees)
        disp(['Stopień wielomianu: ', num2str(degrees(i)), ', MSE: ', num2str(mse(i))]);
    end

    figure('Position', [20, 0, 800, 800]);
    
    subplot(2, 1, 1);
    hold on;
    plot(x_coarse, y_yearly, 'bs-', 'DisplayName', 'Roczne dane rzeczywiste'); hold on;
    for i = 1:length(degrees)
        plot(x_fine, y_approximation{degrees(i)}, 'DisplayName', ['Aproksymacja stopnia ' num2str(degrees(i))]);
    end
    legend('show', 'Location', 'eastoutside');
    title('Aproksymacje rocznych danych produkcji energii');
    xlabel('Czas');
    ylabel('Produkcja energii');
    hold off;

    subplot(2, 1, 2);
    bar(degrees, mse);
    title('Błąd średniokwadratowy (MSE) dla różnych stopni aproksymacji');
    xlabel('Stopień wielomianu');
    ylabel('Błąd średniokwadratowy');
    
    saveas(gcf, 'zadanie3.png');


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