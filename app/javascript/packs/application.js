// libraries
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.config.productionTip = false

Vue.use(TurbolinksAdapter)

import store from '../store/store.js'

// components
import ChartDoughnut from '../components/chart/ChartDoughnut'
import ChartRows from '../components/chart/ChartRows.vue'
import ChartRowStacked from '../components/chart/ChartRowStacked.vue'
import ExampleSpecies from '../components/content/ExampleSpecies.vue'
import ExampleSpeciesCount from '../components/content/ExampleSpeciesCount.vue'
import NavBurger from '../components/nav/NavBurger.vue'
import NavScrollTo from '../components/nav/NavScrollTo.vue'
import Modal from '../components/modal/Modal.vue'
import ModalTrigger from '../components/modal/ModalTrigger.vue'
import VSelect from '../components/select/VSelect.vue'
import VSelectSearchable from '../components/select/VSelectSearchable.vue'
import ScrollToTop from '../components/scroll-to-top/ScrollToTop.vue'
import StickyBar from '../components/sticky/StickyBar.vue'
import Tab from '../components/tabs/Tab.vue'
import Tabs from '../components/tabs/Tabs.vue'
import Translator from '../components/translator/Translator'
import VMapInteractive from '../components/map/VMapInteractive'
import VDial from '../components/dial/VDial'

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('v-app')) {
    Vue.prototype.$eventHub = new Vue()

    new Vue({
      el: '#v-app',
      store,
      components: {
        ChartDoughnut,
        ChartRows,
        ChartRowStacked,
        ExampleSpecies,
        ExampleSpeciesCount,
        Modal,
        ModalTrigger,
        NavBurger,
        NavScrollTo,
        VSelect,
        VSelectSearchable,
        ScrollToTop,
        StickyBar,
        Tab,
        Tabs,
        Translator,
        VMapInteractive,
        VDial
      }
    })
  }
})
