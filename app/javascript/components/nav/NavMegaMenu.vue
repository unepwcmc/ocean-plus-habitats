<template>
  <div
    class="nav__pane"
    :class="{ 'nav--active' : isActive }"
  >
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'nav-mega-menu',

  props: {
    id: {
      type: String,
      required: true
    }
  },

  created () {
    this.$store.dispatch('nav/closeNav')
  },

  computed: {
    isActive () {
      return this.$store.state.nav.isActive && this.$store.state.nav.id === this.mixinTriggerId
    },

    mixinTriggerId () {
      return 'nav-trigger-' + this.id
    }
  }
}
</script>