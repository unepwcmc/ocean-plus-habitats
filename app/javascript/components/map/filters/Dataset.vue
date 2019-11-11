<template>
  <label
    :for="inputId"
    class="map-filters__filter hover--pointer flex flex-v-center"
    :class="{ 'map-filter--active': isActive}"
  >
    <span :class="`map-filters__filter-key--${config.id}`" />
    <span class="map-filters__filter-title">
      {{ name }}
    </span>
    <input
      :id="inputId"
      type="checkbox"
      class="default-checkbox"
      :checked="isActive"
      @click="toggleDataset"
    >
    <span class="custom-checkbox" />
  </label>
</template>

<script>

export default {
  name: 'Layer',
  
  props: {
    config: {
      required: true,
      type: Object
    },
    allowNoSelectedDataset: {
      required: true,
      type: Boolean
    }
  },

  data() {
    return {
      selected: false,
      datasetLayersCreated: false,
      name: this.config.name,
      datasetId: this.config.id
    }
  },

  computed: {
    isActive() {
      return this.selected
    },

    inputId() {
      return `dataset_${this.datasetId}_${this.name}_input`
    },
  },

  watch: {
    selected(isSelected) {
      isSelected ? this.setCurrentDataset(true) : this.setCurrentDataset(false)
    }
  },

  mounted() {
    this.$eventHub.$on('map-reload-layers', this.reloadDataset)
    this.$eventHub.$on('deselect-' + this.datasetId, this.deselectDataset)
    this.$eventHub.$on('select-' + this.datasetId, this.selectDataset)
  },

  destroyed() {
    this.$eventHub.$off('map-reload-layers', this.reloadDataset)
    this.$eventHub.$off('deselect-' + this.datasetId, this.deselectDataset) 
    this.$eventHub.$off('select-' + this.datasetId, this.selectDataset)
  },

  methods: {
    toggleDataset() {
      this.selected && this.allowNoSelectedDataset ? this.deselectDataset() : this.selectDataset()
    },

    selectDataset() {
      this.selected = true
    },

    deselectDataset() {
      this.selected = false
    },

    reloadDataset() {
      this.datasetLayersCreated = false
      if(this.selected) {this.setCurrentDataset(true, true)}
    },

    setCurrentDataset(showDataset, forceCreate=false) {
      const createDataset = showDataset && (!this.datasetLayersCreated || forceCreate)

      if (showDataset) { this.datasetLayersCreated = true }
      this.$eventHub.$emit('map-update-curr', {
        datasetId: this.datasetId, 
        showDataset, 
        createDataset
      })
    }
  }
}
</script>
