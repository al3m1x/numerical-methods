function [lake_volume, x, y, z, zmin] = zadanie5()
    % Funkcja zadanie5 wyznacza objętość jeziora metodą Monte Carlo.
    %
    %   lake_volume - objętość jeziora wyznaczona metodą Monte Carlo
    %
    %   x - wektor wierszowy, który zawiera współrzędne x wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   y - wektor wierszowy, który zawiera współrzędne y wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   z - wektor wierszowy, który zawiera współrzędne z wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   zmin - minimalna dopuszczalna wartość współrzędnej z losowanych punktów

    N = 1e6;
    zmin = -45; % ograniczenie głębokości
    x = 100 * rand(1, N); % [m]
    y = 100 * rand(1, N); % [m]
    z = zmin + (0 - zmin) * rand(1, N); % losowana głębokość
    lake_volume = 0;

    bounding_box_volume = 100 * 100 * abs(zmin); % prostopadłościan o wymiarach 100 x 100 x 45

    for i = 1:N
        depth = get_lake_depth(x(i), y(i));
        if z(i) > depth
            lake_volume = lake_volume + 1; % jeśli punkt leży nad powierzchnią dna to iterujemy
        end
    end

    lake_volume = lake_volume / N * bounding_box_volume;
end