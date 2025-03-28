function [xsolution,ysolution,iterations,xtab,xdif] = secant_method(a,b,max_iterations,ytolerance,fun)
% a - lewa granica przedziału poszukiwań miejsca zerowego (x0=a)
% b - prawa granica przedziału poszukiwań miejsca zerowego (x1=b)
% max_iterations - maksymalna liczba iteracji działania metody siecznych
% ytolerance - wartość abs(fun(xsolution)) powinna być mniejsza niż ytolerance
% fun - nazwa funkcji, której miejsce zerowe będzie wyznaczane
%
% xsolution - obliczone miejsce zerowe
% ysolution - wartość fun(xsolution)
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution
% xtab - wektor z kolejnymi kandydatami na miejsce zerowe, począwszy od x2
% xdiff - wektor wartości bezwzględnych z różnic pomiędzy i-tym oraz (i+1)-ym elementem wektora xtab; xdiff(1) = abs(xtab(2)-xtab(1));

xsolution = 0;
ysolution = 0;
iterations = 0;
xtab = [];
xdif = [];
x0 = a; % przygotowanie wartości do początkowej iteracji
x1 = b;
f0 = fun(x0);
f1 = fun(x1);
%xtab = [x0, x1];
for i = 1:max_iterations
    xnext = x1 - (f1*(x1 - x0)) / (f1 - f0); % obliczanie kandydata na miejsce zerowe
    fnext = fun(xnext); % obliczanie wartości funkcji dla kandydata
    xtab = [xtab; xnext]; % kandydaci na miejsca zerowe
    if i>1
        xdif = [xdif; abs(xtab(end) - xtab(end - 1))]; % różnica między ostatnimi kandydatami
    end
    if abs(fnext) < ytolerance % warunki końcowe - wartość funkcji mniejsza od tolerancji
        iterations = i;
        xsolution = xnext;
        ysolution = fnext;
        return;
    end
    x0 = x1; %podmiana wartości do kolejnej iteracji
    x1 = xnext;
    f0 = f1;
    f1 = fnext;
end
end