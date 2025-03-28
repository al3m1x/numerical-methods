function time_delta = estimate_execution_time(N)
% time_delta - różnica pomiędzy estymowanym czasem wykonania algorytmu dla zadanej wartości N a zadanym czasem M
% N - liczba parametrów wejściowych

if N <= 0
    error('Liczba parametrow musi byc wieksza od 0.');
end
M = 5000; % [s]
est_time = (N^(16/11) + N^((pi^2) / 8)) / 1000;
time_delta = est_time - M;

end
