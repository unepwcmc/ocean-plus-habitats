export const storeTranslations = {
  namespaced: true,

  state: {
    translations: {},
    locale: ''
  },

  mutations: {
    updateLocale (state, locale) {
      state.locale = locale
    },
    updateTranslations (state, translations) {
      state.translations = translations
    }
  }
}
