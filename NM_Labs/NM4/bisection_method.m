function [xsolution,ysolution,iterations,xtab,xdif] = bisection_method(a,b,max_iterations,ytolerance,fun)
% a - lewa granica przedziału poszukiwań miejsca zerowego
% b - prawa granica przedziału poszukiwań miejsca zerowego
% max_iterations - maksymalna liczba iteracji działania metody bisekcji
% ytolerance - wartość abs(fun(xsolution)) powinna być mniejsza niż ytolerance
% fun - nazwa funkcji, której miejsce zerowe będzie wyznaczane
%
% xsolution - obliczone miejsce zerowe
% ysolution - wartość fun(xsolution)
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution
% xtab - wektor z kolejnymi kandydatami na miejsce zerowe, począwszy od xtab(1)= (a+b)/2
% xdiff - wektor wartości bezwzględnych z różnic pomiędzy i-tym oraz (i+1)-ym elementem wektora xtab; xdiff(1) = abs(xtab(2)-xtab(1));

xsolution = 0;
ysolution = 0;
iterations = 0;
xtab = [];
xdif = [];

for i=1:max_iterations
    c = (a + b) / 2; % środkowa wartość przedziału
    f_c = fun(c); % obliczanie wartości funkcji dla środka przedziału

    xtab = [xtab; c]; % kandydaci na miejsca zerowe
    if i > 1
        xdif = [xdif; abs(xtab(end) - xtab(end - 1))]; % różnica między ostatnimi kandydatami
    end
    if abs(f_c) < ytolerance || abs(b - a) < ytolerance % sprawdzamy czy warunek końcowy nie został spełniony
        xsolution = c;
        ysolution = f_c;
        iterations = i;
        return;
    elseif fun(a) * f_c < 0 % wybieramy nowy przedział
        b = c; % ucinamy prawą stronę
    else
        a = c; % ucinamy lewą stronę
    end
end


end
