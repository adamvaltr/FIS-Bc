# Klient
# Zasílá data serveru

import requests, json
from requests.structures import CaseInsensitiveDict

# Otevře JSON s nastavením
options_file = open('options.json')
   
# vrátí JSON objekt jako dictionary
options = json.load(options_file)

# POST
url = "https://bc.linode.valtr.eu:8086/api/v2/write?org=fis-bc&bucket=test&precision=s"

headers = CaseInsensitiveDict()
headers["Authorization"] = "Token WVfLlr1G436e0KZDgx4fBFw65KkMa0USesJZurxXEFRx2vFDDfeU-SMAyU0_mIPNy8iDx20wKXrxRBGhUaIwQQ=="
headers["Content-Type"] = "text/plain; charset=utf-8"
headers["Accept"] = "application/json"

data = 'myMeasurement,tag1=value1,tag2=value2 fieldKey="fieldValue"'


resp = requests.post(url, headers=headers, data=data)

print(resp.status_code)