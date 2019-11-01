<template>
  <div
    class="nav__pane"
    :class="{ 'nav--active' : isActive }"
  >
    <slot></slot>
  </div>
</template>

<script>
import mixinPopupCloseListeners from "../../mixins/mixin-popup-close-listeners"
import mixinFocusCapture from "../../mixins/mixin-focus-capture"
import { disableTabbing, reenableTabbing } from '../../helpers/focus-helpers';

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

  mounted () {
    this.isActive ? reenableTabbing(this.navPane) : disableTabbing(this.navPane)
  },

  computed: {
    isActive () {
      return this.$store.state.nav.isActive && this.$store.state.nav.id === this.mixinTriggerId
    },

    mixinTriggerId () {
      return 'nav-trigger-' + this.id
    },

    navPane () {
      return this.$el.querySelector('.nav__pane')
    },
  }
}
</script>