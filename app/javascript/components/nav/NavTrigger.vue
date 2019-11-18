<template>
  <button
    :id="triggerId"
    class="nav__trigger"
    :class="{ 'nav--active' : isActive }"
    aria-haspopup="dialog"
    @click="toggleNav"
  >
    <slot />
  </button>
</template>

<script>
export default {
  name: 'NavTrigger',

  props: {
    id: {
      type: String,
      required: true
    }
  },

  computed: {
    triggerId () {
      return 'nav-trigger-' + this.id
    },

    isActive () {
      return this.$store.state.nav.isActive && this.$store.state.nav.id === this.triggerId
    },
  },

  methods: {
    toggleNav () {
      this.$store.dispatch('nav/toggleNav', this.triggerId)
    }
  }
}
</script>
