<template>
  <div class="map--statistics">
    <div id="map" class="map__map"></div>

    <div class="map__panel gutters">
      <div class="">
        <p class="heading--map">{{ globalCoverageTitle }}</p>
        <span class="map__panel-layer-percentage">{{ globalCoverage }}Km<sup>2</sup></span>

        <p class="heading--map">{{ protectedTitle }}</p>
        <span class="map__panel-layer-percentage">{{ protectedPercentage }}%</span>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'mapbox',

    props: {
      globalCoverageTitle: String,
      protectedTitle: String,
      globalCoverage: Number,
      protectedPercentage: Number
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
      }
    }
  }
</script>
