<template><div id="translator" /></template>

<script>
export default {
  props: {
    translations: {
      type: Object,
      default: () => {}
    },
    locale: {
      type: Object,
      default: () => {}
    }
  },
  created () {
    this.$store.commit('translations/updateTranslations', this.translations)
    this.$store.commit('translations/updateLocale', this.locale)
  }
}
</script>
