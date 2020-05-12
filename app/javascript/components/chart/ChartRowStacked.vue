<template>
  <div class="chart--row-stacked">
    <ul class="chart__chart ul-unstyled flex">
      <li
        v-for="(row, i) in rowsPruned"
        :key="`chart-row-${_uid}-${i}`"
        class="chart__bar flex flex-v-center"
        :class="themeClass"
        :style="{ width: row.percent + '%' }"
      >
        <span
          v-if="row.percent > 0"
          class="chart__percent"
        >{{ row.percent }}%</span>
      </li>
    </ul>

    <chart-legend
      v-if="legend"
      :rows="legend"
      :theme="theme"
      class="chart__legend"
    />
  </div>
</template>

<script>
import ChartLegend from './ChartLegend'

export default {
  name: 'ChartRowStacked',

  components: { ChartLegend },

  props: {
    title: {
      type: String,
      default: ''
    },
    theme: {
      type: String,
      default: ''
    },
    legend: {
      type: Array,
      default: () => []
    }
  },

  computed: {
    rowsPruned() {
      return this.legend.filter(habitat => habitat.percent > 0 )
    },
    themeClass () {
      return `chart-theme--${this.theme}`
    }
  }
}
</script>
