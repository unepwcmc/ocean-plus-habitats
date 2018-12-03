// libraries
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import ScrollMagic from 'scrollmagic'

Vue.config.productionTip = false

Vue.use(TurbolinksAdapter)

// components
import Habitat from '../Habitat.vue'
import Tab from '../components/tabs/Tab.vue'
import Tabs from '../components/tabs/Tabs.vue'
import Mapbox from '../components/map/Mapbox.vue'
import StickyBar from '../components/sticky/StickyBar.vue'

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#v-app',
    components: {
      Habitat,
      Tab,
      Tabs,
      Mapbox,
      StickyBar
    }
  })

  // add scenes for animated html components
  let scrollMagicController = new ScrollMagic.Controller()

  new ScrollMagic.Scene({ triggerElement: '.sm-trigger-column', reverse: false })
    .setClassToggle('.sm-target-column .sm-target-child-column, .sm-target-column', 'animate')
    .addTo(scrollMagicController)

  new ScrollMagic.Scene({ triggerElement: '.sm-trigger-row', reverse: false })
    .setClassToggle('.sm-target-row .sm-target-child-row, .sm-target-row', 'animate')
    .addTo(scrollMagicController)
})