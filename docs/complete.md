# Dokumentace k programovému vybavení

## Obsah

- [Dokumentace k programovému vybavení](#dokumentace-k-programovému-vybavení)
  - [Obsah](#obsah)
  - [Úvod](#úvod)
    - [Členění dokumentace](#členění-dokumentace)
    - [Adresářová struktura](#adresářová-struktura)
- [1. Server](#1-server)
  - [1.1. Použití](#11-použití)
  - [1.2. Skript `install.sh`](#12-skript-installsh)
  - [1.3. Skript `configure.sh`](#13-skript-configuresh)
    - [1.3.1. Konfigurační soubory InfluxDB `config.toml` a Grafana `grafana.ini`](#131-konfigurační-soubory-influxdb-configtoml-a-grafana-grafanaini)
  - [1.4. Skript `remove.sh`](#14-skript-removesh)
- [2. Klient](#2-klient)
  - [2.1. Použití](#21-použití)
    - [2.1.1. Konfigurační soubor](#211-konfigurační-soubor)
    - [2.1.2. Spuštění](#212-spuštění)
  - [2.2. Program `main.py`](#22-program-mainpy)
    - [2.2.1. Práce s daty](#221-práce-s-daty)
      - [2.2.1.1. Seznam senzorů](#2211-seznam-senzorů)
      - [2.2.1.2. Seznam tagů](#2212-seznam-tagů)
      - [2.2.1.3. Seznam měřených hodnot](#2213-seznam-měřených-hodnot)
    - [2.2.2. Konstrukce HTTP POST](#222-konstrukce-http-post)
    - [2.2.3. Iterace smyčkou](#223-iterace-smyčkou)
- [3. Grafana](#3-grafana)
  - [3.1. Použití](#31-použití)
  - [3.2. Popis databáze](#32-popis-databáze)
    - [3.2.1. Seznam měření](#321-seznam-měření)
    - [3.2.2. Seznam tagů](#322-seznam-tagů)
    - [3.2.3. Seznam měřených hodnot](#323-seznam-měřených-hodnot)
    - [3.2.4. Datová struktura](#324-datová-struktura)
  - [3.3. Dashboard FIS-Bc, jeho panely a upozornění](#33-dashboard-fis-bc-jeho-panely-a-upozornění)
    - [3.3.1. Celkový výkon](#331-celkový-výkon)
      - [3.3.1.1. Flux dotaz](#3311-flux-dotaz)
      - [3.3.1.2. Transformace dat](#3312-transformace-dat)
    - [3.3.2. Průměrný výkon](#332-průměrný-výkon)
      - [3.3.2.1. Flux dotaz](#3321-flux-dotaz)
    - [3.3.3. Kumulativní výroba](#333-kumulativní-výroba)
      - [3.3.3.1. Flux dotaz](#3331-flux-dotaz)
      - [3.3.3.2. Transformace dat](#3332-transformace-dat)
    - [3.3.4. Upozornění](#334-upozornění)
      - [3.3.4.1. Upozornění: Výkon](#3341-upozornění-výkon)
        - [3.3.4.1.1. Flux dotazy pro upozornění](#33411-flux-dotazy-pro-upozornění)
          - [3.3.4.1.1.1. A](#334111-a)
          - [3.3.4.1.1.2. B](#334112-b)
          - [3.3.4.1.1.3. C](#334113-c)
        - [3.3.4.1.2. Nastavení](#33412-nastavení)
      - [3.3.4.2. Upozornění: Hladina](#3342-upozornění-hladina)
        - [3.3.4.2.1. Flux dotazy pro upozornění](#33421-flux-dotazy-pro-upozornění)
          - [3.3.4.2.1.1. A](#334211-a)
          - [3.3.4.2.1.2. B](#334212-b)
        - [3.3.4.2.2. Nastavení](#33422-nastavení)
      - [3.3.4.3. Upozornění: Teplota](#3343-upozornění-teplota)
        - [3.3.4.3.1. Flux dotazy pro upozornění](#33431-flux-dotazy-pro-upozornění)
          - [3.3.4.3.1.1. A](#334311-a)
          - [3.3.4.3.1.2. B](#334312-b)
        - [3.3.4.3.2. Nastavení](#33432-nastavení)
    - [3.3.5. Výkon TG1 a Výkon TG2](#335-výkon-tg1-a-výkon-tg2)
      - [3.3.5.1. Flux dotaz pro Výkon TG1](#3351-flux-dotaz-pro-výkon-tg1)
      - [3.3.5.2. Flux dotaz pro Výkon TG2](#3352-flux-dotaz-pro-výkon-tg2)
    - [3.3.6. Hladina nad TG1 a Hladina nad TG2](#336-hladina-nad-tg1-a-hladina-nad-tg2)
      - [3.3.6.1. Flux dotaz pro Hladina nad TG1](#3361-flux-dotaz-pro-hladina-nad-tg1)
      - [3.3.6.2. Flux dotaz pro Hladina nad TG2](#3362-flux-dotaz-pro-hladina-nad-tg2)
    - [3.3.7. Hladina pod TG1 a Hladina pod TG2](#337-hladina-pod-tg1-a-hladina-pod-tg2)
      - [3.3.7.1. Flux dotaz pro Hladina pod TG1](#3371-flux-dotaz-pro-hladina-pod-tg1)
      - [3.3.7.2. Flux dotaz pro Hladina pod TG2](#3372-flux-dotaz-pro-hladina-pod-tg2)
    - [3.3.8. Teplota ložiska generátoru TG1 a Teplota ložiska generátoru TG2](#338-teplota-ložiska-generátoru-tg1-a-teplota-ložiska-generátoru-tg2)
      - [3.3.8.1. Flux dotaz pro Teplota ložiska generátoru TG1](#3381-flux-dotaz-pro-teplota-ložiska-generátoru-tg1)
      - [3.3.8.2. Flux dotaz pro Teplota ložiska generátoru TG2](#3382-flux-dotaz-pro-teplota-ložiska-generátoru-tg2)
    - [3.3.9. Teplota ložiska turbíny TG1 a Teplota ložiska turbíny TG2](#339-teplota-ložiska-turbíny-tg1-a-teplota-ložiska-turbíny-tg2)
      - [3.3.9.1. Flux dotaz pro Teplota ložiska generátoru TG1](#3391-flux-dotaz-pro-teplota-ložiska-generátoru-tg1)
      - [3.3.9.2. Flux dotaz pro Teplota ložiska generátoru TG2](#3392-flux-dotaz-pro-teplota-ložiska-generátoru-tg2)
    - [3.3.10. Výkon](#3310-výkon)
      - [3.3.10.1. Flux dotaz pro Výkon](#33101-flux-dotaz-pro-výkon)
      - [3.3.10.2. Transformace dat](#33102-transformace-dat)
    - [3.3.11. Výkon](#3311-výkon)
      - [3.3.11.1. Flux dotaz pro Výkon](#33111-flux-dotaz-pro-výkon)
      - [3.3.11.2. Transformace dat](#33112-transformace-dat)
    - [3.3.12. Hladina](#3312-hladina)
      - [3.3.12.1. Flux dotaz pro Hladina](#33121-flux-dotaz-pro-hladina)
    - [3.3.13. Průměrná hladina nad MVE](#3313-průměrná-hladina-nad-mve)
      - [3.3.13.1. Flux dotaz pro Průměrná hladina nad MVE](#33131-flux-dotaz-pro-průměrná-hladina-nad-mve)
      - [3.3.13.2. Transformace dat](#33132-transformace-dat)
    - [3.3.14. Průměrná hladina pod MVE](#3314-průměrná-hladina-pod-mve)
      - [3.3.14.1. Flux dotaz pro Průměrná hladina pod MVE](#33141-flux-dotaz-pro-průměrná-hladina-pod-mve)
      - [3.3.14.2. Transformace dat](#33142-transformace-dat)
    - [3.3.15. Teplota ložisek](#3315-teplota-ložisek)
      - [3.3.15.1. Flux dotaz pro Teplota ložisek](#33151-flux-dotaz-pro-teplota-ložisek)

## Úvod

Tento dokument obsahuje dokumentaci programového vybavení, jež je součástí bakalářské práce Adama Valtra na téma Řízení malé vodní elektrárny vypracované v roce 2021 na Fakultě informatiky a statistiky Vysoké školy ekonomické v Praze.

Vypracované programové vybavení zahrnuje CLI nástroj napsaný v `Bash Shell`, který na systému s Linux Debian nebo distribuci z něj odvozenou dokáže nainstalovat, nakonfigurovat nebo odinstalovat databázový server InfluxDB a webovou analytickou a vizualizační platformu Grafana tak, aby klientské zařízení (v tomto případě MVE) mohlo odesílat svá senzorová data na server přes zabezpečené `HTTPS`, a tato data byla dostupná pro následnou analýzu a vizualizaci v Grafana.

Dalším článkem programového vybavení je program v jazyce `Python`, který představuje klienta (MVE), který odesílá senzorová data do databáze. Tento program má za úkol nahradit reálnou MVE jako zdroj senzorových dat. V době vypracovávání práce autor nezískal přístup k reálné MVE, kterou by bylo možné nastavit/upravit pro odesílání dat o jejím stavu na vzdálený server prostřednictvím sítě Internet. Program pravidelně generuje data a odesílá je jako `HTTP POST` požadavky serveru. Struktura a hodnoty generovaných dat jsou v programu implementovány tak, aby v omezené a zjednodušené míře imitovala data, která by skutečná MVE mohla o svém stavu sbírat a reportovat o nich.

Vypracované programové vybavení také zahrnuje šablonu dashboardu Grafana, jenž obsahuje přednastavené panely a upozornění pro vizualizaci a analýzu dat získávaných z implementované databáze.

Celý soubor programového vybavení tedy funguje jako celek a jeho jednotlivé části se navzájem doplňují.

Při popisu cesty k jednotlivým částem softwarového vybavení se za kořenový adresář `/` považuje `FIS-Bc` - pokud není uvedeno jinak, cesty jsou uváděny relativně k němu.

### Členění dokumentace

Dokumentace je rozdělena do tří hlavních kapitol zastřešujících funkční celky v pořadí ve kterém autor doporučuje programové vybavení použít:

- Server
  - CLI nástroj pro automatizovanou instalaci a konfiguraci InfluxDB a Grafana.
- Klient
  - Program generující a odesílající senzorová data.
- Grafana
  - Popisuje ukázkový dashboard a upozornění v Grafana a jejich Flux dotazy do databáze.

------------

### Adresářová struktura

```
FIS-Bc
│   README.md   
│
└───client
│   │   main.py
│   │   options.json
│   
└───grafana
│   │   dashboard_template.json
│   
└───server
    │   setup.sh
    │
    └───setup_lib
        │   configure.sh
        │   install.sh
        │   remove.sh
        │
        └───setup_lib
        │   config.toml
        │   grafana.ini
```

------------

# 1. Server

- Adresář: `/server`

Tato část dokumentace popisuje CLI nástroj `setup.sh` sestrojený v `Bash`, což je `Unix Shell` a interpreter příkazové řádky. Nástroj používá podružné skripty `configure.sh `, `install.sh` a `remove.sh` z podadresáře `/setup_lib` k exekuci konkrétních úkonů.

## 1.1. Použití

Nástroj slouží primárně k automatizaci instalace a konfigurace InfluxDD a Grafana, ale také umožňuje software, který byl v jeho průběhu nainstalován zase odinstalovat včetně nasazené konfigurace.

Spuštění nástroje je možné např. příkazem `bash setup.sh`. Pamatujte, že je při exekuci nutné se nacházet v adresáři `/server` a struktura podadresářů ani názvy souborů nesmí být změněny bez korespondujících změn ve zdrojových kódech - jinak odkazy mezi jednotlivýmí skripty nebudou fungovat.

Chování nástroje je možné upravit pomocí možností, které se skriptu předávají jako tzv. vlajky (flags). Například příkaz `bash setup.sh -h` zobrazí nápovědu. Všechny možnosti popisuje následující tabulka.

| Vlajka   | Popis                                                                                               |
|----------|:----------------------------------------------------------------------------------------------------|
| `-d`     | vlajka k ladění (debugging). Podružné skripty se spustí s povolenou možností: -x                    |
| `-h`     | zobrazí  manuál                                                                                     |
| `-i`     | nainstaluje softwarové vybavení pomocí setup_lib/install.sh                                         |
| `-c`     | nasadí konfiguraci softwarového vybavení pomocí setup_lib/install.sh                                |
| `-r`     | odstraní nainstalovaný software a konfiguraci učiněné setup_lib/install.sh a setup_lib/configure.sh |

Pokud dojde ke spuštění bez vlajky, dojde ke standardnímu průběhu, který představuje instalaci a konfiguraci. Tento standardní průběh je totožný s použitím vlajek `-i` a `-c` dohromady - tedy `bash setup.sh -ic`.

Uvede-li se vlajka, která není definována, program do příkazové řádky vytiskne zprávu, že takovou možnost nezná a skončí.

Zahrnuje-li průběh nástroje spuštění podružných skriptů `configure.sh `, `install.sh` a `remove.sh` z podadresáře `/setup_lib`, dojde vždy k výzvě uživatele o potvrzení, zda si opravdu přeje pokračovat. Prvním krokem, který pak podružný skript učiní, je kontrola operačního systému hosta. Tato kontrola je důležitá, neboť zmíněné skripty přímo interagují se systémem a dělají v něm změny. Při exekuci na nepodporovaném systému by nebylo možné zaručit správné fungování skriptů a mohlo by způsobit něžádoucí změny. Kontrola se provádí čtením obsahu `/etc/os-release` ve kterém se hledá fráze `debian`. Distribuce Linux Debian obsahuje `debian` pod klíčem `ID`. Distribuce založené na Debianu uvádí `debian` pod klíčem `ID_LIKE`. Pokud nedojde k úspěšnému splnění této kontroly, skript nebude pokračovat a ukončí se.

Nástroj komunikuje s uživatelem prostřednictvím příkazové řádky. V různých částech exekuce může být uživatel dotazován na potvrzení následného kroku formou souhlasu, či nesouhlasu, který je vždy reprezentován jako nabídka s volbami, na kterou se odpovídá indexem volby.

Následující výpis kódu reprezentuje jednu takovou volbu. Jedná se o již zmiňovaný souhlas se spuštěním. Uživatel na něj může odpovědět zadáním `1` pro volbu `Ano` nebo `2` pro `Ne` a potvrdit klávesou `enter`.

```Bash
echo "Přejete si pokračovat v exekuci skriptu ${0##*/}? (Zadejte '1' nebo '2' pro výběr možnosti)"
select yn in "Ano" "Ne"; do
    case $yn in
        Ano ) execute; echo "Skript ${0##*/} úspěšně dokončen"; break;;
        Ne ) echo "Spuštění skriptu ${0##*/} odmítnuto."; exit;;
    esac
done
```

Dalším příkladem komunikace, při které je vyžadován uživatelský vstup, je žádost o zadání konkrétní hodnoty, která se má v daném kroku použít. Uživateli je nabídnuta přednastavená hodnota, se kterou může buď souhlasit, nebo jí změnit na hodnotu odpovídající jeho potřebám a prostředí. Pokud se rozhodne hodnotu změnit, učiní tak výběrem patřičné volby a následně vpíše do příkazové řádky novou hodnotu, která se má použít.

Pro ilustraci - ve výpisu kódu níže, je uživatel dotazován na nové heslo pro přihlášení do Grafana. Může se použít předvyplněné heslo a nebo heslo, které uživatel zadá. Nejdříve je nutné vybrat volbu zadáním `1` a potvrzením klávesou `enter`, poté je možné do příkazové řádky vepsat novou hodnotu a opět potvrdit klávesou `enter`.

```Bash
echo "Předvyplněné heslo je: $grafanapass. Chcete ho změnit?"
select yn in "Ano" "Ne"; do
    case $yn in
        Ano ) read -p -s "Zadejte nové heslo: " grafanapass; break;;
        Ne ) echo "Použije se heslo: $grafanapass."; break;;
    esac
done
```

O reportování neúspěšné exekuce nějakého kroku skriptu se stará funkce `status_report()`. Ta do příkazové řádky vpíše, název funkce, které se něco nezdařilo a hlášku vysvětlující, co se nezdařilo. Poté ohlásí: `"Skript nebylo možné dokončit."` a ukončí exekuci.

```Bash
# Neúspěšná funkce volá

status_report ${FUNCNAME[0]} "Nepodporovaný OS."

# Reportovací funkce reportuje do příkazové řádky a ukončuje exekuci
status_report() {
    echo "FUNKCE: $1 HLÁSÍ: $2"
    echo "Skript nebylo možné dokončit."; exit
}
```

------------

## 1.2. Skript `install.sh`

Tento podružný skript použije `apt` k instalci InfluxDB OSS v nejnovější dostupné verzi (aktuálně v2.1.1) a Grafana OSS v nejnovější dostupné verzi (aktuálně v8.3.1).

Průběh skriptem řídí funkce `execute()`. Ta volá tyto ostatní funkce v pořadí, jak jsou uvedeny:

| Název funkce           | Popis                                                                                               |
|------------------------|:----------------------------------------------------------------------------------------------------|
| `os_check()`           | zkontroluje zda `/etc/os-release` obsahuje frázy `debian`                                           |
| `package_update()`     | `apt` aktualizuje seznam dostupných balíčků a nainstaluje aktualizace - pokud jsou k dispozici           |
| `install_depend()`     | pokud nutno, nainstaluje nástroje nutné k úspěšné exekuci skriptu (`wget gpg apt-transport-https software-properties-common`) |
| `add_influx_repo()`    | přidá repozitář InfluxDB a jeho veřejný klíč do zdrojů `apt`                                        |
| `add_grafana_repo()`   | přidá repozitář Grafana a jeho veřejný klíč do zdrojů `apt`                                         |
| `package_update()`     | znovu zaktualizuje, neboť byly přidány nové repozitáře                                              |
| `install_influxDB()`   | nainstaluje InfluxDB OSS v nejnovější dostupné verzi z přidaného repozitáře                         |
| `install_grafana()`    | nainstaluje Grafana OSS v nejnovější dostupné verzi z přidaného repozitáře                          |

------------

## 1.3. Skript `configure.sh`

Tímto skriptem je výrazně zautomatizován proces nastavení InfluxDB a Grafana. Vytvoří databázi a připraví ji pro čtení a zápis na základě autorizace `API Tokeny`, změní defaultní hesla a dokáže obstarat `TLS` certifikát podepsaný Let's Encrypt, který umožní komunikaci s databází přes `HTTPS`.

Mnoho kroků tohoto skriptu vyžaduje vstup od uživatele. Aby nebylo nutné dotazované hodnoty zadávat ručně, je možné je předvyplnit do proměnných ve zdrojovém kódu. Předvyplnitelné proměnné jsou:

| Název proměnné     | Popis                                                                    |
|--------------------|:-------------------------------------------------------------------------|
| `domain`           | doménové jméno pro použití s `TLS` certifikátem                          |
| `influxbucket`     | název kbelíku (bucket), který bude v InfluxDB databázi vytvořen          |
| `influxuser`       | uživatelské jméno pro administrátorský účet InfluxDB databáze            |
| `influxpass`       | heslo pro administrátorský účet InfluxDB databáze                        |
| `influxorg`        | název organizace InfluxDB databáze                                       |
| `grafanapass`      | heslo pro administrátorský účet platformy Grafana                        |

Průběh skriptem řídí funkce `execute()`. Ta volá tyto ostatní funkce v pořadí, jak jsou uvedeny:

| Název funkce           | Popis                                                                                               |
|------------------------|:----------------------------------------------------------------------------------------------------|
| `os_check()`           | zkontroluje zda `/etc/os-release` obsahuje frázy `debian`                                           |
| `install_depend()`     | pokud nutno, nainstaluje nástroje nutné k úspěšné exekuci skriptu (`jq`)                            |
| `init_influx()`        | spustí proces prvotního nastavení InfluxDB, ve kterém si uživatel nastaví uživatelské jméno, heslo, organizaci a tzv. kbelík (bucket) pro data, a vygenerují se potřebné `API Tokeny` |
| `init_grafana()`       | změní defaultní heslo pro administrátorský účet `admin` v Grafana                                   |
| `ask_domain()`         | zeptá se uživatele na doménové jméno pro použití s `TLS` certifikátem                               |
| `use_certbot()`        | zeptá se uživatele, zda chce obstarat certifikát pomocí `certbot`                                   |
| `deploy_tls_config()`  | zazálohuje defaultní konfiguraci InfluxDB a Grafana a nasadí konfiguraci povolující TLS             |

### 1.3.1. Konfigurační soubory InfluxDB `config.toml` a Grafana `grafana.ini`

Upravuje nastavení databázového serveru InfluxDB platformy Grafana, aby pro komunikaci používaly namísto `HTTP` zabezpečené `HTTPS` pomocí certifikátu a klíče od Let's Encrypt obstaraného pomocí `certbot`.

Tyto soubory použije funkce `deploy_tls_config()` k nasazení `TLS`.

------------

## 1.4. Skript `remove.sh`

Odinstaluje software nainstalovaný skriptem `install.sh`, odebere přidané repozitáře a klíče a odstraní konfiguraci učiněnou skriptem `configure.sh`. Jeho zamýšlené použití je především pro případy, že z nějakého důvodu instalace či konfigurace patřičnými skripty byla neúspěšná. Pak se jednoduše použije `bash setup.sh -r`, který se postará o odstranění kroků učiněných `install.sh` a `configure.sh`.

Průběh skriptem řídí funkce `execute()`. Ta volá tyto ostatní funkce v pořadí, jak jsou uvedeny:

| Název funkce             | Popis                                                                                               |
|--------------------------|:----------------------------------------------------------------------------------------------------|
| `os_check()`             | zkontroluje zda `/etc/os-release` obsahuje frázy `debian`                                           |
| `remove_install()`       | odinstaluje balíčky `influxdb2` a `grafana` a odebere z `apt` jejich repozitáře a klíče             |
| `remove_configuration()` | odinstaluje balíček `certbot` a rekurzivně odstraní adresáře `/etc/grafana` a `/etc/influxdb`       |

------------

# 2. Klient

- Adresář: `/client`

Popis programu napsaného v jazyce `Python`, který slouží ke generování a odesílání dat do databázového serveru pomocí `HTTP POST` požadavků.

## 2.1. Použití

Program je zamýšlen jako generátor dat, běžící v nekonečné smyčce na zařízení s přístupem k internetu, aby mohl vygenerovaná data v patřičném formátu odesílat na `API` databázového serveru.

Program se spouští bez argumentů, např. příkazem `python3 main.py`. Součástí programu je konfigurační soubor `options.json`, který musí být nutně umístěn ve stejném adresáři jako samotný program. Před samotným spuštěním programu by měl uživatel upravit konfigurační soubor, aby odpovídal jeho specifickým podmínkám.

### 2.1.1. Konfigurační soubor

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

### 2.1.2. Spuštění

Jelikož program běží v nekonečné smyčce, je vhodné ho sputit na pozadí. Pokud například chceme program spustit na vzdáleném zařízení, ke kterému přistupujeme přes `SSH`, pak je nutné proces, který spuštěním programu vznikne, oddělit od samotné `SSH session`, jinak by byl proces při ukončení `session` terminován. Na zařízení s operařním systémem Linux toho lze docílit například použitím `setsid`, které procesu vytvoří vlastní `session`. Výsledný příkaz pak může vypadat takto: `setsid python3 main.py`.

Vhodným zařízením pro spuštění programu je takové, které funguje v nepřetržitém provozu. Tím bude zabezpečeno, že nedojde k ukončení programu a tedy přerušení odesílání dat do databáze. Pro toto použití je vhodné např. `Raspberry Pi` apod.

------------

## 2.2. Program `main.py`

Fungování programu bylo testováno na Debian 11 s Python verze 3.9.

Použité balíčky:
- json
- time
- random
- requests

### 2.2.1. Práce s daty

Data, která se odesílají do databáze jsou popsána slovníkem `data_structure`. Tato data představují ilustrativní senzory, kterými bývají běžně osazeny malé vodní elektrárny. Jsou to měřídla výkonu generátorů, hladinové sondy a teplotní čidla. Slovník obsahuje celkem deset sond - dvě měřidla výkonu, čtyři hladinové sondy a čtyři teplotní čidla. Myšlená MVE, kterou se data snaží ilustrovat, je osazena dvěma turbínovými soustrojími. Na každé soustrojí tak připadá jedno měřidlo výkonu, dvě hladinové sondy a dvě teplotní čidla.

Každy senzor je ve slovníku reprezentován klíčem. Hodnotou každého klíče je pak vnořený slovník, který obsahuje dva tagy a měřenou hodnotu typu `integer`. Tagy určují k jakému soustrojí daný senzor patří a o jaký typ senzoru se jedná.

#### 2.2.1.1. Seznam senzorů

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

#### 2.2.1.2. Seznam tagů

- `tag1`
- `tag2`

#### 2.2.1.3. Seznam měřených hodnot

- `vykonkWh`
- `hladinaCm`
- `teplotaCelsia`

Aby docházelo ke změně měřených hodnot a do databáze se dokola nezapisovala stejná data, jsou v každé iteraci volány funkce `change_temperature()`, `change_level()` a `change_power()`. Tyto funkce náhodně změní hodnotu daného měření z předchozí iterace o `integer` z rozmezí `<-1;1>`. Jelikož by takto náhodně upravovaná data mohla nabývat hodnot, která by v kontextu ilustrace reálné MVE byla nesmyslná, volá se po každé změně funkce `norm_value()`, která zaručuje, že se hodnoty měření nevychýlí z přednastavených rozmezí. Rozmezí pro jednotlivé typy měření jsou uvedeny v následující tabulce.

| Název hodnoty  | Rozmezí   |
|----------------|----------:|
| `vykonkWh`     | `<0;60>`  |
| `hladinaCm`    | `<-20;20>`|
| `teplotaCelsia`| `<-5;90>` |

### 2.2.2. Konstrukce HTTP POST

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

### 2.2.3. Iterace smyčkou

Nekonečná smyčka v každé své iteraci volá funkci `iterate()` a poté čeká `period` sekund. Proměnná `period` je `integer` nažtený z hodnoty klíče `period` v `options.json`.

Funkce `iterate()` má nastarost volat ostatní funkce ke změně dat, jejich transformaci a odeslání na server.

------------

# 3. Grafana

- Adresář: `/grafana`

Popis ukázkového dashboardu a upozornění v Grafana a jejich Flux dotazy do databáze.

## 3.1. Použití

Nedílnou součástí vypracovaného programového vybavení je Grafana Dashboard, který prezentuje a analyzuje data získávaná z implementované Influx databáze. Účelem tohoto dashboardu je nabídnout obsluze malé vodní elektrárny uživatelsky přívětivý způsob jak monitorovat senzorová data elektrárny a také nad daty automatizovaně provádět logické operace, jež dokáží vyhodnocovat, zda se elektrárna nenachází v kritickém nebo nestandardním stavu, a na takovou skutečnost obsluhu upozornit.

Nastavení dashboardu předpokládá, že InfluxDB a v ní uložená data odpovídají implementaci z částí `Server` a `Klient` tohoto programového vybavení. Nicméně lze šablonu upravit přímo v jejím zdrojovém kódu nebo v UI webové aplikace Grafana, aby vyhovovala vlastním potřebám odchylujícím se od předpracované konfigurace.

Pro import dashboardu do Grafana je nutné se nejprve přihlásit do webové aplikace. Pokud byl k instalaci a počáteční konfiguraci použit CLI nástroj ze `/server/setup.sh`, pak má `URL` webové aplikace formát `https://[doména]:3000` a přihlašovací údaje odpovídají hodnotám, které uživatel uvedl v průběhu exekuce zmíněného skriptu. V opačném případě je v defaultním nastavení Grafana dostupná z `http://[IP]:3000`, kde `IP` je `IPv4` adresa serveru, kam byla Grafana nainstalována. Přihlašovací jméno a heslo je pak `admin`.

Dále je před samotným importem dashboardu nutné přidat datový zdroj. V tomto případě se jedná o InfluxDB. To lze provést navigací do `Configuration > Datasources > Add data source > InfluxDB`, kde je nutné zadat následující údaje o databázi (upravte pro Vaše prostředí):

- URL: `https://[doména]:8086` (adresa na které je databáze dostupná),
- Organization: `fis-bc` (název organizace uvedený při tvorbě databáze),
- Token: `API Token` (API Token vygenerovaný InfluxDB pro Grafana),
- Default Bucket: `mve` (název kbelíku uvedený při tvorbě databáze).

Naimportovat dashboard je možné navigací do `Create > Import > Upload JSON file`.

Šablona dashboardu je k nalezení v `dashboard_template.json`

Nasazený a plně funkční dashboard na si lze prohlédnout na [https://bc.linode.valtr.eu:3000](https://bc.linode.valtr.eu:3000). Přihlašovací údaje pro uživatele s právy pouze na zobrazení (view-only) jsou `heslo: host` a `jméno: host`.

------------

## 3.2. Popis databáze

- Databáze: `InfluxDB`
- Organizace: `fis-bc`
- Bucket: `mve`

### 3.2.1. Seznam měření

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

### 3.2.2. Seznam tagů

- `tag1`
- `tag2`

### 3.2.3. Seznam měřených hodnot

- `vykonkWh`
- `hladinaCm`
- `teplotaCelsia`

### 3.2.4. Datová struktura

- `merVykonu1`
    - `tag1` : `TG1`
    - `tag2` : `vykon`
    - `vykonkWh` : `[integer]`
    - `[timestamp]`
- `merVykonu2`
    - `tag1` : `TG2`
    - `tag2` : `vykon`
    - `vykonkWh` : `[integer]`
    - `[timestamp]`
- `merHladiny1`
    - `tag1` : `TG1`
    - `tag2` : `hladina`
    - `hladinaCm` : `[integer]`
    - `[timestamp]`
- `merHladiny2`
    - `tag1` : `TG1`
    - `tag2` : `hladina`
    - `hladinaCm` : `[integer]`
    - `[timestamp]`
- `merHladiny3`
    - `tag1` : `TG2`
    - `tag2` : `hladina`
    - `hladinaCm` : `[integer]`
    - `[timestamp]`
- `merHladiny4`
    - `tag1` : `TG2`
    - `tag2` : `hladina`
    - `hladinaCm` : `[integer]`
    - `[timestamp]`
- `merTeploty1`
    - `tag1` : `TG1`
    - `tag2` : `teplota`
    - `teplotaCelsia` : `[integer]`
    - `[timestamp]`
- `merTeploty2`
    - `tag1` : `TG1`
    - `tag2` : `teplota`
    - `teplotaCelsia` : `[integer]`
    - `[timestamp]`
- `merTeploty3`
    - `tag1` : `TG2`
    - `tag2` : `teplota`
    - `teplotaCelsia` : `[integer]`
    - `[timestamp]`
- `merTeploty4`
    - `tag1` : `TG2`
    - `tag2` : `teplota`
    - `teplotaCelsia` : `[integer]`
    - `[timestamp]`

------------

## 3.3. Dashboard FIS-Bc, jeho panely a upozornění

Popis ukázkového dashboardu a jeho panelů a upozornění včetně nastavení a použitých Flux dotazů.

Panely dashboardu jsou rozděleny do čtyř řádků dle typu dat, která zobrazují. Rozložení panelů je následující:

- MVE
    - Celkový výkon
    - Průměrný výkon
    - Upozornění
        - Upozornění: Výkon
        - Upozornění: Hladina
        - Upozornění: Teplota
- Aktuální stav TG1
    - Celkový výkon
    - Průměrný výkon
- Aktuální stav TG2
    - Celkový výkon
    - Průměrný výkon
- Dlouhodobý přehled
    - Celkový výkon
    - Průměrný výkon

### 3.3.1. Celkový výkon

Panel měřidlo, který zobrazuje celkový výkon elektrárny - tedy obou soustrojí. Zobrazuje součet aktuálního výkonu obou soustrojí v `kWh`. Stupnice měřidla je od `0 kWh` do `120 kWh` (minimální a maximální výkon, kterého je elektrárna schopna dosáhnout). Klesne-li výkon pod `20 kWh`, měřidlo zmodná, pokud je výkon přes `100 kWh`, pak měřidlo zčervená, jinak je zelené.

#### 3.3.1.1. Flux dotaz

Získá všechna data o výkonu za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
```

#### 3.3.1.2. Transformace dat

Grafana získaná data o výkonu jednotlivých generátorů sečte sloučením řádků tabulky se stejnou časovou značkou a z výsledné tabulky zobrazí nejaktuálnější záznam časové řady.

------------

### 3.3.2. Průměrný výkon
Panel koláčový graf, který zobrazuje průměrný výkon soustrojí jako podíl na celku v `kWh`.

#### 3.3.2.1. Flux dotaz
Získá průměr všech dat o výkonu od pevného datumu a vypočítá jejich průměr.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
  |> mean()
```

------------

### 3.3.3. Kumulativní výroba

Panel stat zobrazuje kumulativní výrobu obou generátorů dohromady v `kWh`. Tedy kolik elektrické energie elektrárna vyrobila.

#### 3.3.3.1. Flux dotaz

Získá všechna data o výkonu od pevného datumu, agreguje je v `60` minutových intervalech a vypočítá průměr agregovaných dat.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
  |> aggregateWindow(every: 1h, fn: mean)
```

#### 3.3.3.2. Transformace dat

Grafana pro získaná agregovaná data přidá sloupec se součtem dat z řádku a posléze sečte všechna data v součtovém sloupci.

------------

### 3.3.4. Upozornění

Panel upozornění zobrazuje seznam aktivních upozorněních s počítadlem, indikujícím, jak dlouho je již upozornění aktivní. Upozornění se řadí dle času aktivace - tedy nejaktuálnější upozornění se zobrazí v seznamu první.

Smyslem upozornění je identifikovat neobvyklé nebo nebezpečné stavy elektrárny a informovat o nich obsluhu, aby mohla situaci investigovat a případně zakročit.

#### 3.3.4.1. Upozornění: Výkon

Slouží k upozornění na stav elektrárny, kdy průměrný výkon alespoň jednoho generátoru za poslední hodinu klesne pod `10 kWh`.

##### 3.3.4.1.1. Flux dotazy pro upozornění

Dotazy získají data nad kterými bude vyhodnocováno splnění logické podmínky.

###### 3.3.4.1.1.1. A

Získá data o výkonu TG1 za poslední hodinu.

```Flux
from(bucket:"mve")
  |> range(start: -1h)
  |> filter(fn: (r) =>
    r._measurement == "merVykonu1"
  )
```

###### 3.3.4.1.1.2. B

Získá data o výkonu TG2 za poslední hodinu.

```Flux
from(bucket:"mve")
  |> range(start: -1h)
  |> filter(fn: (r) =>
    r._measurement == "merVykonu2"
  )
```

###### 3.3.4.1.1.3. C

Podmínka boolean. Vyhodnotí, zda průměr `A` nebo průměr `B` je méně než `10`.

```
WHEN    avg()   of  A   IS BELOW    10
OR      avg()   of  B   IS BELOW    10
```

##### 3.3.4.1.2. Nastavení

- Evaluace: K evaluaci podmínky C dochází každou `1` minutu a podmínka musí být splněna po dobu `5` minut, aby došlo k aktivaci upozornění.
- Popis: Průměrný výkon jedné z turbín je již hodinu nižší než `10 kWh`.
- Souhrn: Nízký výkon turbíny.

------------

#### 3.3.4.2. Upozornění: Hladina

Slouží k upozornění na stav elektrárny, kdy průměrná hladina reportovaná alespoň jednou sondou se vychýlí z rozmezí `-10` až `10` centimetrů.

##### 3.3.4.2.1. Flux dotazy pro upozornění

Dotazy získají data nad kterými bude vyhodnocováno splnění logické podmínky.

###### 3.3.4.2.1.1. A

Získá data ze všech hladinových sond za posledních `10` minut.

```Flux
from(bucket:"mve")
  |> range(start: -10m)
  |> filter(fn: (r) =>
    r.tag2 == "hladina"
  )
```

###### 3.3.4.2.1.2. B

Podmínka boolean. Vyhodnotí, zda průměr `A` je mimo rozmezí `-10` až `10` centimetrů.

```
WHEN    avg()   of  A   IS OUTSIDE RANGE    -10 TO  10
```

##### 3.3.4.2.2. Nastavení

- Evaluace: K evaluaci podmínky `C` dochází každou `1` minutu a podmínka musí být splněna po dobu `2` minut, aby došlo k aktivaci upozornění.
- Popis: Průměrné hladina vody za posledních `10` minut, alespoň na jedné sondě, je mimo rozmezí `-10` až `10` centimetrů.
- Souhrn: Hladina mimo rozmezí.

------------

#### 3.3.4.3. Upozornění: Teplota

Slouží k upozornění na stav elektrárny, kdy maximální nebo minimální průměrná hodinová teplota reportovaná alespoň jednou sondou se v předchozích `24` hodinách vychýlila z romezí `10` až `75` stupňů Celsia.

##### 3.3.4.3.1. Flux dotazy pro upozornění

Dotazy získají data nad kterými bude vyhodnocováno splnění logické podmínky.

###### 3.3.4.3.1.1. A

Získá data ze všech hladinových sond za posledních `10` minut.

```Flux
from(bucket:"mve")
  |> range(start: -1d)
  |> filter(fn: (r) =>
    r.tag2 == "teplota"
  )
  |> aggregateWindow(every: 1h, fn: mean)
```

###### 3.3.4.3.1.2. B

Podmínka `boolean`. Vyhodnotí, zda maximun `A` je vyšší než `75` nebo minimum `A` je nižší než `10` stupňů Celsia.

```
WHEN    max()   of  A   IS ABOVE    75
OR      min()   of  A   IS BELOW    10
```

##### 3.3.4.3.2. Nastavení

- Evaluace: K evaluaci podmínky B dochází každých `30` minut a k aktivaci upozornění dochází okamžitě při jejím splnění.
- Popis: Maximální nebo minimální průměrná hodinová teplota byla za posledních `24` hodin mimo bezpečné rozmezí.
- Souhrn: Teplota na nebezpečné úrovni.

------------

### 3.3.5. Výkon TG1 a Výkon TG2

Panel měřidlo, který zobrazuje výkon TG1 v `kWh`. Stupnice měřidla je od `0 kWh` do `60 kWh` (minimální a maximální výkon TG1). Klesne-li výkon pod `10 kWh`, měřidlo zmodná, pokud je výkon přes `50 kWh`, pak měřidlo zčervená, jinak je zelené. Měřidlo zobrazí nejaktuálnější záznam získané časové řady.

#### 3.3.5.1. Flux dotaz pro Výkon TG1

Získá data o výkonu TG1 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r.tag1 == "TG1" and
    r.tag2 == "vykon"
  )
```

#### 3.3.5.2. Flux dotaz pro Výkon TG2

Získá data o výkonu TG2 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r.tag1 == "TG2" and
    r.tag2 == "vykon"
  )
```

------------

### 3.3.6. Hladina nad TG1 a Hladina nad TG2

Panel sloupcová měrka, který zobrazuje aktuální hladinu vody nad soustrojím v `cm` jako odchylku od běžné hladiny, která je v datech reprezentována hodnotou `0` centimetrů. Rozmezí měrky je `-20` až `20` centimetrů. Pokud je hladina pod záporná, pak měrka zčervená, jinak je zelená.

#### 3.3.6.1. Flux dotaz pro Hladina nad TG1

Získá data o výšce hladiny nad TG1 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r._measurement == "merHladiny1" and
    r.tag1 == "TG1" and
    r.tag2 == "hladina"
  )
  ```

#### 3.3.6.2. Flux dotaz pro Hladina nad TG2

Získá data o výšce hladiny nad TG2 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r._measurement == "merHladiny3" and
    r.tag1 == "TG2" and
    r.tag2 == "hladina"
  )
  ```

------------

### 3.3.7. Hladina pod TG1 a Hladina pod TG2

Panel sloupcová měrka, který zobrazuje aktuální hladinu vody pod soustrojím. Analogicky, jako panely zobrazující hladinu nad soustrojím, má měrka rozmezí `-20` až `20` centimetrů - avšak logika zabarvení zelenou a červenou barvou je opačná, neboť pod soustrojím je žádoucí co nejnižší hladina.

#### 3.3.7.1. Flux dotaz pro Hladina pod TG1

Získá data o výšce hladiny pod TG1 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r._measurement == "merHladiny4" and
    r.tag1 == "TG1" and
    r.tag2 == "hladina"
  )
  ```

#### 3.3.7.2. Flux dotaz pro Hladina pod TG2

Získá data o výšce hladiny pod TG2 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r._measurement == "merHladiny4 and
    r.tag1 == "TG2" and
    r.tag2 == "hladina"
  )
  ```

------------

### 3.3.8. Teplota ložiska generátoru TG1 a Teplota ložiska generátoru TG2

Panel sloupcová měrka, který zobrazuje aktuální teplotu ložiska příslušného generátoru ve stupních Celsia. Rozmezí měrky je `-5` až `90` stupňů a zabarvuje se v barevném gradientu `modrá-žlutá-červená`.

#### 3.3.8.1. Flux dotaz pro Teplota ložiska generátoru TG1

Získá data o teplotě ložiska generátoru TG1 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r._measurement == "merTeploty1" and
    r.tag1 == "TG1" and
    r.tag2 == "teplota"
  )
  ```

#### 3.3.8.2. Flux dotaz pro Teplota ložiska generátoru TG2

Získá data o teplotě ložiska generátoru TG2 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r._measurement == "merTeploty3" and
    r.tag1 == "TG2" and
    r.tag2 == "teplota"
  )
  ```

------------

### 3.3.9. Teplota ložiska turbíny TG1 a Teplota ložiska turbíny TG2

Panel sloupcová měrka, který zobrazuje aktuální teplotu ložiska příslušné turbíny ve stupních Celsia. Rozmezí měrky je `-5` až `90` stupňů a zabarvuje se v barevném gradientu `modrá-žlutá-červená`.

#### 3.3.9.1. Flux dotaz pro Teplota ložiska generátoru TG1

Získá data o teplotě ložiska turbíny TG1 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r._measurement == "merTeploty2" and
    r.tag1 == "TG1" and
    r.tag2 == "teplota"
  )
  ```

#### 3.3.9.2. Flux dotaz pro Teplota ložiska generátoru TG2

Získá data o teplotě ložiska turbíny TG2 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r._measurement == "merTeploty4" and
    r.tag1 == "TG2" and
    r.tag2 == "teplota"
  )
  ```

------------

### 3.3.10. Výkon

Panel časová řada, který zobrazuje výkon jednotlivých generátorů a součet jejich výkonů v liniovém grafu. Na ose `X` je čas a na ose `Y` výkon v `kWh`. V grafu jsou tedy vykresleny tři linie.

#### 3.3.10.1. Flux dotaz pro Výkon

Získá všechna data o výkonu od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
  ```

#### 3.3.10.2. Transformace dat

Grafana k získaným datům o výkonu jednotlivých generátorů přidá sloupec se součtem dat z řádku. Takto vzniklý součtový sloupec pak vykreslí do grafu jako samostatnou linii představující součet výkonů generátorů v daný moment.

------------

### 3.3.11. Výkon

Panel časová řada, který zobrazuje výkon jednotlivých generátorů a součet jejich výkonů v liniovém grafu. Na ose `X` je čas a na ose `Y` výkon v `kWh`. V grafu jsou tedy vykresleny tři linie.

#### 3.3.11.1. Flux dotaz pro Výkon

Získá všechna data o výkonu od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
  ```

#### 3.3.11.2. Transformace dat

Grafana k získaným datům o výkonu jednotlivých generátorů přidá sloupec se součtem dat z řádku. Takto vzniklý součtový sloupec pak vykreslí do grafu jako samostatnou linii představující součet výkonů generátorů v daný moment.

------------

### 3.3.12. Hladina

Panel časová řada, který zobrazuje výšku hladiny reportovanou hladinovými sondami v liniovém grafu. Na ose `X` je čas a na ose `Y` výška hladiny v `cm`. V grafu jsou tedy vykresleny čtyři linie, z nichž každá reprezentuje data z jedné hladinové sondy.

#### 3.3.12.1. Flux dotaz pro Hladina

Získá všechna data o hladinách od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-01-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "hladina"
  )
  ```

------------

### 3.3.13. Průměrná hladina nad MVE

Panel stat zobrazuje průměrnou výšku hladiny nad oběma soustrojími v `cm`. Pokud je průměrná hladina méně než `0` centimetrů, pak je panel červený, jinak je zelený.

#### 3.3.13.1. Flux dotaz pro Průměrná hladina nad MVE

Získá všechna data o hladinách nad oběma soustrojími od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-01-01T00:00:00Z)
  |> filter(fn: (r) =>
    r._measurement == "merHladiny1" or
    r._measurement == "merHladiny3"
  )
  ```

#### 3.3.13.2. Transformace dat

Grafana nejdříve sloučí řádky tabulky se stejnou časovou značkou a zprůměruje jejich hodnotu. Poté získá průměr všech výsledných řádků, který zobrazí jako výsledek. 

------------

### 3.3.14. Průměrná hladina pod MVE

Panel stat zobrazuje průměrnou výšku hladiny pod oběma soustrojími v `cm`. Pokud je průměrná hladina méně než `0` centimetrů, pak je panel zelený, jinak je červený. Tedy opak logiky panelu Průměrná hladina nad MVE, neboť pod soustrojími se preferuje záporná hladina.

#### 3.3.14.1. Flux dotaz pro Průměrná hladina pod MVE

Získá všechna data o hladinách pod oběma soustrojími od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-01-01T00:00:00Z)
  |> filter(fn: (r) =>
    r._measurement == "merHladiny2" or
    r._measurement == "merHladiny4"
  )
  ```

#### 3.3.14.2. Transformace dat

Grafana nejdříve sloučí řádky tabulky se stejnou časovou značkou a zprůměruje jejich hodnotu. Poté získá průměr všech výsledných řádků, který zobrazí jako výsledek. 

------------

### 3.3.15. Teplota ložisek

Panel časová řada, který zobrazuje teplotu ložisek generátorů a turbín v liniovém grafu. Na ose `X` je čas a na ose `Y` teplota ve stupních Celsia. V grafu jsou tedy vykresleny čtyři linie, z nichž každá reprezentuje data z jedné teplotní sondy.

#### 3.3.15.1. Flux dotaz pro Teplota ložisek

Získá všechna data o teplotách ložisek od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "teplota"
  )
  ```

------------