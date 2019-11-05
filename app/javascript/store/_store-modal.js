export const storeModal = {
  namespaced: true,

  state: {
    isActive: false,
    content: {}
  },

  actions: {
    openModal ({ commit }, content) {
      commit('updateContent', content)
      commit('updateStatus')
    },

    closeModal ({ commit }) {
      commit('updateStatus')
    }
  },

  mutations: {
    updateStatus () {
      this.state.modal.isActive = !this.state.modal.isActive
    },

    updateContent (state, content) {
      this.state.modal.content = content
    }
  }
}
