<template>
  <div 
    class="map-filters"
    :class="{ 'map-filters--eez': isEez }"
  >
    <div class="map-filters__content">
      <h3 class="map-filters__title">
        {{ title }}
      </h3>

      <ul class="map-filters__list">
        <li
          v-for="(dataset, index) in datasets"
          :key="getVForKey('dataset', index)"
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
  </div>
</template>

<script>
import Dataset from './Dataset'
import mixinIds from '../../../mixins/mixin-ids'

export default {
  name: 'FilterPane',

  components: { Dataset },

  mixins: [mixinIds],

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
    },
    title: {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      isActive: true
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
