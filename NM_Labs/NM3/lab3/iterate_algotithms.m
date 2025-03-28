function [time_Jacobi, iterations_Jacobi, time_Gauss_Seidel, iterations_Gauss_Seidel] = iterate_algorithms(n, N)
    time_Jacobi = ones(1,n);
    time_Gauss_Seidel = ones(1,n);
    iterations_Jacobi = ones(1,n);
    iterations_Gauss_Seidel = ones(1,n);
    L1 = 4;

    for i = 1:n
        [A,b] = generate_matrix(N(i), L1);
        [M, bm, x, err_norm, time, iterations, index_number, err_vec, iter_vec] = solve_Jacobi(N(i), A, b);
        time_Jacobi(i) = time;
        iterations_Jacobi(i) = iterations;

        [A,b] = generate_matrix(N(i), L1);
        [M, bm, x, err_norm, time, iterations, index_number, err_vec, iter_vec] = solve_Gauss_Seidel(N(i), A, b);
        time_Gauss_Seidel(i) = time;
        iterations_Gauss_Seidel(i) = iterations;
    end
end