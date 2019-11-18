<template>
  <div class="chart--rows">
    <div class="chart__legend-wrapper">
      <chart-legend
        :rows="rows"
      />
    </div>
    <div class="chart__charts">
      <chart-row
        v-for="(row, index) in rows"
        :key="index"
        :index="index"
        :row="row"
        :max-value="maxValue"
      />
    </div>
  </div>
</template>

<script>
import ChartLegend from './ChartLegend'
import ChartRow from './ChartRow'

import mixinIds from '../../mixins/mixin-ids'

export default {
  name: 'ChartRows',

  components: { ChartLegend, ChartRow },

  mixins: [mixinIds],

  props: {
    rows: {
      type: Array, // [{ id: String, previous: Number, current: Number }]
      required: true
    }
  },

  computed: {
    maxValue () {
      return Math.max(...this.rows.map(r => Math.abs(r.change))) * 1.5
    }
  }
}
</script>