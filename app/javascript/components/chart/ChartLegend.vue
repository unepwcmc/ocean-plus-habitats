<template>
  <ul class="chart__legend ul-unstyled flex flex-wrap">
    <li
      v-for="(row, index) in rows"
      :key="getVForKey('legend-row', index)"
      class="chart__legend-item flex flex-v-center"
    >
      <span :class="[themeClass(row.id), 'chart__legend-key-icon']" />

      <span class="chart__legend-key-title"><span class="chart__legend-key-index">{{ index+1 }}. </span>{{ row.title }} {{ row.percent }}</span>

      <span
        class="chart__legend-key-text"
        v-html="row.text"
      />
    </li>
  </ul>
</template>

<script>
import mixinIds from '../../mixins/mixin-ids'

export default {
  name: 'ChartLegend',

  mixins: [mixinIds],

  props: {
    rows: {
      type: Array,
      required: true
    },
    theme: {
      type: String,
      default: null
    }
  },

  methods: {
    themeClass (id) {
      return `theme--${id}`
    }
  }

}
</script>
