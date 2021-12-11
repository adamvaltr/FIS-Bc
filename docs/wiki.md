# Dokumentace k programovému vybavení

Tento dokument obsahuje dokumentaci programového vybavení jež je součástí bakalářské práce Adama Valtra na téma Řízení malé vodní elektrárny vypracované v roce 2021 na Fakultě informatiky a statistiky Vysoké školy ekonomické v Praze. Vypracované programové vybavení zahrnuje CLI nástroj napsaný v `Bash Shell`, který na systému s Linux Debian nebo distribuci z něj odvozenou dokáže nainstalovat, nakonfigurovat nebo odinstalovat databázový server InfluxDB a webovou analytickou a vizualizační platformu Grafana tak, aby klientské zařízení (v tomto případě MVE) mohlo odesílat svá senzorová data na server přes zabezpečené `HTTPS`, a tato data byla dostupná pro následnou analýzu a vizualizaci v Grafana. Dalším článkem programového vybavení je program v jazyce `Python`, který představuje klienta (MVE), který odesílá senzorová data do databáze. Tento program má za úkol nahradit reálnou MVE jako zdroj senzorových dat. V době vypracovávání práce autor nezískal přístup k reálné MVE, kterou by bylo možné nastavit/upravit pro odesílání dat o jejím stavu na vzdálený server prostřednictvím sítě Internet. Program pravidelně generuje data a odesílá je jako `HTTP POST` požadavky serveru. Struktura a hodnoty generovaných dat jsou v programu implementovány tak, aby v omezené a zjednodušené míře imitovala data, která by skutečná MVE mohla o svém stavu sbírat a reportovat o nich. Vypracované programové vybavení také zahrnuje šablonu dashboardu Grafana, jenž obsahuje přednastavené panely a upozornění pro vizualizaci a analýzu dat získávaných z implementované databáze. Celý soubor programového vybavení tedy funguje jako celek a jeho jednotlivé části se navzájem doplňují.

## Členění dokumentace

Dokumentace je rozdělena do tří hlavních kapitol zastřešujících funkční celky v pořadí ve kterém autor doporučuje programové vybavení použít:

- Server
  - CLI nástroj pro automatizovanou instalaci a konfiguraci InfluxDB a Grafana.
- Klient
  - Program generující a odesílající senzorová data.
- Grafana
  - Popisuje ukázkový dashboard a upozornění v Grafana a jejich Flux dotazy do databáze.

## Adresářová struktura

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