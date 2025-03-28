load('energy.mat');

[country, source, degrees, y_original, y_approximation, mse] = zadanie1(energy);

[country, source, degrees, y_original, y_movmean, y_approximation, mse] = zadanie2(energy);

[country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse] = zadanie3(energy);

[country, source, degrees, y_original, y_yearly, y_approximation, mse, msek] = zadanie4(energy);

[country, source, degrees, y_original, y_yearly, y_approximation, mse, msek] = zadanie5(energy);