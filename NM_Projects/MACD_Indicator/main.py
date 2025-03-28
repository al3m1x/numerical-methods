import pandas as pd
import matplotlib.pyplot as plt

def emaCalculations(data, N):
    alfa = 2/(N+1)
    EMA = data.ewm(alpha=alfa, adjust=False).mean() # obliczanie wykładniczej średniej kroczącej
    return EMA

def macdCalculations(data, N1, N2, Ns):
    EMA_1 = emaCalculations(data, N1)
    EMA_2 = emaCalculations(data, N2)
    MACD = EMA_1 - EMA_2
    signal = emaCalculations(MACD, Ns)
    return MACD, signal

def find_buy_sell_points(data, MACD, signal):
    buy_points = []
    sell_points = []

    for i in range(1, len(data)):
        #iloc umożliwia dostęp do poszczególnych wartości w kolumnie dla i-tego wiersza (MACD i signal to obiekty DataFrame z biblioteki pandas)
        if MACD.iloc[i] > signal.iloc[i] and MACD.iloc[i - 1] <= signal.iloc[i - 1]: # warunek sprzedaży
            sell_points.append((data.index[i], data['Price'].iloc[i]))
        elif MACD.iloc[i] < signal.iloc[i] and MACD.iloc[i - 1] >= signal.iloc[i - 1]: # warunek kupna
            buy_points.append((data.index[i], data['Price'].iloc[i]))

    buy_dates, buy_prices = zip(*buy_points) # rozpakowywanie listy punktów na dwie osobne listy
    sell_dates, sell_prices = zip(*sell_points)

    return buy_dates, buy_prices, sell_dates, sell_prices, buy_points, sell_points

def trading(data, all_points, initial_capital):
    capital = initial_capital  # kapitał reprezentuje nasze pieniądze
    portfolio = 0  # potrfolio reprezentuje ilość naszych akcji
    balance_history = [(data.index[-1], capital)]  # zapisujemy pierwszy wpis balansu jako ostatnią datę z pliku csv (czyli najstarszą) z początkowym kapitałem
    balance_noalgorithm = [(data.index[-1], capital)]
    reversed_data = list(reversed(list(data.iterrows())))  # przekształcam DataFrame na listę, którą można odwrócić

    for date, price in reversed_data:  # iterujemy od drugiej strony
        if (date, price['Price']) in buy_points:  # sprawdzamy czy jest to punkt kupna
            portfolio += capital / price['Price']
            capital = 0
        elif (date, price['Price']) in sell_points:  # sprawdzamy czy jest to punkt sprzedaży
            capital += portfolio * price['Price']
            portfolio = 0
        balance_history.append((date, capital + portfolio * price['Price']))  # sumujemy nasz kapitał i portfolio giełdowe pomnożone przez obecną cenę akcji/surowca

    capital = initial_capital  # kapitał reprezentuje nasze pieniądze
    portfolio = capital / data.iloc[-1]['Price']  # inicjalizacja portfela na podstawie ceny akcji na początku

    reversed_data_noalgorithm = list(reversed(list(data.iterrows())))
    for date, price in reversed_data_noalgorithm:  # iterujemy odwróconą koleją dla drugiej pętli
        balance_noalgorithm.append((date, portfolio * price['Price']))

    return balance_history, balance_noalgorithm


def plot_buy_sell_points(data, buy_dates, buy_prices, sell_dates, sell_prices, text):
    plt.figure(figsize=(12, 6))
    plt.plot(data.index, data['Price'], color='blue', linewidth=1, label='Cena zamknięcia')
    plt.scatter(buy_dates, buy_prices, color='green', label='Punkt kupna', zorder=4)
    plt.scatter(sell_dates, sell_prices, color='red', label='Punkt sprzedaży', zorder=4)
    plt.title(text)
    plt.xlabel('Data')
    plt.ylabel('Cena zamknięcia [USD]')
    plt.legend()
    plt.grid(True) # siatka
    plt.show()

def plot_MACD_with_signals(data, MACD, signal, buy_points, sell_points, text):
    plt.figure(figsize=(12, 6))
    plt.plot(data.index, MACD, label='MACD', color='blue', linewidth=1)
    plt.plot(data.index, signal, label='SIGNAL', color='red', linewidth=1)

    for date, price in sell_points: # dodanie znaczników dla punktów sprzedaży
        plt.scatter(date, MACD.loc[date], color='red', marker='o', zorder=4) # zaznaczamy punkt gdzie znajduje się wykres MACD dla danej daty
    for date, price in buy_points:  # dodanie znaczników dla punktów kupna
        plt.scatter(date, MACD.loc[date], color='green', marker='o', zorder=4)

    plt.title(text)
    plt.xlabel('Data')
    plt.ylabel('Wartość')
    plt.legend()
    plt.grid(True)
    plt.show()

def plot_balance_history(balance_history, balance_noalgorithm):
    plt.figure(figsize=(12, 6))
    dates, balances = zip(*balance_history)
    plt.plot(dates, balances, color='blue', linewidth=1, label='Z algorytmem')  # saldo z algorytmem
    dates_noalgo, balances_noalgo = zip(*balance_noalgorithm)
    plt.plot(dates_noalgo, balances_noalgo, color='gray', linewidth=1, linestyle='--', label='Bez algorytmu')  # saldo bez algorytmu (na szaro)
    plt.title('Saldo konta w czasie')
    plt.xlabel('Data')
    plt.ylabel('Saldo konta')
    plt.legend()
    plt.grid(True)
    plt.show()

data = pd.read_csv('MarketData/Gold Futures Historical Data.csv', decimal='.', thousands=',') # wczytujemy dane notowań złota na giełdzie z pliku csv

data['Date'] = pd.to_datetime(data['Date']) # funkcja z pandas, która formatuje stringa do obiektu daty
data.set_index('Date', inplace=True) # indeksacja wierszy na podstawie dat
# obliczanie MACD dla złota
MACD, signal = macdCalculations(data['Price'], 12, 26, 9)
# wykrywanie punktów sprzedaży i kupna złota
buy_dates, buy_prices, sell_dates, sell_prices, buy_points, sell_points = find_buy_sell_points(data, MACD, signal)
# wykres ceny zamknięcia złota z punktami kupna i sprzedaży
plot_buy_sell_points(data, buy_dates, buy_prices, sell_dates, sell_prices, 'Wykres ceny zamknięcia złota z punktami kupna i sprzedaży')
# wykres MACD i sygnału z punktami kupna i sprzedaży
plot_MACD_with_signals(data, MACD, signal, buy_points, sell_points, 'Wykres MACD i sygnału dla Złota z punktami kupna i sprzedaży')
# łączenie punktów kupna i sprzedaży oraz sortowanie według daty
all_points = buy_points + sell_points
all_points.sort(key=lambda x: x[0])
balance_history, balance_noalgorithm = trading(data, all_points, 1000)
plot_balance_history(balance_history, balance_noalgorithm)
dates, balances_macd = zip(*balance_history)
dates, balances_noalg = zip(*balance_noalgorithm)
print("Gold Futures")
print("Początkowe fundusze: ", 1000)
print("Fundusze końcowe z użyciem MACD: ", balances_macd[-1])
print("Fundusze bez algorytmu automatycznej sprzedaży: ", balances_noalg[-1])

data = pd.read_csv('MarketData/Hyundai Motor Historical Data (KRW).csv', decimal='.', thousands=',') # wczytujemy dane notowań firmy Hyundai na giełdzie z pliku csv
data['Date'] = pd.to_datetime(data['Date']) # funkcja z pandas, która formatuje stringa do obiektu daty
data.set_index('Date', inplace=True) # indeksacja wierszy na podstawie dat
# obliczanie MACD dla firmy Hyundai
MACD, signal = macdCalculations(data['Price'], 12, 26, 9)
# wykrywanie punktów sprzedaży i kupna akcji firmy Hyundai
buy_dates, buy_prices, sell_dates, sell_prices, buy_points, sell_points = find_buy_sell_points(data, MACD, signal)
# wykres ceny zamknięcia akcji firmy Hyundai z punktami kupna i sprzedaży
plot_buy_sell_points(data, buy_dates, buy_prices, sell_dates, sell_prices, 'Wykres ceny zamknięcia akcji firmy Hyundai z punktami kupna i sprzedaży')
# wykres MACD i sygnału z punktami kupna i sprzedaży
plot_MACD_with_signals(data, MACD, signal, buy_points, sell_points, 'Wykres MACD i sygnału dla akcji firmy Hyundai z punktami kupna i sprzedaży')
# łączenie punktów kupna i sprzedaży oraz sortowanie według daty
all_points = buy_points + sell_points
all_points.sort(key=lambda x: x[0]) # sortowanie według pierwszego elementu, czyli w tym przypadku daty, żeby wykonywać wszystkie transakcje w odpowiedniej kolejności
balance_history, balance_noalgorithm = trading(data, all_points, 1000)
plot_balance_history(balance_history, balance_noalgorithm)
dates, balances_macd = zip(*balance_history)
dates, balances_noalg = zip(*balance_noalgorithm)
print("Hyundai Motors")
print("Początkowe fundusze: ", 1000)
print("Fundusze końcowe z użyciem MACD: ", balances_macd[-1])
print("Fundusze bez algorytmu automatycznej sprzedaży: ", balances_noalg[-1])

data = pd.read_csv('MarketData/Platinum Futures Historical Data (USD).csv', decimal='.', thousands=',') # wczytujemy dane notowań platyny na giełdzie z pliku csv
data['Date'] = pd.to_datetime(data['Date']) # funkcja z pandas, która formatuje stringa do obiektu daty
data.set_index('Date', inplace=True) # indeksacja wierszy na podstawie dat
# obliczanie MACD dla platyny
MACD, signal = macdCalculations(data['Price'], 12, 26, 9)
# wykrywanie punktów sprzedaży i kupna akcji firmy Hyundai
buy_dates, buy_prices, sell_dates, sell_prices, buy_points, sell_points = find_buy_sell_points(data, MACD, signal)
# wykres ceny zamknięcia platyny z punktami kupna i sprzedaży
plot_buy_sell_points(data, buy_dates, buy_prices, sell_dates, sell_prices, 'Wykres ceny zamknięcia platyny z punktami kupna i sprzedaży')
# wykres MACD i sygnału z punktami kupna i sprzedaży
plot_MACD_with_signals(data, MACD, signal, buy_points, sell_points, 'Wykres MACD i sygnału dla platyny z punktami kupna i sprzedaży')
# łączenie punktów kupna i sprzedaży oraz sortowanie według daty
all_points = buy_points + sell_points
all_points.sort(key=lambda x: x[0]) # sortowanie według pierwszego elementu, czyli w tym przypadku daty, żeby wykonywać wszystkie transakcje w odpowiedniej kolejności
balance_history, balance_noalgorithm = trading(data, all_points, 1000)
plot_balance_history(balance_history, balance_noalgorithm)
dates, balances_macd = zip(*balance_history)
dates, balances_noalg = zip(*balance_noalgorithm)
print("Platinum Futures")
print("Początkowe fundusze: ", 1000)
print("Fundusze końcowe z użyciem MACD: ", balances_macd[-1])
print("Fundusze bez algorytmu automatycznej sprzedaży: ", balances_noalg[-1])