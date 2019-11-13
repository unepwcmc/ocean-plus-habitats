<template>
  <div
    class="nav__pane"
    :class="{ 'nav--active' : isActive }"
  >
    <slot />
  </div>
</template>

<script>
export default {
  name: 'NavMegaMenu',

  props: {
    id: {
      type: String,
      required: true
    }
  },

  computed: {
    isActive () {
      return this.$store.state.nav.isActive && this.$store.state.nav.id === this.mixinTriggerId
    },

    mixinTriggerId () {
      return 'nav-trigger-' + this.id
    }
  },

  created () {
    this.$store.dispatch('nav/closeNav')
  }
}
</script>