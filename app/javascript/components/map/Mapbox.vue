<template>
  <div class="map--statistics sm-counter-trigger">
    <div class="map__panel gutters">
      <p class="map__panel-title">{{ titleGlobal }}</p>

      <p class="map__panel-stat no-margin">
        <counter sm-trigger="sm-counter-trigger" sm-target="sm-counter-target" :number="percentageGlobal"></counter>
        <template v-if="habitatType != 'points'"> km<sup>2</sup></template>
      </p>

      <p class="map__panel-title">{{ titleProtected }}</p>

      <span class="map__panel-stat">
        <counter sm-trigger="sm-counter-trigger" sm-target="sm-counter-target" :number="percentageProtected"></counter>%
      </span>

      <p class="map__panel-layer map__panel-layer-habitat">{{ habitat }}</p>
      <p class="map__panel-layer">Protected Areas</p>
    </div>

    <div id="map" class="map__map"></div>
  </div>
</template>

<script>
  import Counter from '../counter/Counter'

  export default {
    name: 'mapbox',

    components: { Counter },

    props: {
      habitat: String,
      habitatType: String,
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
        mapboxToken: process.env.MAPBOX_TOKEN,
        cartoUsername: process.env.CARTO_USERNAME,
        cartoApiKey: process.env.CARTO_API_KEY,
        wdpaTables: [process.env.WDPA_POLY_TABLE, process.env.WDPA_POINT_TABLE],
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
        mapboxgl.accessToken = this.mapboxToken

        let map = new mapboxgl.Map({
          container: 'map',
          style: 'mapbox://styles/unepwcmc/cjoa5g1k910bb2rpezelvlu9k',
          center: [0.000000, -0.000000],
          zoom: 1.3
        })

        map.scrollZoom.disable()
        map.addControl(new mapboxgl.NavigationControl({ showCompass: false }))

        this.map = map

        this.addTiles()
      },

      addTiles () {
        let tiles = new cartodb.Tiles({
          user_name: this.cartoUsername,
          tiler_protocol: 'https',
          tiler_port: '443',
          sublayers: [
            {
              sql: this.generateSQL(this.wdpaTables),
              cartocss: '#layer {polygon-fill: #ff00ff}'
            },
            {
              sql: this.generateSQL(this.tables),
              cartocss: '#layer {polygon-fill: #ff00ff}'
            }
          ],
          extra_params: { map_key: this.cartoApiKey }
        })

        tiles.getTiles(object => {
          this.addLayer(tiles, 'layer0', 'wdpa', this.themes.wdpa, false, .2)
          this.addLayer(tiles, 'layer0', 'wdpa-points', this.themes.wdpa, true, .2)
          this.addLayer(tiles, 'layer1', 'habitat', this.themes[this.theme], false, .8)
          this.addLayer(tiles, 'layer1', 'habitat-points', this.themes[this.theme], true, .8)
        })
      },

      addLayer (tiles, source, id, colour, point, opacity) {
        let options = {
          'id': id,
          'source': {
            'type': 'vector',
            'tiles': tiles.mapProperties.mapProperties.metadata.tilejson.vector.tiles
          },
          'source-layer': source
        }

        if(point){
          options['type'] = 'circle'
          options['paint'] = { 'circle-radius': 2, 'circle-color': colour, 'circle-opacity': opacity }
          options['filter'] = ['==', '$type', 'Point']
        } else {
          options['type'] = 'fill'
          options['paint'] = { 'fill-color': colour, 'fill-opacity': opacity }
        }

        this.map.addLayer(options)
      },

      generateSQL (tables) {
        let sqlArray = []

        tables.forEach(table => {
          if(table == process.env.WDPA_POLY_TABLE || table == process.env.WDPA_POINT_TABLE) {
            sqlArray.push(`SELECT cartodb_id, the_geom, the_geom_webmercator FROM ${table} WHERE marine::INT > 0`)
          }
          else {
            sqlArray.push(`SELECT cartodb_id, the_geom, the_geom_webmercator FROM ${table}`)
          }
        })

        const sql = sqlArray.join(' UNION ALL ')

        return sql
      }
    }
  }
</script>
