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

  data () {
    return {
      isActive: false
    }
  },

  computed: {
    triggerId () {
      return 'nav-trigger-' + this.id
    },

    navId () {
      return `toggle-nav-${this.id}`
    }
  },

  methods: {
    toggleNav () {
      this.isActive = !this.isActive
      this.$eventHub.$emit(this.navId, this.isActive)
    }
  }
}
</script>
