<template>
  <div
    v-show="isActive"
    class="tabs__tab"
  >
    <slot />
  </div>
</template>

<script>
export default {
  name: 'Tab',

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