<template>
  <div class="nav">
    <div 
      :id="mixinModalId" 
      :class="['nav__pane', isActive]"
    >
      <button 
        v-show="isBurgerNav" 
        id="close-nav-pane" 
        class="nav__close"
        @click="closeNavPane"
      />

      <div class="nav__search-wrapper">
        <label class="nav__search-label">
          {{ searchLabel }}
        </label>

        <v-select-searchable
          class="nav__search"
          :config="searchConfig"
          :options="countries"
        />
      </div>

      <ul
        id="v-nav-pane-target"
        aria-label="nav" 
        role="menubar" 
        class="nav__ul"
      >
        <li 
          v-for="link in links" 
          :key="link.id"
          role="none" 
          class="nav__li"
        >
          <nav-link :link="link" />
        </li>
      </ul>
    </div>

    <button 
      v-show="isBurgerNav"
      :id="mixinTriggerId" 
      class="nav__burger" 
      @click="openNavPane"
    />
  </div>
</template>

<script>
import VSelectSearchable from '../select/VSelectSearchable'
import NavLink from './NavLink'
// import mixinResponsive from "../../mixins/mixin-responsive"
// import mixinPopupCloseListeners from "../../mixins/mixin-popup-close-listeners"
// import mixinFocusCapture from "../../mixins/mixin-focus-capture"
import { disableTabbing, reenableTabbing } from '../../helpers/focus-helpers'

export default {
  name: 'navBurger',

  components: {
    NavLink,
    VSelectSearchable
  },

  mixins: [
    // mixinResponsive, 
    // mixinPopupCloseListeners({closeCallback: 'closeNavPane', toggleVariable: 'isNavPaneActive'}), 
    // mixinFocusCapture({toggleVariable: 'isNavPaneActive', closeCallback: 'closeNavPane', openCallback: 'openNavPane'})
  ],

  props: {
    links: { //[ { id: String, label: String, url: String } ]
      required: true,
      type: Array
    },
    isAlwaysBurger: {
      default: false,
      type: Boolean
    },
    countries: {
      type: Array,
      required: true
    },
    searchConfig: {
      type: Object,
      required: true
    },
    searchLabel: {
      type: String,
      default: ''
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

  computed: {
    isBurgerNav () {
      return this.isAlwaysBurger || !this.isLarge()
    },

    isActive () {
      return { 
        'active': this.isNavPaneActive
      }
    },

    navPaneItemContainer () {
      return this.$el.querySelector('#v-nav-pane-target')
    },

    isNavPaneActive () {
      return this.isNavPaneActiveData && this.isBurgerNav
    },

    areNavPaneItemsVisible () {
      return !this.isBurgerNav || this.isNavPaneActive
    }
  },

  watch: {
    areNavPaneItemsVisible (visible) {
      visible ? reenableTabbing(this.navPaneItemContainer) : disableTabbing(this.navPaneItemContainer)
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
    },

    hasChildren (link) {
      return link.hasOwnProperty('children')
    }
  }
}
</script>