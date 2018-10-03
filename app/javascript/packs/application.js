import Vue from 'vue'

// components
import Tab from '../components/tabs/Tab.vue'
import Tabs from '../components/tabs/Tabs.vue'

document.addEventListener('DOMContentLoaded', () => {
  const el = document.body.appendChild(document.createElement('hello'))
  
  const app = new Vue({
    el,
    components: [
      Tab,
      Tabs
    ]
  })
})
