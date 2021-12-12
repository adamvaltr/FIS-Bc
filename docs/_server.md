# Server

- Adresář: `/server`

Tato část dokumentace popisuje CLI nástroj `setup.sh` sestrojený v `Bash`, což je `Unix Shell` a interpreter příkazové řádky. Nástroj používá podružné skripty `configure.sh `, `install.sh` a `remove.sh` z podadresáře `/setup_lib` k exekuci konkrétních úkonů.

## Použití

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

## Skript `install.sh`

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

## Skript `configure.sh`

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

### Konfigurační soubory InfluxDB `config.toml` a Grafana `grafana.ini`

Upravuje nastavení databázového serveru InfluxDB platformy Grafana, aby pro komunikaci používaly namísto `HTTP` zabezpečené `HTTPS` pomocí certifikátu a klíče od Let's Encrypt obstaraného pomocí `certbot`.

Tyto soubory použije funkce `deploy_tls_config()` k nasazení `TLS`.

------------

## Skript `remove.sh`

Odinstaluje software nainstalovaný skriptem `install.sh`, odebere přidané repozitáře a klíče a odstraní konfiguraci učiněnou skriptem `configure.sh`. Jeho zamýšlené použití je především pro případy, že z nějakého důvodu instalace či konfigurace patřičnými skripty byla neúspěšná. Pak se jednoduše použije `bash setup.sh -r`, který se postará o odstranění kroků učiněných `install.sh` a `configure.sh`.

Průběh skriptem řídí funkce `execute()`. Ta volá tyto ostatní funkce v pořadí, jak jsou uvedeny:

| Název funkce             | Popis                                                                                               |
|--------------------------|:----------------------------------------------------------------------------------------------------|
| `os_check()`             | zkontroluje zda `/etc/os-release` obsahuje frázy `debian`                                           |
| `remove_install()`       | odinstaluje balíčky `influxdb2` a `grafana` a odebere z `apt` jejich repozitáře a klíče             |
| `remove_configuration()` | odinstaluje balíček `certbot` a rekurzivně odstraní adresáře `/etc/grafana` a `/etc/influxdb`       |

------------