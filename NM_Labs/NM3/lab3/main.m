index = 193504;
L1 = 4;
N = 100;
[A,b] = generate_matrix(N, L1);
[x,time_direct,err_norm,index_number] = solve_direct(N, A, b);
disp("Błąd: " + err_norm);
disp("Czas: " + time_direct);

N = 1000:1000:8000;
n = length(N);
vtime_direct = ones(1,n); 

for i = 1:n
    [A,b] = generate_matrix(N(i), L1);
    [x, time_direct, err_norm, index_number] = solve_direct(N(i), A, b);
    vtime_direct(i) = time_direct;
end

plot_direct(N,vtime_direct);

N = 100;
[A,b] = generate_matrix(N, L1);
[M,bm,x,err_norm,time,iterations,index_number,err_vec, iter_vec] = solve_Jacobi(N, A, b);
disp("Czas: " + time);

N = 100;
[A,b] = generate_matrix(N, L1);
[M,bm,x,err_norm,time,iterations,index_number,err_vec, iter_vec] = solve_Gauss_Seidel(N, A, b);
disp("Czas: " + time);

N = 1000:1000:8000;
n = length(N);
[time_Jacobi, iterations_Jacobi, time_Gauss_Seidel, iterations_Gauss_Seidel] = iterate_algotithms(n, N);

plot_problem_5(N,time_Jacobi,time_Gauss_Seidel,iterations_Jacobi,iterations_Gauss_Seidel);

% Zadanie 6
N = 20000;
load("filtr_dielektryczny.mat");
[x, time_direct, err_norm_dir, index_number] = solve_direct(N, A, b);
[M,bm,x,err_norm_jac,time_jac,iterations_jac,index_number, err_vec_jac, iter_vec_jac] = solve_Jacobi(N, A, b);
[M,bm,x,err_norm_gau,time_gau,iterations_gau,index_number, err_vec_gau, iter_vec_gau] = solve_Gauss_Seidel(N, A, b);
disp("Błąd dla metody bezpośredniej: " + err_norm_dir);
disp("Czas dla metody bezpośredniej: " + time_direct);
disp("Błąd dla metody Jacobiego: " + err_norm_jac);
disp("Czas dla metody Jacobiego: " + time_jac);
disp("Liczba iteracji dla metody Jacobiego: " + iterations_jac);
disp("Błąd dla metody Gaussa-Seidla: " + err_norm_gau);
disp("Czas dla metody Gaussa-Seidla: " + time_gau);
disp("Liczba iteracji dla metody Gaussa-Seidla: " + iterations_gau);

plot_microwaves(err_vec_jac, iter_vec_jac, err_vec_gau, iter_vec_gau);
