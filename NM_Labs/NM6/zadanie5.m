function [country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse, msek] = zadanie5(energy)
% Głównym celem tej funkcji jest wyznaczenie danych na potrzeby analizy dokładności aproksymacji cosinusowej.
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
% msek - wektor mający nmax wierszy: msek zawiera wartości błędów różnicowych zdefiniowanych w treści zadania 5
%   - msek(i) porównuj aproksymacje wyznaczone dla i-tego oraz (i+1) stopnia wielomianu
%   - msek liczony jest dla aproksymacji wyznaczonych dla wektora x_fine

country = 'Italy';
source = 'Hydro';
degrees = [];
x_coarse = [];
x_fine = [];
y_original = [];
y_yearly = [];
y_approximation = {};
mse = zeros(8,1);
mse = zeros(7,1);

% Sprawdzenie dostępności danych
if isfield(energy, country) && isfield(energy.(country), source)
    % Przygotowanie danych do aproksymacji
    dates = energy.(country).(source).Dates;
    y_original = energy.(country).(source).EnergyProduction;
    y_original_mean = movmean(y_original, [11, 0]);

    % Obliczenie danych rocznych
    n_years = floor(length(y_original) / 12);
    y_cut = y_original(end-12*n_years+1:end);
    y4sum = reshape(y_cut, [12, n_years]);
    y_yearly = sum(y4sum, 1)';

    % Przygotowanie danych do aproksymacji
    N = length(y_yearly);
    degrees = [1,3,5,7];
    P = (N-1)*8 + 1; % liczba wartości funkcji aproksymującej
    x_coarse = linspace(0, 1, N)';
    x_fine = linspace(0, 1, P)';

    % Pętla po stopniach aproksymacji
    for i = 1:N
        X = dct2_custom(y_yearly, i);
        y_approximation{i} = idct2_custom(X, i, N, P);
        mse(i) = mean((y_yearly - idct2_custom(X, i, N, N)).^2);
    
        if i < N && (i + 1) <= N
            next_X = dct2_custom(y_yearly, i+1);
            y_approx_fine_next = idct2_custom(next_X, i+1, N, P);
            msek(i) = mean((y_approx_fine_next - y_approximation{i}).^2);
        end
    end

    disp(['Aproksymacja dla kraju: ', country, ', źródło: ', source]);
    for i = 1:length(degrees)
        disp(['Stopień aproksymacji: ', num2str(degrees(i)), ', MSE: ', num2str(mse(i))]);
    end

    figure('Position', [20, 0, 800, 800]);


    subplot(3, 1, 1);
    hold on;
    plot(1:N, y_yearly, 'bs-', 'DisplayName', 'Roczne dane rzeczywiste');
    xlim([1,8])
    for i = 1:length(degrees)
        plot(x_fine*8, y_approximation{degrees(i)}, 'DisplayName', ['Aproksymacja stopnia ' num2str(degrees(i))]);
    end
    hold off;
    legend('show', 'Location', 'eastoutside');
    title('Aproksymacje rocznych danych produkcji energii');
    xlabel('Rok');
    ylabel('Produkcja energii');

    subplot(3, 1, 2);
    semilogy(1:8, mse, 'bo-');
    title('Błąd średniokwadratowy (MSE) dla różnych stopni aproksymacji cosinusowej');
    xlabel('Stopień aproksymacji');
    ylabel('Błąd średniokwadratowy');
    grid on;

    subplot(3, 1, 3);
    semilogy(1:length(msek), msek, 'ro-');
    title('Zbieżność funkcji aproksymujących (msek)');
    xlabel('Numer aproksymacji');
    ylabel('Błąd różnicowy');
    grid on;

    saveas(gcf, 'zadanie5.png');

else
    disp(['Dane dla (country=', country, ') oraz (source=', source, ') nie są dostępne.']);
end

end

function X = dct2_custom(x, kmax)
% Wyznacza kmax pierwszych współczynników DCT-2 dla wektora wejściowego x.
    N = length(x);
    X = zeros(kmax, 1);
    c2 = sqrt(2/N);
    c3 = pi/2/N;
    nn = (1:N)';

    X(1) = sqrt(1/N) * sum( x(nn) );
    for k = 2:kmax
        X(k) = c2 * sum( x(nn) .* cos(c3 * (2*(nn-1)+1) * (k-1)) );
    end
end

function x = idct2_custom(X, kmax, N, P)
% Wyznacza wartości aproksymacji cosinusowej x.
% X - współczynniki DCT
% kmax - liczba współczynników DCT zastosowanych do wyznaczenia wektora x
% N - liczba danych dla których została wyznaczona macierz X
% P - długość zwracanego wektora x (liczba wartości funkcji aproksymującej w przedziale [0,1])
    x = zeros(P, 1);
    kk = (2:kmax)';
    c1 = sqrt(1/N);
    c2 = sqrt(2/N);
    c3 = pi*(N - 1)/(2*N*(P - 1));
    c4 = -(pi*(N - P))/(2*N*(P - 1));

    for n = 1:P
        x(n) = c1*X(1) + c2*sum( X(kk) .* cos((c3*(2*(n-1)+1)+c4) * (kk-1)) );
    end
end
