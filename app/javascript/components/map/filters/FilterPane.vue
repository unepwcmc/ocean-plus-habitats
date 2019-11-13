<template>
  <div class="map-filters flex flex-column">
    <ul class="map-filters__list">
      <li 
        v-for="dataset in datasets" 
        :key="dataset.id"
      >
        <dataset
          :key="dataset.id"
          :config="dataset"
          :allow-no-selected-dataset="allowNoSelectedDataset"
        />
      </li>
    </ul>

    <div class="map-filters__button-bar flex flex-h-center">
      <map-download-button />
    </div>
  </div>
</template>

<script>
import Dataset from './Dataset'
import MapDownloadButton from './MapDownloadButton'

export default {
  name: 'FilterPane',

  components: { Dataset, MapDownloadButton },
  
  props: {
    id: {
      type: String,
      required: true
    },
    allowNoSelectedDataset: {
      type: Boolean,
      required: true
    },
    datasets: {
      type: Array,
      default: () => []
    }
  },

  data () {
    return {
      isActive: true
    }
  },

  methods: {
    togglePane () {
      this.isActive ? this.closePane() : this.openPane()
    },
    
    openPane () {
      this.isActive = true
    },

    closePane () {
      this.isActive = false
    }
  }
}
</script>