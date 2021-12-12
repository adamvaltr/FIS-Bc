#!/bin/bash
##########################################################################################
# Bash skript který odinstaluje software nainstalovaný skriptem install.sh a odebere přidané repozitáře a klíče.
# Dále odstraní konfiguraci učiněnou skriptem configure.sh.
# Zpracováno jako součást bakalářské práce na FIS VŠE v Praze na téma Řízení malé vodní elektrárny.
# Testováno na Debian 11. 
# Autor @AdamValtr @2021
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

################################## remove_install ########################################
## Funkce odinstaluje InfluxDB a Grafana a odebere z apt jejich repozitáře a klíče.
remove_install() {
    sudo apt purge -y influxdb2 grafana
    sudo rm /etc/apt/sources.list.d/influxdb.list && sudo rm /etc/apt/sources.list.d/grafana.list
    sudo rm /etc/apt/trusted.gpg.d/grafana.gpg && sudo rm /etc/apt/trusted.gpg.d/grafana.gpg
    sudo apt autoremove
}
##########################################################################################

############################### remove_configuration #####################################
## Funkce odstraní konfiguraci nasazenou confihure.sh.
remove_configuration() {
    sudo apt purge -y certbot
    sudo rm -r /etc/grafana && sudo rm -r /etc/influxdb

}
##########################################################################################

##################################### execute ############################################
## Fukce obálka - výčet funkcí (kroků), které budou provedeny.
execute() {
    os_check
    remove_install
    remove_configuration
}
##########################################################################################

## Informace o skriptu
echo "Tento skript odinstaluje databázový software InfluxDB a analytickou webovou platformu Grafana, odebere přidané repozitáře a klíče (kroky učiněné install.sh) a odstraní konfiguraci (kroky učiněné configuration.sh). K ověření, zda je skript spouštěn na podporovaném OS, dochází v prvním kroku přečtením obsahu souboru /etc/os-release."

##  Souhlas se spuštěním
echo "Přejete si pokračovat v exekuci skriptu ${0##*/}? (Zadejte '1' nebo '2' pro výběr možnosti)"
select yn in "Ano" "Ne"; do
    case $yn in
        Ano ) execute; echo "Skript ${0##*/} úspěšně dokončen"; break;;
        Ne ) echo "Spuštění skriptu ${0##*/} odmítnuto."; exit;;
    esac
done