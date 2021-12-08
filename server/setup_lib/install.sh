#!/bin/bash
##########################################################################################
# Bash skript k instalaci softwarového vybavení serveru (InfliuxDB a Grafana)
# Zpracováno jako součást bakalářské práce na FIS VŠE v Praze.
# Testováno na Debian 11. 
# Autor @AdamValtr
##########################################################################################

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

#################################### package_update ######################################
## Funkce aktualizuje seznam dostupných balíčků a nainstaluje aktualizace - pokud k dispozici
package_update() {
if ! sudo apt update | grep "Err"; then
    sudo apt upgrade -y
else
    status_report ${FUNCNAME[0]} "Nezdařilo se aktualizovat seznam dostupných balíčků."
fi
}
#########################################################################################

################################### install_depend ######################################
## Pokud nutno, nainstaluje nástroje nutné k úspěšné exekuci skriptu
install_depend() {
dependencies="wget gpg apt-transport-https software-properties-common"
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

####################################### INFLUXDB ########################################
################################### add_influx_repo #####################################
## Přidá repozitář InfluxDB a jeho veřejný klíč (dle https://portal.influxdata.com/downloads/)
add_influx_repo() {
    wget -qO- https://repos.influxdata.com/influxdb.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdb.gpg > /dev/null
    export DISTRIB_ID=$(lsb_release -si); export DISTRIB_CODENAME=$(lsb_release -sc)
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/influxdb.gpg] https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list > /dev/null
}
#########################################################################################

################################### install_influxDB ####################################
# Nainstaluje InfluxDB OSS v nejnovější verzi (v2.x).
install_influxDB() {
if dpkg -l influxdb2; then
    influxd_ver=$(influxd version)
    echo "Balíček influxdb2 je již nainstalován. Influxd je ve verzi: $influxd_ver."
    echo "Má se i přesto apt pokusit nainstalovat nejnovější verzi? (Zadejte '1' nebo '2' pro výběr možnosti)"
    select yn in "Ano" "Ne"; do
        case $yn in
            Ano ) sudo apt install -y influxdb2; break;;
            Ne ) echo "Byla zachována stávající instalace a skript pokračuje k dalšímu kroku."; break;;
        esac
    done
else   
    sudo apt install -y influxdb2
    if dpkg -l influxdb2; then
        sudo systemctl daemon-reload
        sudo systemctl enable influxdb.service
        sudo systemctl start influxdb
    else
        status_report ${FUNCNAME[0]} "Nezdařilo se nainstalovat influxDB."
    fi
fi
}
#######################################################################################

###################################### GRAFANA ########################################
################################## add_grafana_repo ###################################
## Přidá repozitář Grafana a jeho veřejný klíč (dle https://grafana.com/docs/grafana/latest/installation/debian/#install-from-apt-repository)
add_grafana_repo() {
    wget -q -O - https://packages.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/grafana.gpg > /dev/null
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null
}
######################################################################################

################################## install_grafana ###################################
# Nainstaluje Grafana OSS v nejnovější verzi (v8.3.x).
install_grafana() {
if dpkg -l grafana; then
    grafana_ver=$(grafana-cli -v)
    echo "Balíček grafana je již nainstalován. Grafana-CLI je ve verzi: $grafana_ver."
    echo "Má se i přesto apt pokusit nainstalovat nejnovější verzi? (Zadejte '1' nebo '2' pro výběr možnosti)"
    select yn in "Ano" "Ne"; do
        case $yn in
            Ano ) sudo apt install -y grafana; break;;
            Ne ) echo "Byla zachována stávající instalace a skript pokračuje k dalšímu kroku."; break;;
        esac
    done
else   
    sudo apt install -y grafana
    if dpkg -l grafana; then
        sudo systemctl daemon-reload
        sudo systemctl enable grafana-server.service
        sudo systemctl start grafana-server
    else
        status_report ${FUNCNAME[0]} "Nezdařilo se nainstalovat Grafana."
    fi
fi
}
#####################################################################################

################################## execute ##########################################
## Fukce obálka - výčet funkcí (kroků), které budou provedeny.
execute() {
    os_check
    package_update
    install_depend
    add_influx_repo
    add_grafana_repo
    package_update
    install_influxDB
    install_grafana
}
#####################################################################################

## Informace o skriptu
echo "Tento skript nainstaluje databázový software InfluxDB a analytickou webovou platformu Grafana v nejnovějřích vrzích pro platformu AMD64 v edicích OSS. Skript je určen pro systém GNU/Linux v distribuci Debian nebo jejích derivacích. K ověření, zda je skript spouštěn na podporovaném OS, dochází v prvním kroku přečtením obsahu souboru /etc/os-release. V případě potřeby budou doinstalovány nástroje nutné k úspěšné exekuci skriptu."

##  Souhlas se spuštěním
echo "Přejete si pokračovat v exekuci skriptu ${0##*/}? (Zadejte '1' nebo '2' pro výběr možnosti)"
select yn in "Ano" "Ne"; do
    case $yn in
        Ano ) execute; echo "Skript ${0##*/} úspěšně dokončen"; break;;
        Ne ) echo "Spuštění skriptu ${0##*/} odmítnuto."; exit;;
    esac
done