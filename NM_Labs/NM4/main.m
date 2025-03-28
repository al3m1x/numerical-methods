% ZADANIE 1
omega = 10
impedance_delta = impedance_magnitude(omega)

% ZADANIE 2
format long % zmiana sposobu wyświetlania liczb zmiennoprzecinkowych (15 cyfr po przecinku)
f = @(x) x.^2 - 4.01; % funkcja
a = 0;
b = 4;
max_iterations = 100;
ytolerance = 1e-12;
[xsolution,ysolution,iterations,xtab,xdif] = bisection_method(a,b,max_iterations,ytolerance,f)

% ZADANIE 3
format long
f = @(x) x.^2 - 4.01;
a = 0;
b = 4;
max_iterations = 100;
ytolerance = 1e-12;
[xsolution,ysolution,iterations,xtab,xdif] = secant_method(a,b,max_iterations,ytolerance,f)

% ZADANIE 4
impedanceRLC();

% ZADANIE 5
time = 10 
velocity_delta = rocket_velocity(time)

% ZADANIE 6
rocketT();

% ZADANIE 7
N = 40000;
time_delta = estimate_execution_time(N)

% ZADANIE 8
designateNforT();

% ZADANIE 9
options = optimset('Display', 'iter'); % wyświetlanie informacji o iteracjach
fzero(@tan, 6, options); % szukanie miejsca zerowego tan dla x0 = 6

options = optimset('Display', 'iter');
fzero(@tan, 4.5, options);