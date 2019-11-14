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
  </div>
</template>

<script>
import Dataset from './Dataset'

export default {
  name: 'FilterPane',

  components: { Dataset },
  
  props: {
    id: {
      type: String,
      required: true
    },
    title: {
      type: String,
      default: ''
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