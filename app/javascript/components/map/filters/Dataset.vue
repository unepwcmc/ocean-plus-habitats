<template>
  <div
    class="map-filters__filter"
    :class="{ 'disabled': disabled, 'map-filters__filter--eez': isEez, 'map-filters__filter--eez--active': isEezActive }"
  >
    <label
      :for="inputId"
      class="map-filters__filter-label hover--pointer flex flex-v-center"
      :class="{ 'map-filter--active': isActive }"
    >
      <span
        v-show="!disabled"
        :class="[ 'map-filters__filter-key', standardClass, isActiveClass ]"
      />
      <span
        class="map-filters__filter-title"
        :class="{ 'map-filters_filter-title_eezmap' : isActive }"
      >
        {{ correctName }}
      </span>
      <input
        :id="inputId"
        type="checkbox"
        class="default-checkbox"
        :checked="isActive"
        @click="toggleDataset"
      >
      <span
        v-if="!isEez"
        class="custom-checkbox"
      />
    </label>
  </div>
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
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },



  data() {
    return {
      selected: false,
      datasetLayersCreated: false,
      name: this.config.name,
      title: this.config.title,
      datasetId: this.config.id
    }
  },

  computed: {
    isActive() {
      return this.selected
    },
    isEez() {
      return /(eez)/.test(this.datasetId)
    },
    isEezActive() {
      return this.isEez && this.isActive
    },
    standardClass() {
      return !this.isEez ? `map-filters__filter-key--${this.datasetId}` : this.isActiveClass
    },
    isActiveClass() {
      return this.isEezActive ? 'map-filters__filter-key--active' : ''
    },
    correctName() {
      return this.isEez ? this.title : this.name
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
    this.$eventHub.$on('deselect-' + this.$parent.id + this.datasetId, this.deselectDataset)
    this.$eventHub.$on('select-' + this.$parent.id + this.datasetId, this.selectDataset)
  },

  destroyed() {
    this.$eventHub.$off('map-reload-layers', this.reloadDataset)
    this.$eventHub.$off('deselect-' + this.$parent.id + this.datasetId, this.deselectDataset)
    this.$eventHub.$off('select-' + this.$parent.id + this.datasetId, this.selectDataset)
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
      this.$eventHub.$emit('map-update-curr-' + this.$parent.id, {
        datasetId: this.datasetId,
        showDataset,
        createDataset
      })
    }
  }
}
</script>
