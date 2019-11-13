<template>
  <div class="map__container flex">
    <filter-pane 
      id="filters-layers"
      class="flex-no-shrink"
      :allow-no-selected-dataset="allowNoSelectedDataset"
      :datasets="datasets"
      :has-download-button="hasDownloadButton"
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
    iso3: {
      type: String,
      default: ''
    },
    multipleDatasets: {
      type: Boolean,
      default: true
    },
    hasDownloadButton: {
      type: Boolean,
      default: false
    }
  },

  data () {
    return {
      datasets: [],
      currentDatasetIds: [],
      mapboxToken: process.env.MAPBOX_TOKEN,
      initBoundingBox: null
    }
  },

  computed: {
    currentDatasets () {
      return this.getDatasetsFromIds(this.currentDatasetIds)
    }
  },

  created () {
    this.$eventHub.$on('reload-all-facets', this.reload)
    this.$eventHub.$on('map-update-curr', this.updateCurrentDataset)
    this.$eventHub.$on('map-load', this.selectInitDatasets)

    this.reload()

    if (this.iso3) {
      this.setInitBoundingBox()
    }
  },

  destroyed () {
    this.$eventHub.$off('reload-all-facets', this.reload)
    this.$eventHub.$off('map-update-curr', this.updateCurrentDataset)
    this.$eventHub.$off('map-load', this.selectInitDatasets)
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

    getDatasetsFromIds (datasetIds) {
      let datasetsFromIds = []

      this.datasets.forEach(ds => {
        if (datasetIds.indexOf(ds.id) >= 0) {
          datasetsFromIds.push(ds)
        }
      })

      return datasetsFromIds
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

    selectInitDatasets () {
      if (this.datasets.length) {
        if (this.multipleDatasets) {
          this.datasets.forEach(ds => {
            this.$eventHub.$emit('select-' + ds.id)
          })
        } else {
          this.$eventHub.$emit('select-' + this.datasets[0].id)
        }
      }
    },

    updateCurrentDataset ({datasetId, showDataset, createDataset}) {
      this.deselectCurrentDatasetIfNecessary(datasetId, showDataset)
      this.handleDatasetUpdate({datasetId, showDataset, createDataset})
    },

    deselectCurrentDatasetIfNecessary (datasetId, showDataset) {
      if (this.multipleDatasets) { return }

      // Logic for single select maps where only one dataset can be shown at a time
      const isReplacingCurrentDataset = showDataset &&
        this.currentDatasetIds.length === 1 &&
        !this.isCurrentDataset(datasetId)

      if (isReplacingCurrentDataset) { 
        this.$eventHub.$emit('deselect-' + this.currentDatasetIds[0]) 
      }
    },

    handleDatasetUpdate ({datasetId, showDataset, createDataset}) {
      const newDataset = this.getDatasetsFromIds([datasetId])[0] 

      if (createDataset && showDataset) {
        this.$eventHub.$emit('map-create-and-show-layers', getLayers(newDataset, true))
        this.currentDatasetIds.push(datasetId)
      } else if (showDataset) {
        this.$eventHub.$emit('map-show-layers', this.getLayerIdsForMap(newDataset))
        this.currentDatasetIds.push(datasetId)
      } else {
        this.$eventHub.$emit('map-hide-layers', this.getLayerIdsForMap(newDataset))
        if (this.isCurrentDataset(datasetId)) { 
          this.currentDatasetIds.splice(this.currentDatasetIds.indexOf(datasetId), 1) 
        } 
      }
    },

    isCurrentDataset (id) {
      return this.currentDatasetIds.indexOf(id) >= 0
    },

    getLayerIdsForMap(dataset) {
      return [dataset.id]
    }
  }
}

</script>