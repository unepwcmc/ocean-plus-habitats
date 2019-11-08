<template>
  <ul class="chart__legend ul-unstyled flex flex-wrap">
    <li 
      v-for="row, index in rows" 
      class="chart__legend-item flex flex-v-center"
    >
      <span :class="[themeClass(row.id), 'chart__legend-key-icon']"></span>
      
      <span class="chart__legend-key-title">{{ index+1 }}. {{ row.title }}</span>

      <span 
        v-html="row.text"
        class="chart__legend-key-text"
      >
      </span>
    </li>
  </ul>
</template>

<script>
  export default {
    name: 'chart-legend',

    props: {
      rows: {
        type: Array,
        required: true
      }
    },

    methods: {
      themeClass (id) {
        return `theme--${id}`
      }
    }
  }
</script>