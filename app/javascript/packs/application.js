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
import StickyBar from '../components/sticky/StickyBar.vue'
import VMapInteractive from '../components/map/VMapInteractive'

document.addEventListener('turbolinks:load', () => {
  Vue.prototype.$eventHub = new Vue()

  const app = new Vue({
    el: '#v-app',
    components: {
      ChartDoughnut,
      Habitat,
      Tab,
      Tabs,
      StickyBar,
      VMapInteractive
    }
  })
})