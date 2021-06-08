<template>
  <div
    class="eez-map-legend"
  >
    <span class="eez-map-legend__text">{{ text }}</span>
    <div class="eez-map-legend__keys">
      <div
        v-for="extent in layers"
        :key="extent.id"
        class="eez-map-legend__key"
      >
        <span
          :key="extent.id"
          class="eez-map-legend__color"
          :style="{ 'background-color': extent.color }"
        />
        
        <span>{{ extent.sub_name | correct }}</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {

  name: 'EezLegend',
  filters: {
    correct(value) {
      if (value != 'no-data') return value
      value = value.toString()

      return value.charAt(0).toUpperCase() + value.slice(1).replace(/-/g, ' ')
    }
  },

  props: {
    datasets: {
      type: Array,
      default: () => []
    },
    text: {
      type: String,
      default: ''
    }
  },
  data () {
    return {
      layers: this.datasets[0].sourceLayers
    }
  },
}
</script>

