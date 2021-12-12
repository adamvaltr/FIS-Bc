# Klient

- Adresář: `/client`

Popis programu napsaného v jazyce `Python`, který slouží ke generování a odesílání dat do databázového serveru pomocí `HTTP POST` požadavků.

## Použití

Program je zamýšlen jako generátor dat, běžící v nekonečné smyčce na zařízení s přístupem k internetu, aby mohl vygenerovaná data v patřičném formátu odesílat na `API` databázového serveru.

Program se spouští bez argumentů, např. příkazem `python3 main.py`. Součástí programu je konfigurační soubor `options.json`, který musí být nutně umístěn ve stejném adresáři jako samotný program. Před samotným spuštěním programu by měl uživatel upravit konfigurační soubor, aby odpovídal jeho specifickým podmínkám.

### Konfigurační soubor

Tento soubor je načten při spuštění programu `main.py`. Názvy jednotlivých klíčů není možné změnit bez korespondující změny ve zdrojovém kódu programu - jinak program nebude fungovat. Pokud neplánujete měnit samotný program, upravujte pouze hodnoty pod klíči. Dostupná nastavení jsou:

| Nastavení     | Popis                                                                                         |
|---------------|-----------------------------------------------------------------------------------------------|
| `protocol`    |   http nebo https                                                                             |
| `domain`      |   doménové jméno směřující na adresu Vaší InfluxDB instance. Lze zadat přímo `IPv4` adresu    |
| `port`        |   `TCP/IP` port na kterém je InfluxDB dostupná. Defaultně `8086`                              |
| `org`         |   název organizace, který byl zadán při tvorbě databáze                                       |
| `bucket`      |   název kbelíku, který byl zadán při tvorbě databáze                                          |
| `precision`   |   přesnost s jakou databáze k příchozím datům přiřadí časovou značku (`us, ns, ms, s`)        |
| `token`       |   `API Token` autorizující klienta k zápisu do uvedeného kbelíku databáze                     |
| `period`      |   čas v sekundách definující prodlevu mezi iteracemi generování a odesílání dat               |

### Spuštění

Jelikož program běží v nekonečné smyčce, je vhodné ho sputit na pozadí. Pokud například chceme program spustit na vzdáleném zařízení, ke kterému přistupujeme přes `SSH`, pak je nutné proces, který spuštěním programu vznikne, oddělit od samotné `SSH session`, jinak by byl proces při ukončení `session` terminován. Na zařízení s operařním systémem Linux toho lze docílit například použitím `setsid`, které procesu vytvoří vlastní `session`. Výsledný příkaz pak může vypadat takto: `setsid python3 main.py`.

Vhodným zařízením pro spuštění programu je takové, které funguje v nepřetržitém provozu. Tím bude zabezpečeno, že nedojde k ukončení programu a tedy přerušení odesílání dat do databáze. Pro toto použití je vhodné např. `Raspberry Pi` apod.

------------

## Program `main.py`

Fungování programu bylo testováno na Debian 11 s Python verze 3.9.

Použité balíčky:
- json
- time
- random
- requests

### Práce s daty

Data, která se odesílají do databáze jsou popsána slovníkem `data_structure`. Tato data představují ilustrativní senzory, kterými bývají běžně osazeny malé vodní elektrárny. Jsou to měřídla výkonu generátorů, hladinové sondy a teplotní čidla. Slovník obsahuje celkem deset sond - dvě měřidla výkonu, čtyři hladinové sondy a čtyři teplotní čidla. Myšlená MVE, kterou se data snaží ilustrovat, je osazena dvěma turbínovými soustrojími. Na každé soustrojí tak připadá jedno měřidlo výkonu, dvě hladinové sondy a dvě teplotní čidla.

Každy senzor je ve slovníku reprezentován klíčem. Hodnotou každého klíče je pak vnořený slovník, který obsahuje dva tagy a měřenou hodnotu typu `integer`. Tagy určují k jakému soustrojí daný senzor patří a o jaký typ senzoru se jedná.

#### Seznam senzorů

- `merVykonu1`
- `merVykonu2`
- `merHladiny1`
- `merHladiny2`
- `merHladiny3`
- `merHladiny4`
- `merTeploty1`
- `merTeploty2`
- `merTeploty3`
- `merTeploty4`

#### Seznam tagů

- `tag1`
- `tag2`

#### Seznam měřených hodnot

- `vykonkWh`
- `hladinaCm`
- `teplotaCelsia`

Aby docházelo ke změně měřených hodnot a do databáze se dokola nezapisovala stejná data, jsou v každé iteraci volány funkce `change_temperature()`, `change_level()` a `change_power()`. Tyto funkce náhodně změní hodnotu daného měření z předchozí iterace o `integer` z rozmezí `<-1;1>`. Jelikož by takto náhodně upravovaná data mohla nabývat hodnot, která by v kontextu ilustrace reálné MVE byla nesmyslná, volá se po každé změně funkce `norm_value()`, která zaručuje, že se hodnoty měření nevychýlí z přednastavených rozmezí. Rozmezí pro jednotlivé typy měření jsou uvedeny v následující tabulce.

| Název hodnoty  | Rozmezí   |
|----------------|----------:|
| `vykonkWh`     | `<0;60>`  |
| `hladinaCm`    | `<-20;20>`|
| `teplotaCelsia`| `<-5;90>` |

### Konstrukce HTTP POST

InfluxDB API očekává `HTTP POST` požadavek v přesně definované struktuře.

Každý `HTTP POST` požadavek musí obsahovat:

- Název organizace nebo její ID
- Název cílového kbelíku (bucket)
- API Token
- InfluxDB URL
- Data ve formátu `line protocol`

Pro kompletní dokumentaci InfluxDB API navštivte:

[https://docs.influxdata.com/influxdb/v2.1/api/#operation/PostWrite](https://docs.influxdata.com/influxdb/v2.1/api/#operation/PostWrite)

Organizaci, kbelík, token a adresu program vyplní z informací uvedených v `options.json`.

Data je před odesláním nutné transformovat ze slovníku `data_structure` do formátu `line protocol`. To se provede zavoláním funkce `transform_data()`.

### Iterace smyčkou

Nekonečná smyčka v každé své iteraci volá funkci `iterate()` a poté čeká `period` sekund. Proměnná `period` je `integer` nažtený z hodnoty klíče `period` v `options.json`.

Funkce `iterate()` má nastarost volat ostatní funkce ke změně dat, jejich transformaci a odeslání na server.

------------