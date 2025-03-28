function [nodes_Chebyshev, V, V2, original_Runge, interpolated_Runge, interpolated_Runge_Chebyshev] = zadanie2()
% nodes_Chebyshev - wektor wierszowy zawierający N=16 węzłów Czebyszewa drugiego rodzaju
% V - macierz Vandermonde obliczona dla 16 węzłów interpolacji rozmieszczonych równomiernie w przedziale [-1,1]
% V2 - macierz Vandermonde obliczona dla węzłów interpolacji zdefiniowanych w wektorze nodes_Chebyshev
% original_Runge - wektor wierszowy zawierający wartości funkcji Runge dla wektora x_fine=linspace(-1, 1, 1000)
% interpolated_Runge - wektor wierszowy wartości funkcji interpolującej określonej dla równomiernie rozmieszczonych węzłów interpolacji
% interpolated_Runge_Chebyshev - wektor wierszowy wartości funkcji interpolującej wyznaczonej
%       przy zastosowaniu 16 węzłów Czebyszewa zawartych w nodes_Chebyshev 
    N = 16;
    x_fine = linspace(-1, 1, 1000);
    nodes_Chebyshev = get_Chebyshev_nodes(N);
    x1 = linspace(-1,1,N);
    V = vandermonde_matrix(N, x1);
    V2 = vandermonde_matrix(N, nodes_Chebyshev);
    original_Runge = 1 ./ (1 + 25 * x_fine.^2);
    interpolated_Runge = [];
    interpolated_Runge_Chebyshev = [];

    x = nodes_Chebyshev; % węzły interpolacji
    y = 1 ./ (1 + 25 * x.^2); % wartości funkcji interpolowanej w węzłach interpolacji
    c_runge = V2 \ y'; % współczynniki wielomianu interpolującego
    interpolated_Runge_Chebyshev = polyval(flipud(c_runge), x_fine); % interpolacja, flipud odwraca kolejność wierszy, bo polyval bierze od największych potęg
    figure;
    subplot(2,1,1)
    plot(x_fine, interpolated_Runge_Chebyshev);
    hold on
    plot(x_fine, original_Runge);
    plot(x, y, 'o');
    xlabel('Wartości x (Chebyshev)');
    ylabel('Wartości funkcji(Chebyshev)');
    title('Interpolacja funkcji Runge (Chebyshev)');
    legend('Interpolowana funkcja Runge (Chebyshev)');
    hold off

    x = linspace(-1,1,N);
    y = 1 ./ (1 + 25 * x.^2);
    c_runge = V \ y';
    interpolated_Runge = polyval(flipud(c_runge), x_fine); 
    subplot(2,1,2)
    plot(x_fine, interpolated_Runge);
    hold on
    plot(x_fine, original_Runge)
    plot(x, y, 'o');
    xlabel('Wartości x');
    ylabel('Wartości funkcji');
    title('Interpolacja funkcji Runge');
    legend('Interpolowana funkcja Runge');
    hold off
    
    saveas(gcf, 'zadanie2.png');
end

function nodes = get_Chebyshev_nodes(N)
    % oblicza N węzłów Czebyszewa drugiego rodzaju
    k = 0:N-1;
    nodes = cos(k * pi / (N - 1));
end

function V = vandermonde_matrix(N, x)
    % Generuje macierz Vandermonde dla N równomiernie rozmieszczonych w przedziale [-1, 1] węzłów interpolacji
    V = ones(N,N);
    for i = 1:N
        V(:,i) = x.^(i-1); % wypełnienie kolumn macierzy 
    end
end