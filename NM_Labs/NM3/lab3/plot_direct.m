function plot_direct(N,vtime_direct)
    % N - wektor zawierający rozmiary macierzy dla których zmierzono czas obliczeń metody bezpośredniej
    % vtime_direct - czas obliczeń metody bezpośredniej dla kolejnych wartości N

    figure;
    plot(N, vtime_direct, '-o');
    title('Zależność czasu obliczeń od wielkości macierzy');
    xlabel('Wielkość macierzy [N]');
    ylabel('Czas [s]');
    grid on;
    print -dpng zadanie2.png 

end