<template>
  <div
    :id="id"
    class="map"
  />
</template>

<script>
/**
 * MapExplore is the main map panel and most of the functionality comes from turf
 * This component just handles 'mapbox layers' on the map and knows nothing about our 'datasets' which may contain
 * multiple layers
 * Key events:
 *   map-create-layer: creates a single map layer with given id
 *   map-hide-layers: hide the layer with provided id (must already have been created)
 */
import LayersControl from '../helpers/layers-control'
import { getFirstForegroundLayerId } from '../helpers/map-helpers'
import mixinAddLayers from '../mixins/mixin-add-layers'

export default {
  mixins: [mixinAddLayers],
  /* eslint-disable no-undef */
  props: {
    id: {
      required: true,
      type: String
    },
    search: {
      type: Boolean,
      default: false
    },
    toggleId: {
      type: String,
      default: ''
    },
    allowNoSelectedDataset: {
      type: Boolean,
      default: true
    },
    mapboxToken: {
      type: String,
      required: true
    },
    boundingBox: {
      type: Array,
      default: null
    }
  },

  data() {
    return {
      mapbox: {
        accessToken: this.mapboxToken,
        geocodingUrl: 'https://api.mapbox.com/geocoding/v5/mapbox.places'
      },
      firstForegroundLayerId: ''
    }
  },

  watch: {
    boundingBox () {
      if (this.boundingBox) { this.zoomToBoundingBox() }
    }
  },

  mounted() {
    this.$eventHub.$on('map-create-and-show-layers-' + this.id, this.addLayers)
    this.$eventHub.$on('map-show-layers-' + this.id, this.showLayers)
    this.$eventHub.$on('map-hide-layers-' + this.id, this.hideLayers)

    mapboxgl.accessToken = this.mapbox.accessToken

    const map = new mapboxgl.Map({
      container: this.id,
      style: 'mapbox://styles/unepwcmc/cknip0poi0p9g17o1m3nzs0h7',
      pitchWithRotate: false,
      center: [0, 30],
      zoom: 1
    })

    this.map = map

    /** This event is for when mapbox style is changed on e.g. to 'streets' or 'basic'
     * so we reload all layers on the new map
     */
    map.on('style.load', () => {
      map.resize() //fixes chrome bug where canvas initally renders with default size
      this.setFirstForegroundLayerId()
      this.$eventHub.$emit('map-reload-layers', map.isStyleLoaded())
    })

    map.on('load', () => {
      const navControl = new mapboxgl.NavigationControl()
      const layersControl = new LayersControl()

      /** mapBox specific controls */
      map.addControl(layersControl, 'bottom-left')
      map.addControl(navControl, 'bottom-left')
      this.setFirstForegroundLayerId()
      this.$eventHub.$emit('map-load')

      if(this.search) { this.addSearchControl() }
      if (this.boundingBox) { this.zoomToBoundingBox() }
    })
  },

  methods: {
    zoomToBoundingBox() {
      this.map.fitBounds(this.boundingBox)
    },

    setFirstForegroundLayerId () {
      this.firstForegroundLayerId = getFirstForegroundLayerId(this.map)
    },

    addLayers(layers) {
      layers.forEach(l => { this.addLayer(l) })
    },

    addLayer(layer) {
      this.addVectorTileLayer(layer, this.firstForegroundLayerId)
    },

    showLayers(layerIds) {
      this.setLayerVisibilities(layerIds, true)
    },

    hideLayers(layerIds) {
      this.setLayerVisibilities(layerIds, false)
    },

    setLayerVisibilities(layerIds, isVisible) {
      layerIds.forEach(id => {
        this.setLayerVisibility(id, isVisible)
      })
    },

    setLayerVisibility(layerId, isVisible) {
      const visibility = isVisible ? 'visible' : 'none'

      if (this.map.getLayer(layerId)) {
        this.map.setLayoutProperty(layerId, 'visibility', visibility)
      }
    },

    addSearchControl () {
      const geocoderControl = new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        flyTo: true,
        zoom: false,
        marker: false,
        mapboxgl: mapboxgl
      })

      this.map.addControl(geocoderControl, 'top-left')
    }
  }
}
</script>
