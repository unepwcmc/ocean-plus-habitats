// libraries
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.config.productionTip = false

Vue.use(TurbolinksAdapter)

import store from '../store/store.js'

// components
import ChartRows from '../components/chart/ChartRows.vue'
import Mapbox from '../components/map/Mapbox.vue'
import Modal from '../components/modal/Modal.vue'
import ModalTrigger from '../components/modal/ModalTrigger.vue'
import StickyBar from '../components/sticky/StickyBar.vue'
import Tab from '../components/tabs/Tab.vue'
import Tabs from '../components/tabs/Tabs.vue'

// create event hub and export so that it can be imported into .vue files
export const eventHub = new Vue()

document.addEventListener('turbolinks:load', () => {
  if(document.getElementById('v-app')) {
    Vue.prototype.$eventHub = new Vue()

    const app = new Vue({
      el: '#v-app',
      store,
      components: {
        ChartRows,
        Mapbox,
        Modal,
        ModalTrigger,
        StickyBar,
        Tab,
        Tabs
      }
    })
  }
})