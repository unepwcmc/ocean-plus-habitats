<template>
  <button
    :id="triggerId"
    class="nav__trigger"
    :class="{ 'nav--active' : isActive }"
    aria-haspopup="dialog"
    @click="openNav"
  >
    <slot></slot>
  </button>
</template>

<script>
export default {
  name: 'nav-trigger',

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
    openNav () {
      this.$store.dispatch('nav/openNav', this.triggerId)
    }
  }
}
</script>
