function [M,bm,x,err_norm,time,iterations,index_number, err_vec, iter_vec] = solve_Gauss_Seidel(N, A, b)
% A - macierz rzadka z równania macierzowego A * x = b
% b - wektor prawej strony równania macierzowego A * x = b
% M - macierz pomocnicza opisana w instrukcji do Laboratorium 3 – sprawdź wzór (7) w instrukcji, który definiuje M jako M_{GS}
% bm - wektor pomocniczy opisany w instrukcji do Laboratorium 3 – sprawdź wzór (7) w instrukcji, który definiuje bm jako b_{mGS}
% x - rozwiązanie równania macierzowego
% err_norm - norma błędu residualnego wyznaczona dla rozwiązania x; err_norm = norm(A*x-b);
% time - czas wyznaczenia rozwiązania x
% iterations - liczba iteracji wykonana w procesie iteracyjnym metody Gaussa-Seidla
% index_number - Twój numer indeksu
index_number = 193504;
L1 = 4;
x = ones(N, 1);
D = diag(diag(A));
L = tril(A, -1);
U = triu(A, 1);

M = -(D + L) \ U;
bm = (D + L) \ b;

time = [];
iterations = [];
err_norm = 1;
err_vec = [];
iter_vec = [];

max_iter = 1000;
tic;
for iterations = 1:max_iter
    x_new = M * x + bm;
    err_norm = norm(A * x_new - b);
    err_vec(iterations) = err_norm;
    iter_vec(iterations) = iterations;
    disp(iterations + ". " + err_norm);
    if err_norm < 1e-12
        break;
    end
    x = x_new;
end
time = toc;

end