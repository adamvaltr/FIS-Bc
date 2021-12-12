# Grafana

- Adresář: `/grafana`

Popis ukázkového dashboardu a upozornění v Grafana a jejich Flux dotazy do databáze.

## Použití

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

## Popis databáze

- Databáze: `InfluxDB`
- Organizace: `fis-bc`
- Bucket: `mve`

### Seznam měření

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

### Seznam tagů

- `tag1`
- `tag2`

### Seznam měřených hodnot

- `vykonkWh`
- `hladinaCm`
- `teplotaCelsia`

### Datová struktura

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

## Dashboard FIS-Bc, jeho panely a upozornění

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

### Celkový výkon

Panel měřidlo, který zobrazuje celkový výkon elektrárny - tedy obou soustrojí. Zobrazuje součet aktuálního výkonu obou soustrojí v `kWh`. Stupnice měřidla je od `0 kWh` do `120 kWh` (minimální a maximální výkon, kterého je elektrárna schopna dosáhnout). Klesne-li výkon pod `20 kWh`, měřidlo zmodná, pokud je výkon přes `100 kWh`, pak měřidlo zčervená, jinak je zelené.

#### Flux dotaz

Získá všechna data o výkonu za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
```

#### Transformace dat

Grafana získaná data o výkonu jednotlivých generátorů sečte sloučením řádků tabulky se stejnou časovou značkou a z výsledné tabulky zobrazí nejaktuálnější záznam časové řady.

------------

### Průměrný výkon
Panel koláčový graf, který zobrazuje průměrný výkon soustrojí jako podíl na celku v `kWh`.

#### Flux dotaz
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

### Kumulativní výroba

Panel stat zobrazuje kumulativní výrobu obou generátorů dohromady v `kWh`. Tedy kolik elektrické energie elektrárna vyrobila.

#### Flux dotaz

Získá všechna data o výkonu od pevného datumu, agreguje je v `60` minutových intervalech a vypočítá průměr agregovaných dat.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
  |> aggregateWindow(every: 1h, fn: mean)
```

#### Transformace dat

Grafana pro získaná agregovaná data přidá sloupec se součtem dat z řádku a posléze sečte všechna data v součtovém sloupci.

------------

### Upozornění

Panel upozornění zobrazuje seznam aktivních upozorněních s počítadlem, indikujícím, jak dlouho je již upozornění aktivní. Upozornění se řadí dle času aktivace - tedy nejaktuálnější upozornění se zobrazí v seznamu první.

Smyslem upozornění je identifikovat neobvyklé nebo nebezpečné stavy elektrárny a informovat o nich obsluhu, aby mohla situaci investigovat a případně zakročit.

#### Upozornění: Výkon

Slouží k upozornění na stav elektrárny, kdy průměrný výkon alespoň jednoho generátoru za poslední hodinu klesne pod `10 kWh`.

##### Flux dotazy pro upozornění

Dotazy získají data nad kterými bude vyhodnocováno splnění logické podmínky.

###### A

Získá data o výkonu TG1 za poslední hodinu.

```Flux
from(bucket:"mve")
  |> range(start: -1h)
  |> filter(fn: (r) =>
    r._measurement == "merVykonu1"
  )
```

###### B

Získá data o výkonu TG2 za poslední hodinu.

```Flux
from(bucket:"mve")
  |> range(start: -1h)
  |> filter(fn: (r) =>
    r._measurement == "merVykonu2"
  )
```

###### C

Podmínka boolean. Vyhodnotí, zda průměr `A` nebo průměr `B` je méně než `10`.

```
WHEN    avg()   of  A   IS BELOW    10
OR      avg()   of  B   IS BELOW    10
```

##### Nastavení

- Evaluace: K evaluaci podmínky C dochází každou `1` minutu a podmínka musí být splněna po dobu `5` minut, aby došlo k aktivaci upozornění.
- Popis: Průměrný výkon jedné z turbín je již hodinu nižší než `10 kWh`.
- Souhrn: Nízký výkon turbíny.

------------

#### Upozornění: Hladina

Slouží k upozornění na stav elektrárny, kdy průměrná hladina reportovaná alespoň jednou sondou se vychýlí z rozmezí `-10` až `10` centimetrů.

##### Flux dotazy pro upozornění

Dotazy získají data nad kterými bude vyhodnocováno splnění logické podmínky.

###### A

Získá data ze všech hladinových sond za posledních `10` minut.

```Flux
from(bucket:"mve")
  |> range(start: -10m)
  |> filter(fn: (r) =>
    r.tag2 == "hladina"
  )
```

###### B

Podmínka boolean. Vyhodnotí, zda průměr `A` je mimo rozmezí `-10` až `10` centimetrů.

```
WHEN    avg()   of  A   IS OUTSIDE RANGE    -10 TO  10
```

##### Nastavení

- Evaluace: K evaluaci podmínky `C` dochází každou `1` minutu a podmínka musí být splněna po dobu `2` minut, aby došlo k aktivaci upozornění.
- Popis: Průměrné hladina vody za posledních `10` minut, alespoň na jedné sondě, je mimo rozmezí `-10` až `10` centimetrů.
- Souhrn: Hladina mimo rozmezí.

------------

#### Upozornění: Teplota

Slouží k upozornění na stav elektrárny, kdy maximální nebo minimální průměrná hodinová teplota reportovaná alespoň jednou sondou se v předchozích `24` hodinách vychýlila z romezí `10` až `75` stupňů Celsia.

##### Flux dotazy pro upozornění

Dotazy získají data nad kterými bude vyhodnocováno splnění logické podmínky.

###### A

Získá data ze všech hladinových sond za posledních `10` minut.

```Flux
from(bucket:"mve")
  |> range(start: -1d)
  |> filter(fn: (r) =>
    r.tag2 == "teplota"
  )
  |> aggregateWindow(every: 1h, fn: mean)
```

###### B

Podmínka `boolean`. Vyhodnotí, zda maximun `A` je vyšší než `75` nebo minimum `A` je nižší než `10` stupňů Celsia.

```
WHEN    max()   of  A   IS ABOVE    75
OR      min()   of  A   IS BELOW    10
```

##### Nastavení

- Evaluace: K evaluaci podmínky B dochází každých `30` minut a k aktivaci upozornění dochází okamžitě při jejím splnění.
- Popis: Maximální nebo minimální průměrná hodinová teplota byla za posledních `24` hodin mimo bezpečné rozmezí.
- Souhrn: Teplota na nebezpečné úrovni.

------------

### Výkon TG1 a Výkon TG2

Panel měřidlo, který zobrazuje výkon TG1 v `kWh`. Stupnice měřidla je od `0 kWh` do `60 kWh` (minimální a maximální výkon TG1). Klesne-li výkon pod `10 kWh`, měřidlo zmodná, pokud je výkon přes `50 kWh`, pak měřidlo zčervená, jinak je zelené. Měřidlo zobrazí nejaktuálnější záznam získané časové řady.

#### Flux dotaz pro Výkon TG1

Získá data o výkonu TG1 za posledních `20` sekund.

```Flux
from(bucket:"mve")
  |> range(start: -20s)
  |> filter(fn: (r) =>
    r.tag1 == "TG1" and
    r.tag2 == "vykon"
  )
```

#### Flux dotaz pro Výkon TG2

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

### Hladina nad TG1 a Hladina nad TG2

Panel sloupcová měrka, který zobrazuje aktuální hladinu vody nad soustrojím v `cm` jako odchylku od běžné hladiny, která je v datech reprezentována hodnotou `0` centimetrů. Rozmezí měrky je `-20` až `20` centimetrů. Pokud je hladina pod záporná, pak měrka zčervená, jinak je zelená.

#### Flux dotaz pro Hladina nad TG1

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

#### Flux dotaz pro Hladina nad TG2

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

### Hladina pod TG1 a Hladina pod TG2

Panel sloupcová měrka, který zobrazuje aktuální hladinu vody pod soustrojím. Analogicky, jako panely zobrazující hladinu nad soustrojím, má měrka rozmezí `-20` až `20` centimetrů - avšak logika zabarvení zelenou a červenou barvou je opačná, neboť pod soustrojím je žádoucí co nejnižší hladina.

#### Flux dotaz pro Hladina pod TG1

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

#### Flux dotaz pro Hladina pod TG2

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

### Teplota ložiska generátoru TG1 a Teplota ložiska generátoru TG2

Panel sloupcová měrka, který zobrazuje aktuální teplotu ložiska příslušného generátoru ve stupních Celsia. Rozmezí měrky je `-5` až `90` stupňů a zabarvuje se v barevném gradientu `modrá-žlutá-červená`.

#### Flux dotaz pro Teplota ložiska generátoru TG1

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

#### Flux dotaz pro Teplota ložiska generátoru TG2

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

### Teplota ložiska turbíny TG1 a Teplota ložiska turbíny TG2

Panel sloupcová měrka, který zobrazuje aktuální teplotu ložiska příslušné turbíny ve stupních Celsia. Rozmezí měrky je `-5` až `90` stupňů a zabarvuje se v barevném gradientu `modrá-žlutá-červená`.

#### Flux dotaz pro Teplota ložiska generátoru TG1

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

#### Flux dotaz pro Teplota ložiska generátoru TG2

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

### Výkon

Panel časová řada, který zobrazuje výkon jednotlivých generátorů a součet jejich výkonů v liniovém grafu. Na ose `X` je čas a na ose `Y` výkon v `kWh`. V grafu jsou tedy vykresleny tři linie.

#### Flux dotaz pro Výkon

Získá všechna data o výkonu od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
  ```

#### Transformace dat

Grafana k získaným datům o výkonu jednotlivých generátorů přidá sloupec se součtem dat z řádku. Takto vzniklý součtový sloupec pak vykreslí do grafu jako samostatnou linii představující součet výkonů generátorů v daný moment.

------------

### Výkon

Panel časová řada, který zobrazuje výkon jednotlivých generátorů a součet jejich výkonů v liniovém grafu. Na ose `X` je čas a na ose `Y` výkon v `kWh`. V grafu jsou tedy vykresleny tři linie.

#### Flux dotaz pro Výkon

Získá všechna data o výkonu od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "vykon"
  )
  ```

#### Transformace dat

Grafana k získaným datům o výkonu jednotlivých generátorů přidá sloupec se součtem dat z řádku. Takto vzniklý součtový sloupec pak vykreslí do grafu jako samostatnou linii představující součet výkonů generátorů v daný moment.

------------

### Hladina

Panel časová řada, který zobrazuje výšku hladiny reportovanou hladinovými sondami v liniovém grafu. Na ose `X` je čas a na ose `Y` výška hladiny v `cm`. V grafu jsou tedy vykresleny čtyři linie, z nichž každá reprezentuje data z jedné hladinové sondy.

#### Flux dotaz pro Hladina

Získá všechna data o hladinách od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-01-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "hladina"
  )
  ```

------------

### Průměrná hladina nad MVE

Panel stat zobrazuje průměrnou výšku hladiny nad oběma soustrojími v `cm`. Pokud je průměrná hladina méně než `0` centimetrů, pak je panel červený, jinak je zelený.

#### Flux dotaz pro Průměrná hladina nad MVE

Získá všechna data o hladinách nad oběma soustrojími od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-01-01T00:00:00Z)
  |> filter(fn: (r) =>
    r._measurement == "merHladiny1" or
    r._measurement == "merHladiny3"
  )
  ```

#### Transformace dat

Grafana nejdříve sloučí řádky tabulky se stejnou časovou značkou a zprůměruje jejich hodnotu. Poté získá průměr všech výsledných řádků, který zobrazí jako výsledek. 

------------

### Průměrná hladina pod MVE

Panel stat zobrazuje průměrnou výšku hladiny pod oběma soustrojími v `cm`. Pokud je průměrná hladina méně než `0` centimetrů, pak je panel zelený, jinak je červený. Tedy opak logiky panelu Průměrná hladina nad MVE, neboť pod soustrojími se preferuje záporná hladina.

#### Flux dotaz pro Průměrná hladina pod MVE

Získá všechna data o hladinách pod oběma soustrojími od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-01-01T00:00:00Z)
  |> filter(fn: (r) =>
    r._measurement == "merHladiny2" or
    r._measurement == "merHladiny4"
  )
  ```

#### Transformace dat

Grafana nejdříve sloučí řádky tabulky se stejnou časovou značkou a zprůměruje jejich hodnotu. Poté získá průměr všech výsledných řádků, který zobrazí jako výsledek. 

------------

### Teplota ložisek

Panel časová řada, který zobrazuje teplotu ložisek generátorů a turbín v liniovém grafu. Na ose `X` je čas a na ose `Y` teplota ve stupních Celsia. V grafu jsou tedy vykresleny čtyři linie, z nichž každá reprezentuje data z jedné teplotní sondy.

#### Flux dotaz pro Teplota ložisek

Získá všechna data o teplotách ložisek od pevného datumu.

```Flux
from(bucket:"mve")
  |> range(start: 2021-12-01T00:00:00Z)
  |> filter(fn: (r) =>
    r.tag2 == "teplota"
  )
  ```

------------