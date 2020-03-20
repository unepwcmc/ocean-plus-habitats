<template>
  <div
    class="nav__pane"
    :class="{ 'nav--active' : isActive }"
  >
    <div class="nav__columns">
      <div class="nav__column">
        <v-select-searchable
          class="nav__dropdown"
          :config="config"
          :options="countries"
          @update:selected-option="redirectToCountryPage"
        />
      </div>
      <div class="nav__column">
        <p class="bold">
          Regions
        </p>
        <nav class="flex">
          <a
            v-for="region in regions"
            :key="region.id"
            :href="region.url"
            :title="`View the page for ${region.name}`"
            class="nav__a"
          >{{ region.name }}</a>
        </nav>
      </div>
    </div>
  </div>
</template>

<script>
import VSelectSearchable from '../v-select/VSelectSearchable'

export default {
  name: 'NavMegaMenu',

  components: {
    VSelectSearchable
  },

  props: {
    id: {
      type: String,
      required: true
    },
    countries: {
      type: Array,
      default: () => []
    },
    regions: {
      type: Array,
      default: () => []
    },
    regionsTitle: {
      type: String,
      default: ''
    },
    config: {
      type: Object,
      default: () => {}
    }
  },

  data () {
    return {
      isActive: false,
    }
  },

  computed: {
    mixinTriggerId () {
      return 'nav-trigger-' + this.id
    },

    navId () {
      return `toggle-nav-${this.id}`
    }
  },

  created () {
    this.$eventHub.$on(this.navId, this.updateActiveState)
  },

  methods: {
    updateActiveState (isActive) {
      this.isActive = isActive
    },
    redirectToCountryPage (countryId) {
      const country = this.countries.filter( country => country.id === countryId )[0]

      window.location.href = country.url
    }
  }
}
</script>
