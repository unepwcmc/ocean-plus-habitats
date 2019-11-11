<template>
  <div class="map__container flex">
    <filter-pane 
      id="filters-layers"
      title="Select a layer:"
      class="flex-no-shrink"
      :allow-no-selected-dataset="allowNoSelectedDataset"
      :datasets="datasets"
    />
    <v-map
      :search="search"
      :allow-no-selected-dataset="allowNoSelectedDataset"
      :mapbox-token="mapboxToken"
      :bounding-box="initBoundingBox"
    />
  </div>
</template>

<script>
import FilterPane from './filters/FilterPane'
import VMap from './map/VMap'
import { getLayers } from './helpers/map-helpers'
import { getCountryExtentByISO3 } from './helpers/request-helpers'

export default {
  components: {
    FilterPane,
    VMap
  },

  props: {
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
    filterPaneFooterText: {
      type: String,
      default: ''
    },
    filterPaneWarningText: {
      type: String,
      default: ''
    },
    iso3: {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      datasets: [],
      currentDatasetId: '',
      mapboxToken: process.env.MAPBOX_TOKEN,
      initBoundingBox: null
    }
  },

  computed: {
    currentDataset () {
      return this.getDatasetFromId(this.currentDatasetId)
    }
  },

  created () {
    this.$eventHub.$on('reload-all-facets', this.reload)
    this.$eventHub.$on('map-update-curr', this.updateCurrentDataset)
    this.$eventHub.$on('map-load', this.selectFirstLayer)

    this.reload()

    if (this.iso3) {
      this.setInitBoundingBox()
    }
  },

  destroyed () {
    this.$eventHub.$off('reload-all-facets', this.reload)
    this.$eventHub.$off('map-update-curr', this.updateCurrentDataset)
    this.$eventHub.$off('map-load', this.selectFirstLayer)
  },

  methods: {
    setInitBoundingBox () {
      getCountryExtentByISO3(this.iso3, res => {
        const extent = res.data.extent

        this.initBoundingBox = [
          [extent.xmin - 1, extent.ymin - 1],
          [extent.xmax + 1, extent.ymax + 1]
        ]
      })
    },

    getDatasetFromId (datasetId) {
      let dataset = null

      this.datasets.forEach(ds => {
        if (ds.id === datasetId) {
          dataset = ds
        }
      })

      return dataset
    },

    reload () {
      this.datasets = [{
        id: 'coralreefs',
        name: 'Warm water coral',
        sourceLayer: 'Ch2_Fg5_mcat5',
        tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
        color: '#F35F8D',
        descriptionHtml: '<p><strong>00%</strong>Warm water coral</p><p><strong>00%</strong>Percentage of warm water coral that occur within a marine protected area</p>'
      },
      {
        id: 'saltmarshes',
        name: 'Saltmarshes',
        sourceLayer: 'Ch2_Fg5_mcat5',
        tilesUrl: 'https://tiles.arcgis.com/tiles/Mj0hjvkNtV7NRhA7/arcgis/rest/services/Ch2_Fg5_Oct19/VectorTileServer/tile/{z}/{y}/{x}.pbf',
        color: '#332288',
        descriptionHtml: '<p><strong>00%</strong>Saltmarsh</p><p><strong>00%</strong>Percentage of saltmarsh that occur within a marine protected area</p>'
      }]
    },

    selectFirstLayer () {
      if (this.datasets.length) {
        this.$eventHub.$emit('select-' + this.datasets[0].id)
      }
    },

    updateCurrentDataset ({datasetId, showDataset, createDataset}) {

      this.deselectCurrentDatasetIfNecessary(datasetId, showDataset)
      this.handleDatasetUpdate({datasetId, showDataset, createDataset})
    },

    deselectCurrentDatasetIfNecessary (datasetId, showDataset) {
      const isReplacingCurrentDataset = showDataset && 
        this.currentDatasetId && 
        datasetId !== this.currentDatasetId

      if (isReplacingCurrentDataset) { 
        this.$eventHub.$emit('deselect-' + this.currentDatasetId) 
      }
    },

    handleDatasetUpdate ({datasetId, showDataset, createDataset}) {
      const newDataset = this.getDatasetFromId(datasetId)   

      if (createDataset && showDataset) {
        this.$eventHub.$emit('map-create-and-show-layers', getLayers(newDataset, true))
        this.currentDatasetId = datasetId
      } else if (showDataset) {
        this.$eventHub.$emit('map-show-layers', this.getLayerIdsForMap(newDataset))
        this.currentDatasetId = datasetId
      } else {
        this.$eventHub.$emit('map-hide-layers', this.getLayerIdsForMap(newDataset))
        if (this.currentDatasetId === datasetId) { this.currentDatasetId = '' } 
      }
    },

    getLayerIdsForMap(dataset) {
      const layerIds = []

      // if (dataset.map_type === 'Raster') {
      layerIds.push(dataset.id)
      // } else {
      //   for (let i = 0; i < this.layerCount; i++) {
      //     layerIds.push(dataset.id + '_' + i)
      //   }
      // }

      return layerIds
    }
  }
}

</script>