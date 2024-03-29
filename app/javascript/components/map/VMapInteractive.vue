<template>
  <div class="map__container">
    <div :class="[isEez ? 'maptype--eez' : 'maptype--habitat' ]">
      <v-map
        :id="id"
        :search="search"
        :allow-no-selected-dataset="allowNoSelectedDataset"
        :mapbox-token="mapboxToken"
        :bounding-box="initBoundingBox"
      />

      <eez-legend
        v-if="isEez"
        :datasets="datasetsInternal"
        :text="text"
      />
    </div>

    <filter-pane
      :id="filterId"
      class="flex-no-shrink"
      :allow-no-selected-dataset="allowNoSelectedDataset"
      :datasets="datasetsInternal"
      :title="filtersTitle"
    />
  </div>
</template>

<script>
import FilterPane from './filters/FilterPane'
import VMap from './map/VMap'
import EezLegend from './legend/VMapLegendEez'
import { getSubLayers, getSubLayerIds } from './helpers/map-helpers'
import { getCountryExtentByISO3 } from './helpers/request-helpers'

export default {
  components: {
    FilterPane,
    EezLegend,
    VMap
  },
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
    iso3: {
      type: String,
      default: ''
    },
    multipleDatasets: {
      type: Boolean,
      default: true
    },
    datasets: {
      type: Array,
      default: () => {}
    },
    customBoundingBox: {
      type: Array,
      default: () => []
    },
    text: {
      type: String,
      default: ''
    },
    filtersTitle: {
      type: String,
      default: ''
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
    },
    filterId () {
      return 'filters-layers-' + this.id
    },
    isEez () {
      return this.id == 'eez-map'
    }
  },

  created () {
    this.$eventHub.$on('reload-all-facets', this.reload)
    this.$eventHub.$on('map-update-curr-' + this.filterId, this.updateCurrentDataset)
    this.$eventHub.$on('map-load', this.selectInitDatasets)

    this.reload()
    this.setInitBoundingBox()
  },

  destroyed () {
    this.$eventHub.$off('reload-all-facets', this.reload)
    this.$eventHub.$off('map-update-curr-' + this.filterId, this.updateCurrentDataset)
    this.$eventHub.$off('map-load', this.selectInitDatasets)
  },


  methods: {
    setInitBoundingBox () {
      if (this.customBoundingBox.length) {
        this.initBoundingBox = this.customBoundingBox
      } else if (this.iso3) {
        this.setInitBoundingBoxFromIso()
      }
    },

    setInitBoundingBoxFromIso () {
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
          if (this.isEez) {
            return this.$eventHub.$emit('select-' + this.filterId + this.datasetsInternal[0].id)
          }
          this.datasetsInternal.forEach(ds => {
            if (!ds.disabled) {
              this.$eventHub.$emit('select-' + this.filterId + ds.id)
            }
          })
        } else {
          const firstAvailableDataset = this.datasetsInternal.filter(d => !d.disabled)[0]

          if (firstAvailableDataset) {
            this.$eventHub.$emit('select-' + this.filterId + firstAvailableDataset.id)
          }
        }
      }
    },

    updateCurrentDataset ({datasetId, showDataset, createDataset}) {
      this.deselectCurrentDatasetIfNecessary(datasetId, showDataset)
      this.handleDatasetUpdate({datasetId, showDataset, createDataset})
    },

    deselectCurrentDatasetIfNecessary (datasetId, showDataset) {
      if (this.multipleDatasets) {
        if (!this.isEez) { return }
      }

      // Logic for single select maps where only one dataset can be shown at a time
      const isReplacingCurrentDataset = showDataset &&
        this.currentDatasetIds.length === 1 &&
        !this.isCurrentDataset(datasetId)

      if (isReplacingCurrentDataset) {
        this.$eventHub.$emit('deselect-' + this.filterId + this.currentDatasetIds[0])
      }
    },

    handleDatasetUpdate ({datasetId, showDataset, createDataset}) {
      const newDataset = this.getDatasetsFromIds([datasetId])[0]

      if (createDataset && showDataset) {
        this.$eventHub.$emit('map-create-and-show-layers-' + this.id, getSubLayers(newDataset, true))
        this.currentDatasetIds.push(datasetId)
      } else if (showDataset) {
        this.$eventHub.$emit('map-show-layers-' + this.id, getSubLayerIds(newDataset))
        this.currentDatasetIds.push(datasetId)
      } else {
        this.$eventHub.$emit('map-hide-layers-' + this.id, getSubLayerIds(newDataset))
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
