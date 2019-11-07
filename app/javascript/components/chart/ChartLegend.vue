<template>
  <ul class="chart--legend ul-unstyled flex flex-wrap">
    <li v-for="row, index in rows" class="chart__legend-item flex flex-v-center" :class="themeClass">
      <p>
        <span class="chart__key-icon"></span>
        <span class="chart__key-title">{{ index }}. {{ row.title }}</span>
      </p>
      <span v-html="row.text"></span>
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
    }
  }
</script>