<template>
  <div class="chart--row">
    <div class="chart__wrapper">
      <span class="chart__index">{{ index + 1 }}.</span>
      <div class="chart__chart">
        <span 
          :class="[themeClass, 'chart__bar flex flex-v-center']"
          :style="{ width: rowWidthAbs + '%', left: rowLeft + '%' }"
        />

        <span class="chart__bar-center" />
        
        <span class="chart__bar-label">
          {{ row.change }}%
        </span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ChartRow',
    
  props: {
    index: {
      type: Number,
      required: true
    },
    row: {
      type: Object, // [{ previous: Number, current: Number }]
      required: true
    },
    maxValue: {
      type: Number,
      default: 100
    }
  },

  computed: {
    rowWidth () {
      return this.row.change / (2 * this.maxValue) * 100
    },

    rowLeft () {
      return this.rowWidth < 0 ? 50 + this.rowWidth :  50
    },

    rowWidthAbs () {
      return Math.abs(this.rowWidth)
    },

    themeClass () {
      return `theme--${this.row.id}`
    }
  }
}
</script>