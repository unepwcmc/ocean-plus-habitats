<template>
  <div
    class="map-download-button relative"
    :class="{'map-download-button--active': isActive}"
  >
    <button
      aria-haspopup="true"
      :aria-expanded="isActive"
      :aria-controls="contentId"
      class="map-download-button__trigger button--map-download hover--pointer"
      @click="toggle"
    >
      {{ text }}
    </button>
    <ul
      v-show="isActive"
      :id="contentId"
      class="map-download-button__dropdown"
    >
      <li 
        v-for="(option, index) in options"
        :key="getVForKey('download-option', index)"
        class="map-download-button__li"
      >
        <a
          class="map-download-button__option"
          :href="option.link"
        >
          {{ option.label }}
        </a>
      </li>
    </ul>
  </div>
</template>


<script>
import mixinIds from '../../../mixins/mixin-ids'
import mixinPopupCloseListeners from '../../../mixins/mixin-popup-close-listeners'

export default {
  mixins: [mixinPopupCloseListeners({closeCallback: 'close'}), mixinIds],

  data () {
    return {
      isActive: false,
      contentId: `map-download-button-content-${this._uid}`,
      options: [
        {
          label: 'CSV',
          id: 'csv',
          link: ''
        },
        {
          label: 'SHP',
          id: 'shp',
          link: ''
        }
      ]
    }
  },

  computed: {
    arrowTransformStyle () {
      return {
        transform: this.isActive ? 'rotate(180deg)' : 'rotate(0deg)'
      }
    },

    translations () {
      return this.$store.state.translations.translations
    },

    text () {
      return this.translations.countries ? 
        this.translations 
          .countries
          .shared
          .locations_map
          .download_button_text :
        ''
    }
  },
  
  methods: {
    toggle () {
      this.isActive ? this.close() : this.open()
    },
    close () {
      this.isActive = false
    },
    open () {
      this.isActive = true
    }
  }
}
</script>
