<template>
  <div class="map--statistics">
    <div id="map" class="map__map"></div>

    <div class="map__panel gutters">
      <h2 class="heading--map">Title</h2>

      <div class="flex flex-v-center">
        <p class="map__panel-layer-stat no-margin flex flex-v-center flex-h-end">
          <span class="map__panel-layer-button"></span>
          <span class="map__panel-layer-percentage">00</span>
        </p>
        <p class="map__panel-layer-title no-margin">00</p>

        <p class="map__panel-layer-stat no-margin flex flex-v-center flex-h-end">
          <span class="map__panel-sublayer-button"></span>
          <span class="map__panel-sublayer-percentage">00</span>
        </p>
        <p class="map__panel-layer-title no-margin">00</p>
      </div>

      <span class="map__source">Source</span>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'mapbox',

    props: {
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
