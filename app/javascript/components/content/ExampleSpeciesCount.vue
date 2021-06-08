<template>
  <p class="example-species__total-count">
    {{ speciesCountMessage }}
  </p>
</template>

<script>
export default {
  props: {
    text: {
      type: String,
      default: ''
    },
    speciesCountByHabitat: {
      type: Object,
      required: true
    },
    event: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      habitatId: ''
    }
  },

  computed: {
    count () {
      return this.speciesCountByHabitat[this.habitatId]
    },

    speciesCountMessage () {
      return `${this.text}: ${this.count}`
    }
  },

  created () {
    this.$eventHub.$on(this.event, this.setHabitatId)
  },

  methods: {
    setHabitatId (habitat) {
      this.habitatId = habitat.id
    }
  }
}
</script>