<template>
  <nav aria-label="site-nav">

    <div :id="mixinModalId" class="nav__item-container flex flex-v-center" :class="navType">

      <button id="close-nav-pane" class="nav__close hover--pointer" v-show="isBurgerNav" @click="closeNavPane"></button>
      
      <slot></slot>

    </div>

    <button :id="mixinTriggerId" class="nav__burger hover--pointer" v-show="isBurgerNav" @click="openNavPane"></button>

  </nav>
</template>

<script>
import NavLink from "./NavLink"
import mixinPopupCloseListeners from "../../mixins/mixin-popup-close-listeners"
import mixinFocusCapture from "../../mixins/mixin-focus-capture"
import { disableTabbing, reenableTabbing } from '../../helpers/focus-helpers';

export default {
  components: {
    NavLink
  },

  mixins: [
    mixinPopupCloseListeners({closeCallback: 'closeNavPane', toggleVariable: 'isNavPaneActive'}), 
    mixinFocusCapture({toggleVariable: 'isNavPaneActive', closeCallback: 'closeNavPane', openCallback: 'openNavPane'}),
  ],

  props: {
    pages: {
      required: true,
      type: Array
    },
    isAlwaysBurger: {
      default: false,
      type: Boolean
    }
  },

  data () {
    return {
      isNavPaneActiveData: false,
      selectedDropdownId: null,
      mixinModalId: 'nav-pane',
      mixinTriggerId: 'open-nav-pane'
    }
  },

  mounted () {
    this.areNavPaneItemsVisible ? reenableTabbing(this.navPaneItemContainer) : disableTabbing(this.navPaneItemContainer)
  },

  methods: {
    openNavPane () {
      this.isNavPaneActiveData = true
    },
    
    closeNavPane () {
      this.isNavPaneActiveData = false
    },

    clickNavLink (id) {
      this.closeNavPane()
      this.scroll(id)
    }
  },

  computed: {
    navType () {
      return { 
        'nav--pane': this.isBurgerNav,
        'nav--bar': !this.isBurgerNav,
        'nav-pane--active': this.isNavPaneActive
      }
    },

    navPaneItemContainer () {
      return this.$el.querySelector('.nav__item-container')
    },

    isNavPaneActive () {
      return this.isNavPaneActiveData
    },

    areNavPaneItemsVisible () { this.isNavPaneActive
    }
  },

  watch: {
    areNavPaneItemsVisible (visible) {
      visible ? reenableTabbing(this.navPaneItemContainer) : disableTabbing(this.navPaneItemContainer)
    }
  }
}
</script>