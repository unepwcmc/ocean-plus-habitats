<template>
  <div class="map-filters flex flex-column">
    <p
      v-show="isEez"
      class="map-filters__eezMessage"
    >
      {{ eezMessage }}
    </p>
    <ul class="map-filters__list">
      <li
        v-for="dataset in datasets"
        :key="dataset.id"
        class="map-filters__list-li"
      >
        <dataset
          :key="dataset.id"
          :config="dataset"
          :allow-no-selected-dataset="allowNoSelectedDataset"
          :disabled="dataset.disabled"
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
      isActive: true,
      eezMessage: 'Select an Ocean Habitat'
    }
  },
  computed: {
    isEez() {
      return /(eez)/.test(this.id)
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
