#!/bin/bash
##########################################################################################
# Bash skript který nasadí defultní configuraci softwarového vybavení. Uživatel by měl zvážít zda nechce změnit některá nastavení aby odpovídala jeho prostředí.
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
##################################### CERTBOT ############################################
################################### setup_certbot ########################################
## Funkce nainstaluje certbot - pokud není nainstalován. Certbot obstará a nasadí SSL certifikát od Let's Encrypt pro zajištění HTTPS.
setup_certbot() {
if ! dpkg -l cerbot > /dev/null; then
    sudo apt install -y certbot
    if dpkg -l certbot ; then
        sudo certbot certonly --standalone
    else
        status_report ${FUNCNAME[0]} "Nezdařilo se nainstalovat certbot."
    fi
fi
}
##########################################################################################

################################## use_certbot #########################################
## Funkce obstará a nasadí SSL certifikát od Let's Encrypt pro zajištění HTTPS. 
use_certbot() {
echo "Chcete použít certbot? (Zadejte '1' nebo '2' pro výběr možnosti)"
select yn in "Ano" "Ne"; do
    case $yn in
        Ano ) setup_certbot; break;;
        Ne ) echo "Cerbot nenastavil SSL."; break;;
    esac
done
}
##########################################################################################

##################################### execute ############################################
## Fukce obálka - výčet funkcí (kroků), které budou provedeny.
execute() {
    use_certbot
}
##########################################################################################

## Informace o skriptu
echo "Tento skript nasadí defultní configuraci softwarového vybavení. Uživatel by měl zvážít zda nechce změnit některá nastavení aby odpovídala jeho prostředí."

##  Souhlas se spuštěním
echo "Přejete si pokračovat v exekuci skriptu ${0##*/}? (Zadejte '1' nebo '2' pro výběr možnosti)"
select yn in "Ano" "Ne"; do
    case $yn in
        Ano ) execute; echo "Skript ${0##*/} úspěšně dokončen"; break;;
        Ne ) echo "Spuštění skriptu ${0##*/} odmítnuto."; exit;;
    esac
done