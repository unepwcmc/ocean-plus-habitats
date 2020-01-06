<template>
  <div class="map__container flex">
    <filter-pane 
      id="filters-layers"
      class="flex-no-shrink"
      :allow-no-selected-dataset="allowNoSelectedDataset"
      :datasets="datasetsInternal"
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
import { getSubLayers, getSubLayerIds } from './helpers/map-helpers'
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
    },
    datasets: {
      type: Array,
      default: () => {}
    }
  },

  data () {
    return {
      datasetsInternal: [],
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
        const padding = 5

        this.initBoundingBox = [
          [extent.xmin - padding, extent.ymin - padding],
          [extent.xmax + padding, extent.ymax + padding]
        ]
      })
    },

    getDatasetsFromIds (datasetIds) {
      let datasetsFromIds = []

      this.datasetsInternal.forEach(ds => {
        if (datasetIds.indexOf(ds.id) >= 0) {
          datasetsFromIds.push(ds)
        }
      })

      return datasetsFromIds
    },

    reload () {
      this.datasetsInternal = this.datasets
    },

    selectInitDatasets () {
      if (this.datasetsInternal.length) {
        if (this.multipleDatasets) {
          this.datasetsInternal.forEach(ds => {
            if (!ds.disabled) {
              this.$eventHub.$emit('select-' + ds.id)
            }
          })
        } else {
          const firstAvailableDataset = this.datasetsInternal.filter(d => !d.disabled)[0]
          
          if (firstAvailableDataset) {
            this.$eventHub.$emit('select-' + firstAvailableDataset.id)
          }
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
        this.$eventHub.$emit('map-create-and-show-layers', getSubLayers(newDataset, true))
        this.currentDatasetIds.push(datasetId)
      } else if (showDataset) {
        this.$eventHub.$emit('map-show-layers', getSubLayerIds(newDataset))
        this.currentDatasetIds.push(datasetId)
      } else {
        this.$eventHub.$emit('map-hide-layers', getSubLayerIds(newDataset))
        if (this.isCurrentDataset(datasetId)) { 
          this.currentDatasetIds.splice(this.currentDatasetIds.indexOf(datasetId), 1) 
        } 
      }
    },

    isCurrentDataset (id) {
      return this.currentDatasetIds.indexOf(id) >= 0
    }
  }
}

</script>