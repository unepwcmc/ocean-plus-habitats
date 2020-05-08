<template>
  <div class="map__container flex">
    <filter-pane
      :id="filterId"
      class="flex-no-shrink"
      :allow-no-selected-dataset="allowNoSelectedDataset"
      :datasets="datasetsInternal"
      :has-download-button="hasDownloadButton"
    />
    <div :class="[isEez ? 'maptype_eezmap' : 'maptype_habitatmap' ]">
      <v-map
        :id="id"
        :search="search"
        :allow-no-selected-dataset="allowNoSelectedDataset"
        :mapbox-token="mapboxToken"
        :bounding-box="initBoundingBox"
      />
      <div
        v-if="isEez"
        class="eez-map-legend"
      >
        <p><i>Extent of marine protected area coverage (%):</i></p>
        <div
          v-for="extent in datasets[0].sourceLayers"
          :key="extent.id"
          class="eez-map-legend_keys"
        >
          <span
            :key="extent.id"
            class="eez-map-legend_key"
            :style="{ 'background-color': extent.color }"
          /><p>{{ extent.sub_name | correct }}</p>
        </div>
      </div>
    </div>
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
  filters: {
    correct(value) {
      if (value != 'no-data') return value
      value = value.toString()

      return value.charAt(0).toUpperCase() + value.slice(1).replace(/-/g, ' ')
    }
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
    hasDownloadButton: {
      type: Boolean,
      default: false
    },
    datasets: {
      type: Array,
      default: () => {}
    },
    customBoundingBox: {
      type: Array,
      default: () => []
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
      return "filters-layers-" + this.id
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
          if (/(eez)/.test(this.datasetsInternal[0].id)) {
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
        if (!(/(eez)/.test(datasetId))) { return }
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
