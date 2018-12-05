<template>
  <div class="tabs__tab" v-show="isActive">
    <slot></slot>
  </div>
</template>

<script>
  export default {
    name: 'tab',

    props: {
      id: {
        type: String,
        required: true
      },
      title: {
        type: String,
        required: true
      },
      active: Boolean
    },

    data () {
      return {
        isActive: false
      }
    },

    created () {
      if (this.active) { this.isActive = true }
    }
  }
</script>