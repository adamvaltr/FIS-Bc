#!/bin/bash
###############################################################################
# Bash skript k nasazení softwarového vybavení serveru.
# Zpracováno jako součást bakalářské práce na FIS VŠE v Praze na téma Řízení malé vodní elektrárny.
# Testováno na Debian 11. 
# Autor @AdamValtr @2021
###############################################################################

TITLE="Nasazení softwarového vybavení"                                # Název
AUTHOR="Adam Valtr"                                                   # Autor
TAGLINE="Skript k automatické instalaci, konfiguraci nebo odstranění softwarového vybavení."      # Stručný popis
default=true                                                          # Proměnná indikující typ exekuce
manpagename=$(printf "$TITLE" | tr '[:lower:]' '[:upper:]')           # Transformuje písmena názvu na velká.
################################## man_page ###################################
# Stránka pomoci (manuál) - která se zobrazí při užití vlajky -h.
man_page(){
 
printf "
$manpagename(1)                      Uživatelské příkazy                      MANUÁL(1)
 
NÁZEV
       $TITLE - $TAGLINE 
 
SYNOPSE
       $TITLE [MOŽNOSTI]... 
POPIS
       Bash skript k nasazení softwarového vybavení serveru umožňující jeho automatickou
       instalaci, konfiguraci nebo odstranění. Tento skript byl zpracován jako součást
       bakalářské práce na FIS VŠE v Praze a byl testován na Debian 11.

       -d
              Vlajka k ladění (debugging). Podružné skripty se spustí s povolenou
              možností: -x

       -h
              Zobrazí tento manuál
 
       -i
              Nainstaluje softwarové vybavení pomocí setup_lib/install.sh

       -c
              Nasadí konfiguraci softwarového vybavení pomocí setup_lib/install.sh

       -r
              Odstraní nainstalovaný software a konfiguraci učiněné
              setup_lib/install.sh a setup_lib/configure.sh

"
}
##############################################################################

############################### debug_program ################################ 
# Spustí podružné skripty v ladícím (debugging) módu.
debug_program(){
       debugflag="-x"
       if $default; then run_default; fi # Zkontroluje, že je požadován defaultní průběh
}
##############################################################################
 
############################### run_default ##################################
# Defaultní exekuce při spuštění skriptu bez vlajek nebo bez vlajky
# modifikující hodnotu proměnné "default" na "false".
run_default(){
       run_install
       run_configure
}
##############################################################################

############################### run_install ##################################
# Defaultní exekuce při spuštění skriptu bez vlajek.
run_install(){
       bash $debugflag ./setup_lib/install.sh
}
##############################################################################

############################### run_configure ################################
# Defaultní exekuce při spuštění skriptu bez vlajek.
run_configure(){
       bash $debugflag ./setup_lib/configure.sh
}
##############################################################################

############################### run_remove ###################################
# Defaultní exekuce při spuštění skriptu bez vlajek.
run_remove(){
       bash $debugflag ./setup_lib/remove.sh
}
##############################################################################

# getopts - definuje možnosti (vlajky)
optstring=":dhcir"
while getopts ${optstring} option
do
case "${option}"
in
h) MANPAGE="man_page";;
d) DEBUG="debug_program";;
i) INSTALL="run_install"; default=false;;
c) CONFIGURE="run_configure"; default=false;;
r) REMOVE="run_remove"; default=false;;
?)     # Použita nedefinovaná vlajka
      echo "Neznámá možnost (vlajka): -${OPTARG}."
      echo "Použijte vlajku -h pro zobrazení nápovědy."
esac
done
 
# Logika skriptu
while true
do
# Pokud nejsou zadány vlajky, spustí defaultní průběh.
if [ $OPTIND -eq 1 ]; then run_default; fi
#Průběhy s vlajkou
shift $((OPTIND-1))
$MANPAGE
$DEBUG
$INSTALL
$CONFIGURE
$REMOVE
exit
done