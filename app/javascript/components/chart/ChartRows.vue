<template>
  <div class="chart--rows">
    <div class="chart__legend-wrapper">
      <chart-legend
        :rows="rows"
      >
      </chart-legend>
    </div>
    <div class="chart__charts">
      <chart-row
        v-for="row, index in rows"
        :key="index"
        :index="index"
        :row="row"
      >
      </chart-row>
    </div>
  </div>
</template>

<script>
  import ChartLegend from './ChartLegend'
  import ChartRow from './ChartRow'

  export default {
    name: 'chart-rows',

    components: { ChartLegend, ChartRow },

    props: {
      rows: {
        type: Array, // [{ id: String, previous: Number, current: Number }]
        required: true
      }
    }
  }
</script>