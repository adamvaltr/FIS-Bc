# Výpis použitých FLUX dotazů pro tvorbu ukázkového dashboardu v Grafana

## Popis databáze

- Databáze: InfluxDB
- Organizace: fis-bc
- Bucket: mve

### Seznam měřidel

- merVykonu1
- merVykonu2
- merHladiny1
- merHladiny2
- merHladiny3
- merHladiny4
- merTeploty1
- merTeploty2
- merTeploty3
- merTeploty4

### Seznam tagů

- tag1
- tag2

### Seznam měřených hodnot

- vykonkWh
- hladinaCm
- teplotaCelsia

### Datová struktura

- merVykonu1
    - tag1 : TG1
    - tag2 : vykon
    - vykonkWh : [integer]
- merVykonu2
    - tag1 : TG2
    - tag2 : vykon
    - vykonkWh : [integer]
- merHladiny1
    - tag1 : TG1
    - tag2 : hladina
    - hladinaCm : [integer]
- merHladiny2
    - tag1 : TG1
    - tag2 : hladina
    - hladinaCm : [integer]
- merHladiny3
    - tag1 : TG2
    - tag2 : hladina
    - hladinaCm : [integer]
- merHladiny4
    - tag1 : TG2
    - tag2 : hladina
    - hladinaCm : [integer]
- merTeploty1
    - tag1 : TG1
    - tag2 : teplota
    - teplotaCelsia : [integer]
- merTeploty2
    - tag1 : TG1
    - tag2 : teplota
    - teplotaCelsia : [integer]
- merTeploty3
    - tag1 : TG2
    - tag2 : teplota
    - teplotaCelsia : [integer]
- merTeploty4
    - tag1 : TG2
    - tag2 : teplota
    - teplotaCelsia : [integer]

------------

## Flux query dotazy

### Měřidlo výkonu TG1

```Flux
from(bucket:"mve")
  |> range(start: -1m)
  |> filter(fn: (r) =>
    r.tag1 == "TG1" and
    r.tag2 == "vykon"
  )
```

