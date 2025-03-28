# Juliusz Radziszewski, Informatyka sem. IV, s193504
import copy
import matplotlib.pyplot as plt
import math
from datetime import datetime
def createDiagonalMatrix(N, a1, a2, a3):
    A = [[0] * N for _ in range(N)]
    for i in range(N):
        A[i][i] = a1
        if i > 0:
            A[i][i - 1] = a2
        if i < N - 1:
            A[i][i + 1] = a2
        if i > 1:
            A[i][i - 2] = a3
        if i < N - 2:
            A[i][i + 2] = a3
    return A

def matrixVectorMultiply(matrix, vector):
    result = [0] * len(matrix)
    for i in range(len(matrix)):
        for j in range(len(vector)):
            result[i] += matrix[i][j] * vector[j]
    return result

def matrixScalarMultiply(scalar, matrix):
    result = [[scalar * matrix[i][j] for j in range(len(matrix[0]))] for i in range(len(matrix))]
    return result

def matrixMatrixMultiply(matrix1, matrix2):
    result = [[0] * len(matrix2[0]) for _ in range(len(matrix1))]
    for i in range(len(matrix1)):
        for j in range(len(matrix2[0])):
            for k in range(len(matrix2)):
                result[i][j] += matrix1[i][k] * matrix2[k][j]
    return result

def matrixAddition(matrix1, matrix2):
    result = [[0] * len(matrix1[0]) for _ in range(len(matrix1))]
    for i in range(len(matrix1)):
        for j in range(len(matrix1[0])):
            result[i][j] = matrix1[i][j] + matrix2[i][j]

    return result

def errNorm(A, x_n, b):
    error_vector = [0] * len(b)
    for i in range(len(b)):
        for j in range(len(x_n)):
            error_vector[i] += A[i][j] * x_n[j]
        error_vector[i] -= b[i]
    norm_squared = sum(error_vector[i] ** 2 for i in range(len(b)))
    return norm_squared ** 0.5

def vectorAddition(vector1, vector2):
    result = [0] * len(vector1)
    for i in range(len(vector1)):
        result[i] = vector1[i] + vector2[i]
    return result

def vectorScalarMultiply(vector, scalar):
    result = []
    for element in vector:
        result.append(element * scalar)
    return result

def vectorAddition(vector1, vector2):
    result = []
    for i in range(len(vector1)):
        result.append(vector1[i] + vector2[i])
    return result

def forward_substitution(L, b):
    N = len(b)
    x = [0] * N
    for i in range(N):
        x[i] = (b[i] - sum(L[i][j] * x[j] for j in range(i))) / L[i][i]
    return x

def backward_substitution(U, y):
    n = len(U)
    x = [0.0] * n

    for i in range(n-1, -1, -1):
        x[i] = y[i]
        for j in range(i+1, n):
            x[i] -= U[i][j] * x[j]
        x[i] /= U[i][i]

    return x

def solveJacobi(A, N, b, max_iter):
    L = [[0] * N for _ in range(N)]
    U = [[0] * N for _ in range(N)]
    D = [[0] * N for _ in range(N)]
    for i in range(N):
        D[i][i] = A[i][i]
        for j in range(N):
            if i < j:
                U[i][j] = A[i][j]
            elif i > j:
                L[i][j] = A[i][j]

    x = [1] * N
    D_inv = [[0 if i != j else 1 / D[i][j] for j in range(N)] for i in range(N)]
    M = matrixScalarMultiply(-1, matrixMatrixMultiply(D_inv, matrixAddition(L, U)))
    bm = matrixVectorMultiply(D_inv, b)

    err_vec = []
    iter_vec = []
    start_time = datetime.now()
    for j in range(max_iter):
        x_n = vectorAddition(matrixVectorMultiply(M, x), bm)
        err_norm = errNorm(A, x_n, b)
        err_vec.append(err_norm)
        iter_vec.append(j)
        print(j, ". ", err_norm)
        if err_norm < 1e-9 or err_norm > 1e20:
            break
        x = x_n

    end_time = datetime.now()
    time = end_time - start_time
    return x, err_vec, iter_vec, time


def solveGaussSeidel(A, b, max_iter):
    N = len(A)
    L = [[0] * N for _ in range(N)]
    U = [[0] * N for _ in range(N)]
    D = [[0] * N for _ in range(N)]
    for i in range(N):
        D[i][i] = A[i][i]
        for j in range(N):
            if i < j:
                U[i][j] = A[i][j]
            elif i > j:
                L[i][j] = A[i][j]
    x = [1] * N
    DL = matrixAddition(D, L)
    bm = forward_substitution(DL, b)
    err_vec = []
    iter_vec = []
    start_time = datetime.now()
    for j in range(max_iter):
        M = matrixVectorMultiply(U, x)
        M2 = forward_substitution(DL, M)
        M3 = vectorScalarMultiply(M2, -1)
        x_n = vectorAddition(M3, bm)
        err_norm = errNorm(A, x_n, b)
        err_vec.append(err_norm)
        iter_vec.append(j)

        print(j, ". ", err_norm)
        if err_norm < 1e-9 or err_norm > 1e20:
            break
        x = x_n
    end_time = datetime.now()
    time = end_time - start_time

    return x, err_vec, iter_vec, time

def LU_Factorization(A):
    n = len(A)
    L = [[0.0] * n for _ in range(n)]
    U = copy.deepcopy(A)

    for i in range(n):
        L[i][i] = 1.0

    for i in range(n):
        for j in range(i+1, n):
            L[j][i] = U[j][i] / U[i][i]
            for k in range(i, n):
                U[j][k] -= L[j][i] * U[i][k]

    return L, U


def solveLU(A, b):
    start_time = datetime.now()
    L, U = LU_Factorization(A)
    y = forward_substitution(L, b)
    x = backward_substitution(U, y)
    end_time = datetime.now()
    time = end_time - start_time
    norm_residual = errNorm(A, x, b)
    return norm_residual, time


# Zadanie A
N = 904
a1 = 10
a2 = -1
a3 = -1
b = []
for n in range(N):
    value = math.sin(n * (4))
    b.append(value)
A = createDiagonalMatrix(N, a1, a2, a3)

# Zadanie B
print('Jacobi:')

x, err_vec, iter_vec, time = solveJacobi(A, N, b, 1000)
print(time)

plt.figure(figsize=(10, 5))
plt.plot(iter_vec, err_vec, marker='o', linestyle='-')
plt.yscale('log')
plt.xlabel('Iteracja')
plt.ylabel('Błąd')
plt.title('Jacobi')
plt.grid(True)
plt.show()

print('Gauss_Seidel:')
x, err_vec, iter_vec, time = solveGaussSeidel(A, b, 1000)
print(time)

plt.figure(figsize=(10, 5))
plt.plot(iter_vec, err_vec, marker='o', linestyle='-')
plt.yscale('log')
plt.xlabel('Iteracja')
plt.ylabel('Błąd')
plt.title('Gauss-Seidel')
plt.grid(True)
plt.show()


# Zadanie C
N = 904
a1 = 3
a2 = -1
a3 = -1
b = []
for n in range(N):
    value = math.sin(n * (4))
    b.append(value)
A = createDiagonalMatrix(N, a1, a2, a3)

print('Jacobi:')
x, err_vec, iter_vec, time = solveJacobi(A, N, b, 1000)
print(time)

plt.figure(figsize=(10, 5))
plt.plot(iter_vec, err_vec, linestyle='-')
plt.yscale('log')
plt.xlabel('Iteracja')
plt.ylabel('Błąd')
plt.title('Jacobi')
plt.grid(True)
plt.show()

print('Gauss_Seidel:')
x, err_vec, iter_vec, time = solveGaussSeidel(A, b, 1000)
print(time)

plt.figure(figsize=(10, 5))
plt.plot(iter_vec, err_vec, linestyle='-')
plt.yscale('log')
plt.xlabel('Iteracja')
plt.ylabel('Błąd')
plt.title('Gauss-Seidel')
plt.grid(True)
plt.show()


# Zadanie D
N = 904
a1 = 3
a2 = -1
a3 = -1
b = []
for n in range(N):
    value = math.sin(n * (4))
    b.append(value)
A = createDiagonalMatrix(N, a1, a2, a3)
print('LU factorization')
norm_residual, time = solveLU(A, b)
print('Norma residuum: ', norm_residual)
print('Czas obliczeń: ', time)


# Zadanie E
N = [100, 500, 1000, 2000, 3000, 4000]
n = 6
a1 = 10
a2 = -1
a3 = -1
time_jacobi = []
time_gauss = []
time_lu = []

for i in range(n):
    print('Wyniki dla N = ', N[i], ':')
    b = []
    for n in range(N[i]):
        value = math.sin(n * (4))
        b.append(value)
    A = createDiagonalMatrix(N[i], a1, a2, a3)
    x, err_vec, iter_vec, time = solveJacobi(A, N[i], b, 1000)
    time_jacobi.append(time)
    x, err_vec, iter_vec, time = solveGaussSeidel(A, b, 1000)
    time_gauss.append(time)
    norm_residual, time = solveLU(A, b)
    time_lu.append(time)

time_jacobi_seconds = [time.total_seconds() for time in time_jacobi]
time_gauss_seconds = [time.total_seconds() for time in time_gauss]
time_lu_seconds = [time.total_seconds() for time in time_lu]

bar_width = 0.2
index = list(range(len(N)))
plt.figure(figsize=(10, 6))
plt.bar(index - bar_width, time_jacobi_seconds, color='r', width=bar_width, label='Jacobi')
plt.bar(index, time_gauss_seconds, color='g', width=bar_width, label='Gauss-Seidel')
plt.bar(index + bar_width, time_lu_seconds, color='b', width=bar_width, label='Faktoryzacja LU')
plt.xticks(index, N)
plt.xlabel('Rozmiar macierzy N')
plt.ylabel('Czas wykonania (s)')
plt.title('Porównanie czasu znalezienia rozwiązania dla układów równań liniowych')
plt.legend()
plt.show()

print(time_jacobi_seconds)
print(time_gauss_seconds)
print(time_lu_seconds)


plt.figure(figsize=(10, 6))
plt.plot(N, time_jacobi_seconds, marker='o', linestyle='-', color='b', label='Jacobi')
plt.plot(N, time_gauss_seconds, marker='o', linestyle='-', color='g', label='Gauss-Seidel')
plt.plot(N, time_lu_seconds, marker='o', linestyle='-', color='y', label='Faktoryzacja LU')
plt.xlabel('Wartość N')
plt.ylabel('Czas wykonania (s)')
plt.title('Czas wykonania w zależności od N dla różnych metod')
plt.grid(True)
plt.legend()
plt.show()