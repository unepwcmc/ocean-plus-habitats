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
            v-model="downloadLink"
            :name="`${id}-radio-group`"
            type="radio"
            :value="option.url"
          />

          <span class="radio-button__radio" />

          {{ option.name }}
        </label>
      </li>
    </ul>

    <a
      class="button--radio-group-download"
      :href="downloadLink"
      download
    >
      {{ downloadText }}
    </a>
  </div>
</template>

<script>
import mixinIds from '../../mixins/mixin-ids'

export default {
  mixins: [mixinIds],

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
    }
  },

  data () {
    return {
      downloadLink: ''
    }
  },

  created () {
    this.initialise()
  },

  methods: {
    initialise () {
      if (this.options.length > 0) {
        this.downloadLink = this.options[0].url
      }
    }
  }
}
</script>