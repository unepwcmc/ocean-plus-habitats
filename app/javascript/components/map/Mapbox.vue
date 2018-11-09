<template>
  <div class="map--statistics">
    <div class="map__panel gutters">
      <p class="map__panel-title">{{ titleGlobal }}</p>
      <span class="map__panel-stat">{{ percentageGlobal }}Km<sup>2</sup></span>

      <p class="map__panel-title">{{ titleProtected }}</p>
      <span class="map__panel-stat">{{ percentageProtected }}%</span>

      <p class="map__panel-layer">{{ habitat }}</p>
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
      titleGlobal: String,
      titleProtected: String,
      percentageGlobal: Number,
      percentageProtected: Number
    },

    data () {
      return {
        mapbox: {
          accessToken: process.env.MAPBOX_TOKEN,
          // baseUrl: 'https://api.mapbox.com/geocoding/v5/mapbox.places'
        },
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
      }
    }
  }
</script>
