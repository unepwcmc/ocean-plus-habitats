export const storeModal = {
  namespaced: true,

  state: {
    id: '',
    isActive: false,
    content: ''
  },

  actions: {
    openModal ({ commit }, obj) {
      commit('updateId', obj.id)
      commit('updateContent', obj.content)
      commit('updateStatus')
    },

    closeModal ({ commit }) {
      commit('updateId', '')
      commit('updateStatus')
    }
  },

  mutations: {
    updateId (state, id) {
      this.state.modal.id = id
    },

    updateStatus () {
      this.state.modal.isActive = !this.state.modal.isActive
    },

    updateContent (state, content) {
      this.state.modal.content = content
    }
  }
}
