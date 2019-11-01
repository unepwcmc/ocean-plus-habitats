// dependencies
import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex/dist/vuex.esm'

Vue.use(Vuex)

// stores
import { storeModal } from './_store-modal.js'
import { storeNav } from './_store-nav.js'

export default new Vuex.Store({
  modules: {
    modal: storeModal,
    nav: storeNav
  }
})