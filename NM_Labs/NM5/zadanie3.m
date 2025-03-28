function [matrix_condition_numbers, max_coefficients_difference_1, max_coefficients_difference_2] = zadanie3()
% Zwracane są trzy wektory wierszowe:
% matrix_condition_numbers - współczynniki uwarunkowania badanych macierzy Vandermonde
% max_coefficients_difference_1 - maksymalna różnica między referencyjnymi a obliczonymi współczynnikami wielomianu,
%       gdy b zawiera wartości funkcji liniowej
% max_coefficients_difference_2 - maksymalna różnica między referencyjnymi a obliczonymi współczynnikami wielomianu,
%       gdy b zawiera zaburzone wartości funkcji liniowej

N = 5:40;

%% chart 1; 
% Współczynnik uwarunkowania macierzy - miara określająca, jak bardzo rozwiązanie układu 
% równań liniowych jest wrażliwe na zmianę wektora b w równaniu macierzowym Ax=b
matrix_condition_numbers = zeros(1, length(N));
for i = 1:length(N) % dla różnych N'ów
        ni = N(i);
        x1 = linspace(0,1,ni);
        V = vandermonde_matrix(ni, x1);
        matrix_condition_numbers(i) = cond(V); % wyznaczanie współczynnika uwarunkowania
end

figure;
subplot(3,1,1);
semilogy(N, matrix_condition_numbers, '-o'); % wykres logarytmiczny
xlabel('Rozmiar macierzy (N)');
ylabel('Wsp. uwarunkowania');
title('Wzrost współczynnika uwarunkowania macierzy Vandermonde');

%% chart 2
a1 = randi([20,30]);
max_coefficients_difference_1 = zeros(1, length(N));
for i = 1:length(N)
    ni = N(i);
    x1 = linspace(0,1,ni);
    V = vandermonde_matrix(ni, x1);
    
    % Niech wektor b zawiera wartości funkcji liniowej
    b = linspace(0,a1,ni)';
    reference_coefficients = [ 0; a1; zeros(ni-2,1) ]; % tylko a1 jest niezerowy
    
    % Wyznacznie współczynników wielomianu interpolującego
    calculated_coefficients = V \ b;

    max_coefficients_difference_1(i) = max(abs(calculated_coefficients-reference_coefficients));
end
subplot(3,1,2);
plot(N, max_coefficients_difference_1, '-o');
xlabel('Rozmiar macierzy (N)');
ylabel('Max różnica współczynników');
title('Różnica współczynników (funkcja liniowa)');

%% chart 3
% analiza stabilności numerycznej interpolacji za pomocą dodanego szumu
max_coefficients_difference_2 = zeros(1, length(N));
for i = 1:length(N)
    ni = N(i);
    x1 = linspace(0,1,ni);
    V = vandermonde_matrix(ni, x1);
    
    % Niech wektor b zawiera wartości funkcji liniowej nieznacznie zaburzone
    b = linspace(0,a1,ni)' + rand(ni,1)*1e-10;
    reference_coefficients = [ 0; a1; zeros(ni-2,1) ]; % tylko a1 jest niezerowy
    
    % Wyznacznie współczynników wielomianu interpolującego
    calculated_coefficients = V \ b;
    
    max_coefficients_difference_2(i) = max(abs(calculated_coefficients-reference_coefficients));
end
subplot(3,1,3);
plot(N, max_coefficients_difference_2, '-o');
xlabel('Rozmiar macierzy (N)');
ylabel('Max różnica współczynników');
title('Różnica współczynników (funkcja liniowa z zaburzeniami)');
saveas(gcf, 'zadanie3.png');

end

function V = vandermonde_matrix(N, x)
    % Generuje macierz Vandermonde dla N równomiernie rozmieszczonych w przedziale [-1, 1] węzłów interpolacji
    V = ones(N,N);
    for i = 1:N
        V(:,i) = x.^(i-1); % wypełnienie kolumn macierzy 
    end
end