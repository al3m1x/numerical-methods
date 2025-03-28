function[circles, index_number, circle_areas, rand_counts, counts_mean] = generate_circles(a, r_max, n_max)
index_number = 193504;
L1 = 4;
%n_max wierszy, trzy kolumny, wiersze jako X,Y,R

circles = zeros(n_max, 3);
circle_areas = zeros(1, n_max);
rand_counts = zeros(1, n_max);
counts_mean = zeros(1, n_max);


for i = 1 : n_max
    iterator = 1;
    r = rand() * r_max; %promień, losowana jest liczba z zakresu 0-1, a ta mnożona jest przez 10
    x = rand() * (a - r*2) + r; %losujemy współrzędne
    y = rand() * (a - r*2) + r;
    new_circle = [x,y,r];
    
    while ifCollision(new_circle, circles)
        iterator = iterator + 1;
        r = rand() * r_max; 
        x = rand() * (a - r*2) + r;
        y = rand() * (a - r*2) + r;
        new_circle = [x,y,r];
    end
    
    rand_counts(1, i) = iterator;

    circles(i,:) = new_circle; %dodajemy koło do macierzy kół
    if (i ~= 1)
        circle_areas(1, i) = pi * r^2 + circle_areas(1, i-1);
    else
        circle_areas(1, i) = pi * r^2;
    end
    counts_mean(1, i) = mean(rand_counts(1:i));
end

end

function [is_collision] = ifCollision(new_circle, circles)
    is_collision = false;
    for j = 1:size(circles, 1)
        %obliczanie odległości między środkami okręgów (pierwiastek z sumy
        %x^2 i y^2)
        distance = norm(new_circle(1:2) - circles(j, 1:2)); 
        
        %jeśli dystans jest mniejszy od sumy promieni okręgów, to występuje kolizja
        if distance < (new_circle(3) + circles(j, 3))
            is_collision = true;
            break;
        end
    end
    end