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

  data () {
    return {
      isActive: false
    }
  },

  computed: {
    mixinTriggerId () {
      return 'nav-trigger-' + this.id
    },

    navId () {
      return `toggle-nav-${this.id}`
    }
  },

  created () {
    this.$eventHub.$on(this.navId, this.updateActiveState)
  },

  methods: {
    updateActiveState (isActive) {
      this.isActive = isActive
    }
  }
}
</script>