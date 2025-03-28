function [numer_indeksu, Edges, I, B, A, b, r] = page_rank()
numer_indeksu = 193504;
Edges = [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6, 6, 7, 8;
         6, 4, 4, 3, 5, 6, 5, 7, 5, 6, 6, 4, 7, 4, 8, 6, 1];
d = 0.85;
n = max(Edges(:))

I = speye(n);
B = sparse(Edges(2,:), Edges(1, :), 1, n, n);
A = spdiags(1./(sum(B))', 0, n, n);
b = ((1 - d) / n) * ones(n, 1);
r = ((I - d * B * A) \ b);


end