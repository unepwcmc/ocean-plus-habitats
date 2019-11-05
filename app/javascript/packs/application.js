// libraries
import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'

Vue.config.productionTip = false

Vue.use(TurbolinksAdapter)

// components
import ChartDoughnut from '../components/chart/ChartDoughnut'
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
      ChartDoughnut,
      Habitat,
      Tab,
      Tabs,
      Mapbox,
      StickyBar
    }
  })
})