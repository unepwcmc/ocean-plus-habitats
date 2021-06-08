<template>
  <div class="download-radio-buttons">
    <ul class="radio-group download-radio-buttons__radio-group">
      <li
        class="radio-group__item"
        v-for="option in options"
        :key="getVForKey('option', option.id)"
      >
        <label
          class="radio-button__label"
          :for="getVForKey('option', option.id)"
        >
          <input
            :id="getVForKey('option', option.id)"
            class="radio-button__input"
            v-model="selectedOption"
            :name="`${id}-radio-group`"
            type="radio"
            :value="option"
          />

          <span class="radio-button__radio" />

          {{ option.name }}
        </label>
      </li>
    </ul>

    <a
      class="button--radio-group-download"
      :href="selectedOption.url"
      @click.right="trackDownload('right')"
      @click.left="trackDownload('left')"
      @click.middle="trackDownload('middle')"
      download
    >
      {{ linkText }}
    </a>
  </div>
</template>

<script>
import mixinIds from '../../mixins/mixin-ids'
import { mixinResponsive } from '../../mixins/mixin-responsive'

export default {
  mixins: [mixinIds, mixinResponsive],

  props: {
    id: {
      type: String,
      required: true
    },

    options: {
      type: Array,
      default: () => []
    },

    downloadText: {
      type: String,
      default: ''
    },

    downloadTextMobile: {
      type: String,
      default: ''
    }
  },

  data () {
    return {
      selectedOption: undefined
    }
  },

  created () {
    this.initialise()
  },

  computed: {
    linkText () {
      const downloadTextMobile = this.downloadTextMobile || this.downloadText

      return this.isSmall() ? downloadTextMobile : this.downloadText
    }
  },

  methods: {
    initialise () {
      if (this.options.length > 0) {
        this.selectedOption = this.options[0]
      }
    },

    trackDownload (mouseButton='left') {
      //1 means definite download, 0 means intent to download
      const intent = mouseButton === 'left' ? 1 : 0

      if (this.$ga) {
        this.$ga.event({
          eventCategory: 'spatial',eventAction: 'download',
          eventLabel: this.selectedOption.id, eventValue: intent
        })
      }
    }
  }
}
</script>