#!/bin/bash
##########################################################################################
# Bash skript který nasadí defultní configuraci softwarového vybavení.
# Uživatel by měl zvážít zda nechce změnit některá nastavení aby odpovídala jeho prostředí a požadavkům.
# Pokud však uživatel nemá opodstatněné důvody ke změnám - tento skript nasadí plně funkční konfiguraci
# v rozsahu který odpovídám potřebám softwarového vybavení pro bakalářskou práci jejíž je tento software součástí.
# Uživatel bude v průběhu skrze CLI dotazován na doplnění hodnot unikátních pro každé nasazení.
# Zpracováno jako součást bakalářské práce na FIS VŠE v Praze.
# Testováno na Debian 11. 
# Autor @AdamValtr
##########################################################################################

domain=example.com # Proměnná pro doménu. Je možné změnit ručně v průběhu exekuce.
influxbucket=mve # Proměnná pro datový kbelík (bucket) InfluxDB. Je možné změnit ručně v průběhu exekuce.
influxuser=username # Proměnná pro uživatelské jméno InfluxDB. Je možné změnit ručně v průběhu exekuce.
influxpass=password # Proměnná pro heslo InfluxDB. Je možné změnit ručně v průběhu exekuce.
influxorg=organization # Proměnná pro organizaci InfluxDB. Je možné změnit ručně v průběhu exekuce.
grafanapass=password # Proměnná pro heslo Grafana. Je možné změnit ručně v průběhu exekuce.

################################## status_report #########################################
## Funkce reportující chybové hlášky a ukončující skript 
status_report() {
    echo "FUNKCE: $1 HLÁSÍ: $2"
    echo "Skript nebylo možné dokončit."; exit
}
##########################################################################################

###################################### os_check ##########################################
## Funkce k ověření OS. Distribuce Debian obsahuje "debian" pod klíčem "ID". Distribuce založené na Debianu uvádí "debian" pod klíčem "ID_LIKE"
os_check() {
if grep -q debian "/etc/os-release"; then
    return
else
    status_report ${FUNCNAME[0]} "Nepodporovaný OS." 
fi
}
##########################################################################################

################################### install_depend ######################################
## Pokud nutno, nainstaluje nástroje nutné k úspěšné exekuci skriptu
install_depend() {
if ! sudo apt update | grep "Err"; then
    sudo apt upgrade -y
else
    status_report ${FUNCNAME[0]} "Nezdařilo se aktualizovat seznam dostupných balíčků."
fi

dependencies="jq"
for package in $dependencies
do
    sudo apt install -y $package
    if dpkg -l $package > /dev/null; then
        continue
    else
        status_report ${FUNCNAME[0]} "Nezdařilo se nainstalovat $package."
    fi
done
}
#########################################################################################

##################################### ask_domain #########################################
## Funkce se zeptá na správnost použité domény.
ask_domain() {
    echo "Je toto vaše doména (doména pro kterou byl/bude vygenerován certifikát)?"
    echo "Doména: $domain"
    select yn in "Ano" "Ne"; do
        case $yn in
            Ano ) echo "Vaše doména: $domain"; break;;
            Ne ) read -p "Zadejte doménu: " domain; echo "Vaše doména: $domain"; break;;
        esac
    done 
}
##########################################################################################

##################################### CERTBOT a SSL ######################################
################################### setup_certbot ########################################
## Funkce nainstaluje certbot - pokud není nainstalován. Certbot obstará SSL certifikáty od Let's Encrypt pro zajištění HTTPS. Poté se certifikáty zkopírují do příslušných adresářů a nstaví se patřičná oprávnění.
setup_certbot() {
if ! dpkg -l cerbot > /dev/null; then
    sudo apt install -y certbot
    if dpkg -l certbot ; then
        echo "Nyní certbot obstará certifikát od Let's Encrypt. Řiďte se jeho pokyny."
        sudo certbot certonly --standalone
    
        echo "Nyní dojde ke zkopírování vygenerenovaného certifikátu, aby ho InfluxDB a Grafana mohli použít."
        
        # InfluxDB
        sudo cp /etc/letsencrypt/live/$domain/*.pem /etc/influxdb
        sudo chown :influxdb /etc/influxdb/*.pem
        chmod 640 /etc/influxdb/privkey.pem

        # Grafana
        sudo cp /etc/letsencrypt/live/$domain/*.pem /etc/grafana
        sudo chown :grafana /etc/grafana/*.pem
        chmod 640 /etc/grafana/privkey.pem

    else
        status_report ${FUNCNAME[0]} "Nezdařilo se nainstalovat certbot."
    fi
fi
}
##########################################################################################

################################## use_certbot ###########################################
## Funkce se zeptá uživatele, zda chce použít cerbot k obstarání SSL certifikátů. 
use_certbot() {
echo "Chcete použít certbot? (Zadejte '1' nebo '2' pro výběr možnosti)"
select yn in "Ano" "Ne"; do
    case $yn in
        Ano ) setup_certbot; break;;
        Ne ) echo "Cerbot nebyl použit k získání SSL certifikátů."; break;;
    esac
done
}
##########################################################################################

################################## deploy_ssl_config #####################################
## Funkce zazálohuje defaultní konfiguraci InfluxDB a Grafana a nasadí konfiguraci povolující SSL s certifikáty v adresářích /etc/influxdb a /etc/grafana.
deploy_ssl_config() {

    # InfluxDB
    export INFLUXD_CONFIG_PATH=/etc/influxdb
    sudo cp /etc/influxdb/config.toml /etc/influxdb/old_config.toml
    sudo cp ./setup_lib/configure_lib/config.toml /etc/influxdb/config.toml
    sudo chown :influxdb /etc/influxdb/config.toml
    sudo service influxdb restart
    echo "Restartuji InfluxDB."
    sleep 5 # Prodleva pro restart služby
    if curl -s --head  --request GET https://$domain:8086 > /dev/null; then 
        echo "InfluxDB je dostupná na https://$domain:8086."
    else
        status_report ${FUNCNAME[0]} "Nezdařilo nasadit SSL pro InfluxDB."
    fi

    # Grafana
    sudo cp /etc/grafana/grafana.ini /etc/grafana/grafana.ini.bak
    sudo cp ./setup_lib/configure_lib/grafana.ini /etc/grafana/grafana.ini
    sudo chown :grafana /etc/grafana/grafana.ini
    sudo service grafana-server restart
    echo "Restartuji Grafana."
    sleep 5 # Prodleva pro restart služby
    if curl -s --head  --request GET https://$domain:3000 > /dev/null; then 
        echo "Grafana je dostupná na https://$domain:3000."
    else
        status_report ${FUNCNAME[0]} "Nezdařilo nasadit SSL pro Grafana."
    fi
}
##########################################################################################

###################################### InfluxDB ##########################################
#################################### init_influx #########################################
## Funkce spustí proces prvotního nastavení InfluxDB, ve kterém dojde si uživatel nastaví uživatelské jméno, heslo, organizaci a tzv. kbelík (bucket) pro data.
init_influx() {
    echo "Průvodce prvotním nastavením InfluxDB. Po uživately bude vyžadováno nastavení uživatelského jména, hesla, organizace a tzv. kbelíku (bucket) pro data."
    echo "Toto jsou hodnoty, které budou použity:"
    echo "Organizace: $influxorg"
    echo "Bucket: $influxbucket"
    echo "Uživatelské jméno: $influxuser"
    echo "Heslo: $influxpass"

    echo "Chcete tyto hodnoty změnit?"
    select yn in "Ano" "Ne"; do
        case $yn in
            Ano ) read -p "Zadejte organizaci: " influxorg; read -p "Zadejte bucket: " influxbucket; read -p "Zadejte uživatelské jméno: " influxname; read -p -s "Zadejte heslo: " influxpass; break;;
            Ne ) echo "Použity původní hodnoty."; break;;
        esac
    done

    influx setup \
    --org $influxorg \
    --bucket $influxbucket \
    --username $influxuser \
    --password $influxpass \
    --force 

    # Vytvoří API token pro klienta
    bucketid=$(influx bucket list --json -n mve | jq -r '.[].id')
    influx auth create \
    --write-bucket $bucketid
    --description "API token pro klienta"
    
    # Nasměruje Influx CLI na HTTPS
    influx config set -n default -u https://$domain:8086
}

###################################### Grafana ###########################################
################################### init_grafana #########################################
## Funkce změní defaultní heslo pro Grafana
init_grafana() {
    echo "Grafana používá defaultní uživatelské jméno: admin a heslo: admin. Z bezpečnostních důvodů teď nastavte nové heslo pro uživatele: admin."
    echo "Předvyplněné heslo je: $grafanapass. Chcete ho změnit?"
    select yn in "Ano" "Ne"; do
        case $yn in
            Ano ) read -p -s "Zadejte nové heslo: " grafanapass; break;;
            Ne ) echo "Použije se heslo: $grafanapass."; break;;
        esac
    done
    
    # Změní heslo uživatele admin
    grafana-cli admin reset-admin-password $grafanapass
}

##################################### execute ############################################
## Fukce obálka - výčet funkcí (kroků), které budou provedeny.
execute() {
    os_check
    install_depend
    init_influx
    init_grafana
    ask_domain
    use_certbot
    deploy_ssl_config
}
##########################################################################################

## Informace o skriptu
echo "Tento skript nasadí defultní configuraci softwarového vybavení. Uživatel by měl zvážít zda nechce změnit některá nastavení aby odpovídala jeho prostředí. K ověření, zda je skript spouštěn na podporovaném OS, dochází v prvním kroku přečtením obsahu souboru /etc/os-release."

##  Souhlas se spuštěním
echo "Přejete si pokračovat v exekuci skriptu ${0##*/}? (Zadejte '1' nebo '2' pro výběr možnosti)"
select yn in "Ano" "Ne"; do
    case $yn in
        Ano ) execute; echo "Skript ${0##*/} úspěšně dokončen"; break;;
        Ne ) echo "Spuštění skriptu ${0##*/} odmítnuto."; exit;;
    esac
done