<template>
  <div class="chart--row">
    <div class="chart__wrapper">
      <span class="chart__index">{{ index + 1 }}.</span>
      <div class="chart__chart">
        <span 
          v-if="row.previous > 0"
          class="chart__bar-previous flex flex-v-center"
          :style="{ width: row.previous + '%' }"
        />

        <span 
          v-if="row.current > 0"
          :class="[themeClass, 'chart__bar-current flex']"
          :style="{ width: row.current + '%' }"
        />
        
        <span
          v-if="row.current > 0"
          class="chart__bar-label"
        >{{ row.current }}%</span>
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
    }
  },

  computed: {
    themeClass () {
      return `theme--${this.row.id}`
    }
  }
}
</script>