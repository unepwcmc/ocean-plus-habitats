<template>
  <div class="map--statistics">
    <div class="map__panel gutters">
      <p class="map__panel-title">{{ titleGlobal }}</p>
      <span class="map__panel-stat">{{ percentageGlobal }}Km<sup>2</sup></span>

      <p class="map__panel-title">{{ titleProtected }}</p>
      <span class="map__panel-stat">{{ percentageProtected }}%</span>

      <p class="map__panel-layer map__panel-layer-habitat">{{ habitat }}</p>
      <p class="map__panel-layer">Protected Areas</p>
    </div>

    <div id="map" class="map__map"></div>
  </div>
</template>

<script>
  export default {
    name: 'mapbox',

    props: {
      habitat: String,
      theme: String,
      titleGlobal: String,
      titleProtected: String,
      percentageGlobal: Number,
      percentageProtected: Number,
      tables: Array
    },

    data () {
      return {
        map: {},
        mapbox: {
          accessToken: process.env.MAPBOX_TOKEN,
          // baseUrl: 'https://api.mapbox.com/geocoding/v5/mapbox.places'
        },
        themes: {
          wdpa: '#BA41FF',
          blue: '#7AB6FF',
          green: '#3FD18B',
          orange: '#FF8A75',
          pink: '#F35F8D',
          yellow: '#FCDA68'
        }
      }
    },

    mounted () {
      this.createMap()
    },

    methods: {
      createMap () {
        mapboxgl.accessToken = this.mapbox.accessToken

        let map = new mapboxgl.Map({
          container: 'map',
          style: 'mapbox://styles/unepwcmc/cjoa5g1k910bb2rpezelvlu9k',
          center: [0.000000, -0.000000],
          zoom: 1.3
        })

        map.scrollZoom.disable()

        this.map = map

        const tiles = this.addTiles()
      },

      addTiles () {
        let tiles = new cartodb.Tiles({
          user_name: process.env.CARTO_USERNAME,
          tiler_protocol: 'https',
          tiler_port: '443',
          sublayers: [
            {
              sql: this.generateSQL(),
              cartocss: '#layer {polygon-fill: #ff00ff}'
            },
            {
              sql: this.generateHabitatSQL(),
              cartocss: '#layer {polygon-fill: #ff00ff}'
            }
          ],
          extra_params: { map_key: process.env.CARTO_API_KEY }
        })

        console.log(tiles)

        tiles.getTiles(object => {
          this.map.addLayer({
            'id': 'wdpa',
            'type': 'fill',
            'source': {
              'type': 'vector',
              'tiles': tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
            },
            'source-layer': 'layer0',
            'paint': {
              'fill-color': this.themes.wdpa,
              'fill-opacity': .8
            },
            'layout': {

            }
          }),

          this.map.addLayer({
            'id': 'habitat',
            'type': 'fill',
            'source': {
              'type': 'vector',
              'tiles': tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
            },
            'source-layer': 'layer1',
            'paint': {
              'fill-color': this.themes[this.theme],
              'fill-opacity': .8
            },
            'layout': {

            }
          }),

          this.map.addLayer({
            'id': 'wdpa-points',
            'type': 'circle',
            'source': {
              'type': 'vector',
              'tiles': tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
            },
            'source-layer': 'layer0',
            'paint': {
              'circle-radius': 3,
              'circle-color': this.themes.wdpa,
            },
            'filter': ['==', '$type', 'Point'],
            'layout': {
            }
          }),

          this.map.addLayer({
            'id': 'habitat-points',
            'type': 'circle',
            'source': {
              'type': 'vector',
              'tiles': tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
            },
            'source-layer': 'layer1',
            'paint': {
              'circle-radius': 3,
              'circle-color': this.themes[this.theme],
            },
            'filter': ['==', '$type', 'Point'],
            'layout': {
            }
          })
        })
      },

      generateSQL () {
        const tables = [],
          sqlArray = []

        tables.push(process.env.WDPA_POLY_TABLE)
        tables.push(process.env.WDPA_POINT_TABLE)

        tables.forEach(table => {
          sqlArray.push(`SELECT cartodb_id, the_geom, the_geom_webmercator FROM ${table}`)
        })

        const sql = sqlArray.join(' UNION ALL ')

        return sql
      },

      generateHabitatSQL () {
        const tables = this.tables,
          sqlArray = []

        tables.forEach(table => {
          sqlArray.push(`SELECT cartodb_id, the_geom, the_geom_webmercator FROM ${table}`)
        })

        const sql = sqlArray.join(' UNION ALL ')

        return sql
      }
    }
  }
</script>
