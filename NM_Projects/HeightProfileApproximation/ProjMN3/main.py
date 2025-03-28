import numpy as np
import csv
import matplotlib.pyplot as plt

def wczytaj_dane_csv(nazwa_pliku):
    dane = []
    with open(nazwa_pliku, mode='r', newline='') as plik_csv:
        czytnik = csv.reader(plik_csv)
        for wiersz in czytnik:
            distance = float(wiersz[0])
            height = float(wiersz[1])
            dane.append((distance, height))
    return dane

def wczytaj_dane_txt(nazwa_pliku):
    dane = []
    with open(nazwa_pliku, mode='r') as plik_txt:
        for linia in plik_txt:
            if linia.strip():
                czesci = linia.split()
                if len(czesci) == 2:
                    distance = float(czesci[0])
                    height = float(czesci[1])
                    dane.append((distance, height))
    return dane

def custom_round(value):
    if value - int(value) < 0.5:
        return int(value)
    else:
        return int(value) + 1

def custom_linspace(start, stop, num):
    if num < 2:
        return [stop]
    step = (stop - start) / (num - 1)
    return [start + step * i for i in range(num)]

def custom_linspace_int(start, stop, num):
    if num < 2:
        return [stop]
    step = (stop - start) / (num - 1)
    return [int(start + step * i) for i in range(num)]

def lagrange_nodes(data, num_nodes):
    if num_nodes < 1 or num_nodes > len(data):
        raise ValueError("Zły przedział")

    data.sort()

    indices = [custom_round(x) for x in custom_linspace(0, len(data) - 1, num_nodes)]
    indices = [int(x) for x in indices]
    nodes = [data[idx] for idx in indices]

    return nodes


def chebyshev_nodes(data, num_nodes):
    if num_nodes < 1 or num_nodes > len(data):
        raise ValueError("Zły przedział")

    data.sort()

    a, b = data[0][0], data[-1][0]

    chebyshev_indices = np.cos((2 * np.arange(num_nodes) + 1) / (2 * num_nodes) * np.pi)

    transformed_nodes = (a + b) / 2 + (b - a) / 2 * chebyshev_indices

    nodes = [(tn, data[min(range(len(data)), key=lambda i: abs(data[i][0] - tn))][1]) for tn in transformed_nodes]

    return nodes

def lagrange_interpolation(nodes, x, num_node):
    result = 0.0
    for i in range(num_node):
        xi, yi = nodes[i]
        t = yi
        for j in range(num_node):
            if j != i:
                xj, yj = nodes[j]
                t *= (x - xj) / (xi - xj)
        result += t
    return result

def print_iterpolation_nodes(nodes):
    for node in nodes:
        print('Odległość: ', node[0], ', Wysokość: ', node[1])


def custom_diff(arr):
    if len(arr) < 2:
        return np.array([])
    diff_arr = np.empty(len(arr) - 1)
    for i in range(1, len(arr)):
        diff_arr[i - 1] = arr[i] - arr[i - 1]
    return diff_arr


def custom_zeros_matrix(rows, cols):
    matrix = []
    for i in range(rows):
        matrix.append([0] * cols)
    return np.array(matrix)


def custom_zeros_vector(size):
    return [0] * size

def cubic_spline_interpolation_manual(nodes, n):
    if n > len(nodes):
        raise ValueError("Zła liczba węzłów")

    nodes.sort()
    indices = custom_linspace_int(0, len(nodes) - 1, n)
    selected_nodes = [nodes[i] for i in indices]

    x = np.array([node[0] for node in selected_nodes])
    y = np.array([node[1] for node in selected_nodes])

    num_intervals = len(selected_nodes) - 1

    h = custom_diff(x)

    A = custom_zeros_matrix(num_intervals + 1, num_intervals + 1)
    b = custom_zeros_vector(num_intervals + 1)

    A[0, 0] = 1
    A[num_intervals, num_intervals] = 1

    for i in range(1, num_intervals):
        A[i, i - 1] = h[i - 1]
        A[i, i] = 2 * (h[i - 1] + h[i])
        A[i, i + 1] = h[i]
        b[i] = 3 * ((y[i + 1] - y[i]) / h[i] - (y[i] - y[i - 1]) / h[i - 1])

    c = np.linalg.solve(A, b)

    a = y[:-1]
    b = (y[1:] - y[:-1]) / h - h * (2 * c[:-1] + c[1:]) / 3
    d = (c[1:] - c[:-1]) / (3 * h)

    splines = []
    for i in range(num_intervals):
        spline = (a[i], b[i], c[i], d[i], x[i])
        splines.append(spline)

    return splines, selected_nodes



def evaluate_spline(splines, x_val):
    for i, spline in enumerate(splines):
        a, b, c, d, x_i = spline
        if i < len(splines) - 1:
            x_next = splines[i + 1][4]
        else:
            x_next = x_i + (x_i - splines[i - 1][4])

        if x_i <= x_val <= x_next:
            dx = x_val - x_i
            return a + b * dx + c * dx ** 2 + d * dx ** 3
    return None



nazwa_pliku = 'Data/MountEverest.csv'
everest_data = wczytaj_dane_csv(nazwa_pliku)

num_nodes = [3,6,9,15]
print("Trasa na Mount Everest")
for num_node in num_nodes:
    print('Dane dla n =', num_node, 'węzłów')
    nodes = lagrange_nodes(everest_data, num_node)

    x_vals = custom_linspace(min(everest_data, key=lambda x: x[0])[0], max(everest_data, key=lambda x: x[0])[0], 1000)
    y_vals = np.array([lagrange_interpolation(nodes, x, num_node) for x in x_vals])

    x_data = [d[0] for d in everest_data]
    y_data = [d[1] for d in everest_data]

    print_iterpolation_nodes(nodes)

    plt.figure(figsize=(11, 7))
    plt.plot(x_vals, y_vals, label='Funkcja interpolująca', color='blue')
    plt.plot(x_data, y_data, label='Dane oryginalne', color='green')
    plt.scatter([d[0] for d in nodes], [d[1] for d in nodes], label='Węzły interpolacji', color='red')
    plt.title(f'Interpolacja wielomianowa Lagrangea (Mount Everest, n = {num_node} węzłów)')
    plt.xlabel('Dystans [m]')
    plt.ylabel('Wysokość [m]')
    plt.legend()
    plt.grid(True)
    plt.savefig(f'Wykresy/MountEverestLagrange_{num_node}.png')
    plt.show()

nazwa_pliku = 'Data/tczew_starogard.txt'
tczstg_data = wczytaj_dane_txt(nazwa_pliku)

num_nodes = [3,6,9,15]
print("Trasa Tczew-Starogard")
for num_node in num_nodes:
    print('Dane dla n =', num_node, 'węzłów')
    nodes = lagrange_nodes(tczstg_data, num_node)

    x_vals = custom_linspace(min(tczstg_data, key=lambda x: x[0])[0], max(tczstg_data, key=lambda x: x[0])[0], 1000)
    y_vals = np.array([lagrange_interpolation(nodes, x, num_node) for x in x_vals])

    x_data = [d[0] for d in tczstg_data]
    y_data = [d[1] for d in tczstg_data]

    print_iterpolation_nodes(nodes)

    plt.figure(figsize=(11, 7))
    plt.plot(x_vals, y_vals, label='Funkcja interpolująca', color='blue')
    plt.plot(x_data, y_data, label='Dane oryginalne', color='green')
    plt.scatter([d[0] for d in nodes], [d[1] for d in nodes], label='Węzły interpolacji', color='red')
    plt.title(f'Interpolacja wielomianowa Lagrangea (Tczew-Starogard, n = {num_node} węzłów)')
    plt.xlabel('Dystans [m]')
    plt.ylabel('Wysokość [m]')
    plt.legend()
    plt.grid(True)
    plt.savefig(f'Wykresy/TczewStarogardLagrange_{num_node}.png')
    plt.show()


nazwa_pliku = 'Data/MountEverest.csv'
nodes = wczytaj_dane_csv(nazwa_pliku)

num_nodes = [3,10,30,100]
print("Funkcje sklejane 3-stopnia dla trasy na Mount Everest")
for n in num_nodes:
    splines, selected_nodes = cubic_spline_interpolation_manual(nodes, n)

    x = np.array([node[0] for node in nodes])
    y = np.array([node[1] for node in nodes])

    x_new = custom_linspace(x.min(), x.max(), 1000)
    y_new = [evaluate_spline(splines, xi) for xi in x_new]

    plt.figure(figsize=(11, 7))
    plt.scatter([node[0] for node in selected_nodes], [node[1] for node in selected_nodes], color='red', label='Węzły')
    plt.plot(x, y, '-', label='Punkty dane', color='blue')
    plt.plot(x_new, y_new, '-', label='Interpolacja sklejana', color='green')
    plt.title(f'Interpolacja funkcjami sklejanymi 3-stopnia (Mount Everest, n = {n} węzłów)')
    plt.xlabel('Dystans [m]')
    plt.ylabel('Wysokość [m]')
    plt.legend()
    plt.savefig(f'Wykresy/MountEverestSpline_{n}.png')
    plt.show()

nazwa_pliku = 'Data/tczew_starogard.txt'
nodes = wczytaj_dane_txt(nazwa_pliku)

num_nodes = [3,10,30,100]
print("Funkcje sklejane 3-stopnia dla trasy Tczew-Starogard")
for n in num_nodes:
    splines, selected_nodes = cubic_spline_interpolation_manual(nodes, n)

    x = np.array([node[0] for node in nodes])
    y = np.array([node[1] for node in nodes])

    x_new = custom_linspace(x.min(), x.max(), 1000)
    y_new = [evaluate_spline(splines, xi) for xi in x_new]

    plt.figure(figsize=(11, 7))
    plt.scatter([node[0] for node in selected_nodes], [node[1] for node in selected_nodes], color='red', label='Węzły')
    plt.plot(x, y, '-', label='Punkty dane', color='blue')
    plt.plot(x_new, y_new, '-', label='Interpolacja sklejana', color='green')
    plt.title(f'Interpolacja funkcjami sklejanymi 3-stopnia (Tczew-Starogard, n = {n} węzłów)')
    plt.xlabel('Dystans [m]')
    plt.ylabel('Wysokość [m]')
    plt.legend()
    plt.savefig(f'Wykresy/TczewStarogardSpline_{n}.png')
    plt.show()


nazwa_pliku = 'Data/MountEverest.csv'
everest_data = wczytaj_dane_csv(nazwa_pliku)

num_nodes = [3,6,9,15,30,100]
print("Trasa na Mount Everest")
for num_node in num_nodes:
    print('Dane dla n =', num_node, 'węzłów')
    nodes = chebyshev_nodes(everest_data, num_node)

    x_vals = custom_linspace(min(everest_data, key=lambda x: x[0])[0], max(everest_data, key=lambda x: x[0])[0], 1000)
    y_vals = np.array([lagrange_interpolation(nodes, x, num_node) for x in x_vals])

    x_data = [d[0] for d in everest_data]
    y_data = [d[1] for d in everest_data]

    print_iterpolation_nodes(nodes)

    plt.figure(figsize=(11, 7))
    plt.plot(x_vals, y_vals, label='Funkcja interpolująca', color='blue')
    plt.plot(x_data, y_data, label='Dane oryginalne', color='green')
    plt.scatter([d[0] for d in nodes], [d[1] for d in nodes], label='Węzły interpolacji', color='red')
    plt.title(f'Interpolacja wielomianowa Lagrangea z węzłami Chebysheva (Mount Everest, n = {num_node} węzłów)')
    plt.xlabel('Dystans [m]')
    plt.ylabel('Wysokość [m]')
    plt.legend()
    plt.grid(True)
    plt.savefig(f'Wykresy/MountEverestLagrangeChebyshev_{num_node}.png')
    plt.show()

nazwa_pliku = 'Data/tczew_starogard.txt'
tczstg_data = wczytaj_dane_txt(nazwa_pliku)

num_node = 100
print("Trasa Tczew-Starogrd")
print('Dane dla n =', num_node, 'węzłów')
nodes = chebyshev_nodes(tczstg_data, num_node)

x_vals = custom_linspace(min(tczstg_data, key=lambda x: x[0])[0], max(tczstg_data, key=lambda x: x[0])[0], 1000)
y_vals = np.array([lagrange_interpolation(nodes, x, num_node) for x in x_vals])

x_data = [d[0] for d in tczstg_data]
y_data = [d[1] for d in tczstg_data]

print_iterpolation_nodes(nodes)

plt.figure(figsize=(11, 7))
plt.plot(x_vals, y_vals, label='Funkcja interpolująca', color='blue')
plt.plot(x_data, y_data, label='Dane oryginalne', color='green')
plt.scatter([d[0] for d in nodes], [d[1] for d in nodes], label='Węzły interpolacji', color='red')
plt.title(f'Interpolacja wielomianowa Lagrangea z węzłami Chebysheva (Tczew-Starogard, n = {num_node} węzłów)')
plt.xlabel('Dystans [m]')
plt.ylabel('Wysokość [m]')
plt.legend()
plt.grid(True)
plt.savefig(f'Wykresy/TczewStarogardLagrangeChebyshev_{num_node}.png')
plt.show()