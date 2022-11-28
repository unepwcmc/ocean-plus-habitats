# Ocean+ Habitats API

## Licensing
The Ocean+ Habitats API does not currently require any licensing or tokens to use.

## Endpoints
The Ocean+ Habitats API exposes statistics regarding protected area coverage, habitat coverage change and Species Red List statuses.

This information can be requested either grouped by country or for a given region.

### Countries
Country-level data can be requested grouped by country or for a specific country.

Endpoints: 
- Index: GET `api/v1/countries`
- Show: GET `api/v1/countries/:iso3`

#### Index
Example response:

```
[
  metadata: {
    page: 1,
    per_page: 25,
    page_count: 9,
    total_count: 207
  },
  records: {
      "name": "Aland Islands",
      "iso3": "ALA",
      "protected_area_statistics": [
        {
          "name": "seagrasses",
          "total_area": "0.0",
          "protected_area": "0.0000124106493716223",
          "percent_protected": "0.0"
        },
        {
          "name": "mangroves",
          "total_area": "0.0",
          "protected_area": "0.0",
          "percent_protected": "0.0"
        },
        {
          "name": "coralreefs",
          "total_area": "0.0",
          "protected_area": "0.0",
          "percent_protected": "0.0"
        },
        {
          "name": "coldcorals",
          "total_area": "0.0",
          "protected_area": "0.0",
          "percent_protected": "0.0"
        },
        {
          "name": "saltmarshes",
          "total_area": "0.0223843042827022",
          "protected_area": "0.758065181942218",
          "percent_protected": "2.95282052466148"
        }
      ]
    },
    {
      "name": "Albania",
      "iso3": "ALB",
      "protected_area_statistics": [
        {
          "name": "coralreefs",
          "total_area": "0.0",
          "protected_area": "0.0",
          "percent_protected": "0.0"
        },
        {
          "name": "mangroves",
          "total_area": "0.0",
          "protected_area": "0.0",
          "percent_protected": "0.0"
        },
        {
          "name": "coldcorals",
          "total_area": "0.0",
          "protected_area": "5.98647948252716",
          "percent_protected": "0.0"
        },
        {
          "name": "seagrasses",
          "total_area": "2.93708153556099",
          "protected_area": "44.0192816483413",
          "percent_protected": "6.67226139450565"
        },
        {
          "name": "saltmarshes",
          "total_area": "46.2691076755062",
          "protected_area": "54.5599588089528",
          "percent_protected": "84.8041470073724"
        }
      ]
    }
  },
  ...
]
```

#### Show
Example response:

```
{
  "name": "Australia",
  "iso3": "AUS",
  "protected_area_statistics": [
    {
      "name": "coralreefs",
      "total_area": "27425.283541278",
      "protected_area": "31683.868469488",
      "percent_protected": "86.5591383441355"
    },
    {
      "name": "saltmarshes",
      "total_area": "4224.08922741877",
      "protected_area": "13186.5854733994",
      "percent_protected": "32.0332297996308"
    },
    {
      "name": "mangroves",
      "total_area": "4802.07596294615",
      "protected_area": "9781.88028304306",
      "percent_protected": "49.0915429753375"
    },
    {
      "name": "seagrasses",
      "total_area": "16225.1429283009",
      "protected_area": "41008.9779166146",
      "percent_protected": "39.5648556793885"
    },
    {
      "name": "coldcorals",
      "total_area": "122.414638995168",
      "protected_area": "333.428727950404",
      "percent_protected": "36.7138847776118"
    }
  ],
  "species_status": {
    "coralreefs": [
      ["CR", 1],
      ["EN", 9],
      ["VU", 162],
      ["NT", 150],
      ["LC", 218],
      ["DD", 52],
      ["NE", 0],
      ["total", 592]
    ],
    "seagrasses": [
      ["CR", 0],
      ["EN", 0],
      ["VU", 1],
      ["NT", 1],
      ["LC", 30],
      ["DD", 0],
      ["NE", 4],
      ["total", 36]
    ],
    "saltmarshes": [
      ["CR", 0],
      ["EN", 0],
      ["VU", 0],
      ["NT", 0],
      ["LC", 27],
      ["DD", 1],
      ["NE", 4],
      ["total", 32]
    ],
    "mangroves": [
      ["CR", 0],
      ["EN", 0],
      ["VU", 1],
      ["NT", 1],
      ["LC", 34],
      ["DD", 0],
      ["NE", 7],
      ["total", 43]
    ],
    "coldcorals": [
      ["CR", 0],
      ["EN", 0],
      ["VU", 0],
      ["NT", 0],
      ["LC", 5],
      ["DD", 0],
      ["NE", 6],
      ["total", 11]
    ]
  }
}
```

### Regions
Region-level data can be requested only for a specific region. The Index endpoint will return a list of regions with their name and ID.

Endpoints: 
- Index: GET `api/v1/regions`
- Show: GET `api/v1/regions/:id`

_Note, region id can be retrieved from the Index response._

#### Index
Returns all regions within Ocean+ Habitats. Do not assume the IDs in this example will be correct for the latest data provided by the API.

Example response:

```
[
  {
    id: 208,
    name: 'Antarctic'
  }
  {
    id: 209,
    name: 'Baltic Sea'
  },
  ...
]
```

#### Show
Example response:

```
{
    "id": 213,
    "name": "Eastern Africa",
    "protected_area_statistics": [
        {
            "name": "coralreefs",
            "total_area": "2714.60380387822",
            "protected_area": "9576.22364678499",
            "percent_protected": "28.3473308895578"
        },
        {
            "name": "saltmarshes",
            "total_area": "3760.78112847826",
            "protected_area": "6863.30237922751",
            "percent_protected": "54.7955039815914"
        },
        {
            "name": "mangroves",
            "total_area": "3760.78112847826",
            "protected_area": "7240.539621204",
            "percent_protected": "51.9406194182652"
        },
        {
            "name": "seagrasses",
            "total_area": "3566.94730816491",
            "protected_area": "11225.3934488891",
            "percent_protected": "31.7756996617158"
        },
        {
            "name": "coldcorals",
            "total_area": "0.0000790273130984406",
            "protected_area": "0.000259953624046374",
            "percent_protected": "30.4005429385137"
        }
    ],
    "habitat_change_statistics": [
        {
            "name": "mangroves",
            "total_area": {
                "total_value_1996": "7540.75998764203",
                "total_value_2007": "7281.55131473272",
                "total_value_2008": "7304.8783090984",
                "total_value_2009": "7296.02930815457",
                "total_value_2010": "0.0",
                "total_value_2015": "7235.42899839272",
                "total_value_2016": "7240.539621204",
                "baseline_year": 2010
            }
        }
    ],
    "species_status": {
        "coralreefs": [
            ["CR", 0],
            ["EN", 7],
            ["VU", 79],
            ["NT", 119],
            ["LC", 183],
            ["DD", 22],
            ["NE", 0],
            ["total", 410]
        ],
        "mangroves": [
            ["CR", 0],
            ["EN", 0],
            ["VU", 0],
            ["NT", 0],
            ["LC", 10],
            ["DD", 0],
            ["NE", 0],
            ["total", 10]
        ],
        "saltmarshes": [
            ["CR", 0],
            ["EN", 0],
            ["VU", 0],
            ["NT", 0],
            ["LC", 2],
            ["DD", 0],
            ["NE", 0],
            ["total", 2]
        ],
        "coldcorals": [
            ["CR", 0],
            ["EN", 0],
            ["VU", 0],
            ["NT", 0],
            ["LC", 3],
            ["DD", 0],
            ["NE", 0],
            ["total", 3]
        ],
        "seagrasses": [
            ["CR", 0],
            ["EN", 0],
            ["VU", 1],
            ["NT", 0],
            ["LC", 12],
            ["DD", 1],
            ["NE", 0],
            ["total", 14]
        ]
    },
    "countries": [
        {
            "name": "Comoros",
            "iso3": "COM"
        },
        {
            "name": "French Southern And Antarctic Territories",
            "iso3": "ATF"
        },
        {
            "name": "Kenya",
            "iso3": "KEN"
        },
        {
            "name": "Madagascar",
            "iso3": "MDG"
        },
        {
            "name": "Mauritius",
            "iso3": "MUS"
        },
        {
            "name": "Mayotte",
            "iso3": "MYT"
        },
        {
            "name": "Mozambique",
            "iso3": "MOZ"
        },
        {
            "name": "Reunion",
            "iso3": "REU"
        },
        {
            "name": "Seychelles",
            "iso3": "SYC"
        },
        {
            "name": "Somalia",
            "iso3": "SOM"
        },
        {
            "name": "South Africa",
            "iso3": "ZAF"
        },
        {
            "name": "Tanzania United Republic Of",
            "iso3": "TZA"
        }
    ]
}
```

## Pagination
Endpoints with pagination will all accept the following query parameters:

| Parameter   | Options             | Description                      |
|-------------|---------------------|----------------------------------|
| page        | Integer; Default: 1 | Defines the desired results page |
