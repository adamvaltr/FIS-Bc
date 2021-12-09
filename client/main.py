###############################################################################
# Python program, který simuluje chování klienta.
# Generuje senzorová data a odesílá je do databázového serveru.
# Používá konfigurační soubor options.json, který nese adresu databázového serveru,
# údaje o cílové databázi, autorizační API Token a frekvenci se kterou se mají data
# generovat a odesílat.
# Zpracováno jako součást bakalářské práce na FIS VŠE v Praze.
# Testováno na Debian 11. 
# Autor @AdamValtr
###############################################################################

import requests, json, random, time
from requests.structures import CaseInsensitiveDict

# Otevře JSON s nastavením
options_file = open('options.json')
   
# Přvede JSON s nastavením do slovníku
options = json.load(options_file)

# Uloží hodnoty klíčů ze souboru s nastavením do proměnných
protocol = options.get("protocol")      # Protokol (http nebo https)
domain = options.get("domain")          # Doménové jméno, které směruje na IP serveru
port = options.get("port")              # Port na kterém poslouchá databázový server
org = options.get("org")                # Název organizace, který byl uveden při nastavení databázového serveru
bucket = options.get("bucket")          # Název datového kbelíku, který byl uveden uvedeno při nastavení databázového serveru
precision = options.get("precision")    # Uřšuje s jakou přesností server datům přidá časovou značku (us, ns, ms, s)
token = options.get("token")            # API token pro autentizaci klienta
period = options.get("period")          # Prodleva mezi iteracemi změny, transformace a odesláním dat
###############################################################################

# Struktura senzorových dat - ilustrativní senzory a měrné hodnoty pro potřeby simulace
# Čítá senzory, které lze běžně najít na soustrojích malých vodních elektráren
# Ilustrativní data popisují malou vodní elektrárnu se dvěma turbosoustrojímy
# Každé turbosoustrojí je osazeno měřidlem výkonu, dvěma hladinovými sondami a dvěma teplotními sondami
# Měřidla výkonu sledují výkon generátoru daného turbosoustrojí. Počáteční hodnota výkonu je myšlená běžná hodnota. Ilustruje se, že každý generátor má jiný běžný výkon. Myšlená jednotka jsou kWh.
# Hladinové sondy měří odchylku od běžné hladiny (hladinaCm : 0) v jednotce cm. Ilustruje se, že každé turbosoustrojí má jednu sondu nad turbínou a jednu pod ní.
# Teplotní sondy měří teplotu ložisek ve stupňích Celsia. Myslí se, že v každém turbosoustrojí jedna sonda měří teplotu ložiska generátoru a jedna teplotu ložiska turbíny.
data_structure = {
    "merVykonu1":{              # Měřidlo výkonu
        "tag1": "TG1",          # Štítek indikující soustrojí
        "tag2": "vykon",        # Štítek indikující kategorii měřených dat
        "vykonkWh" : 45         # Hodnota měřených dat
    },
    "merHladiny1":{             # Hladinová sonda
        "tag1": "TG1",          # Štítek indikující soustrojí
        "tag2": "hladina",      # Štítek indikující kategorii měřených dat
        "hladinaCm" : 0         # Hodnota měřených dat
    },
    "merHladiny2":{             # Hladinová sonda
        "tag1": "TG1",          # Štítek indikující soustrojí
        "tag2": "hladina",      # Štítek indikující kategorii měřených dat
        "hladinaCm" : 0         # Hodnota měřených dat
    },
    "merTeploty1":{             # Teplotní sonda
        "tag1": "TG1",          # Štítek indikující soustrojí
        "tag2": "teplota",      # Štítek indikující kategorii měřených dat
        "teplotaCelsia" : 40    # Hodnota měřených dat
    },
    "merTeploty2":{             # Teplotní sonda
        "tag1": "TG1",          # Štítek indikující soustrojí
        "tag2": "teplota",      # Štítek indikující kategorii měřených dat
        "teplotaCelsia" : 20    # Hodnota měřených dat
    },
    "merVykonu2":{              # Měřidlo výkonu
        "tag1": "TG2",          # Štítek indikující soustrojí
        "tag2": "vykon",        # Štítek indikující kategorii měřených dat
        "vykonkWh" : 35         # Hodnota měřených dat
    },
    "merHladiny3":{             # Hladinová sonda
        "tag1": "TG2",          # Štítek indikující soustrojí
        "tag2": "hladina",      # Štítek indikující kategorii měřených dat
        "hladinaCm" : 0         # Hodnota měřených dat
    },
    "merHladiny4":{             # Hladinová sonda
        "tag1": "TG2",          # Štítek indikující soustrojí
        "tag2": "hladina",      # Štítek indikující kategorii měřených dat
        "hladinaCm" : 0         # Hodnota měřených dat
    },
    "merTeploty3":{             # Teplotní sonda
        "tag1": "TG2",          # Štítek indikující soustrojí
        "tag2": "teplota",      # Štítek indikující kategorii měřených dat
        "teplotaCelsia" : 40    # Hodnota měřených dat
    },
    "merTeploty4":{             # Teplotní sonda
        "tag1": "TG2",          # Štítek indikující soustrojí
        "tag2": "teplota",      # Štítek indikující kategorii měřených dat
        "teplotaCelsia" : 20    # Hodnota měřených dat
    },
}
###############################################################################

# Definuje funkci na změnu hodnot teploty ložisek
def change_temperature():
    for key in data_structure:                                      # Projde klíče ve slovníku
        if "teplotaCelsia" in data_structure[key]:                  # Ověří zda pro klíč existuje vnořený klíč
            _oldtemperature = data_structure[key]["teplotaCelsia"]  # Uloží stávající hodnotu pod klíčem
            _tempchange = random.randint(-1,1)                    # Náhodně vygeneruje změnu z daného rozmezí
            _newtemperature = sum([_oldtemperature, _tempchange])   # Sečte původní hodnotu a změnu. Hladina může být záporná i kladná.
            data_structure[key]["teplotaCelsia"] = _newtemperature  # Uloží novou hodnotu pod klíčem
###############################################################################

# Definuje funkci na změnu hodnot hladiny vody
def change_level():
    for key in data_structure:                                  # Projde klíče ve slovníku
        if "hladinaCm" in data_structure[key]:                  # Ověří zda pro klíč existuje vnořený klíč
            _oldlevel = data_structure[key]["hladinaCm"]        # Uloží stávající hodnotu pod klíčem
            _lvlchange = random.randint(-1,1)                 # Náhodně vygeneruje změnu z daného rozmezí
            _newlevel = sum([_oldlevel, _lvlchange])            # Sečte původní hodnotu a změnu. Hladina může být záporná i kladná.
            data_structure[key]["hladinaCm"] = _newlevel        # Uloží novou hodnotu pod klíčem
###############################################################################

# Definuje funkci na změnu hodnot výkonu generátoru
def change_power():
    for key in data_structure:                                  # Projde klíče ve slovníku
        if "vykonkWh" in data_structure[key]:                   # Ověří zda pro klíč existuje vnořený klíč
            _oldpower = data_structure[key]["vykonkWh"]         # Uloží stávající hodnotu pod klíčem
            _pwrchange = random.randint(-2,2)                 # Náhodně vygeneruje změnu z daného rozmezí
            _newpower = abs(sum([_oldpower, _pwrchange]))       # Sečte původní hodnotu a změnu. Použije absolutní hodnotu - výkon nemůže být záporný
            data_structure[key]["vykonkWh"] = _newpower         # Uloží novou hodnotu pod klíčem
###############################################################################

# Funkce obaluje jednotlivé funkce pro změnu různých typů dat, aby je nebylo nutné volat samostatně.
def change_data():
    change_temperature()    # Změní teplotu naměřenou teplotními čidly
    change_level()          # Změní hladinu vody naměřenou hladinovými sondami
    change_power()          # Změní výkon naměřený měřidly výkonu
###############################################################################

# Server očekává data ve formátu line protokol. Proto je nutné je patřičně ztransformovat - jinak je server nedokáže rozebrat.
line_data = str()       # Proměnná pro transformovaná data
# Definuje funkci, která transformuje senzorová data do formátu odpovídajícímu line protokolu
def transform_data():
    for key, nestedkey in data_structure.items():   # Projde položky ve slovníku
        global line_data
        line_data = line_data + key                 # Přidá klíč k proměnné
        for item in nestedkey:                      # Projde položky vnořených slovníků
            line_data = line_data + "," + item + "=" + str(nestedkey[item])     # Přidá vnořené klíče a jejich hodnoty k proměnné v požadovaném formátu
        line_data = " ".join(line_data.rsplit(",", 1)) + "\n"                   # Nahradí poslední čárku "," na řádku mezerou a začne nový řádek
###############################################################################

# Definuje kroky, které se učiní v každé iteraci
def iterate():

    change_data()       # Změní data
    transform_data()    # Transformuje data do line protokolu

    # Proměnné pro složení HTTP POST požadavku
    url = protocol + "://" + domain + ":" + port + "/api/v2/write?org=" + org + "&bucket=" + bucket + "&precision=" + precision     # Složí URL
   
    headers = CaseInsensitiveDict()                             # Vytvoří slovník pro hlavičku
    headers["Authorization"] = "Token " + token                 # Přidá autorizační token do hlavičky
    headers["Content-Type"] = "text/plain; charset=utf-8"       # Definuje typ obsahu a jeho kódování
    headers["Accept"] = "application/json"                      # Informuje server, že klient přijímá odpovědi v JSON

    data = line_data                                            # Vloží zformátovaná data
    ###############################################################################

    requests.post(url, headers=headers, data=data)       # Složí a odešle POST request serveru
###############################################################################

# Nekonečná smyčka - program bude dokola měnit data a odesílat je serveru jako POST request
while True:
    iterate()               # Průběh změnou, transformací a odesláním dat
    time.sleep(period)      # Prodleva mezi opakováním
###############################################################################