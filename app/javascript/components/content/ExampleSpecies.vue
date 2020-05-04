<template>
  <div class="cards--example-species">
    <h3 class="cards__title">
      {{ content.title }}
    </h3>
    <p v-if="!examples">No species could be found for this particular habitat and category.</p>
    <div class="cards__cards">
      <div
        v-for="(example, index) in examples"
        :key="getVForKey('card-example-species', index)"
        class="card"
      >
        <img
          :src="example.image"
          :alt="example.name_common"
          class="card__image"
        >

        <div class="card__content">
          <p class="card__title">
            {{ example.name_common }}
            <br v-if="!example.name_common">
            <span class="card__title-scientific">{{ example.name_scientific }}</span>
          </p>

          <i class="card__icon icon--redlist">{{ example.redlist }}</i>

          <a
            :href="example.redlist_url"
            class="card__link"
            target="_blank"
          >
            IUCN Species page
          <i class="fas fa-external-link-square-alt"></i>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import mixinId from '../../mixins/mixin-ids'

export default {
  name: 'ExampleSpecies',

  mixins: [ mixinId ],

  props: {
    content: {
      type: Object, //{ title: String, examples: { HABITAT_NAME: [ { name_common: String, name_scientific: String, image: String, redlist: String, redlist_url: String} ]} }
      required: true,
    },
    event: {
      type: String,
      required: true
    }
  },

  data () {
    return {
      habitat: ''
    }
  },

  computed: {
    examples () {
      return this.content.examples[this.habitat]
    }
  },

  created () {
    this.$eventHub.$on(this.event, this.updateContent)
  },

  methods: {
    updateContent(habitat) {
      this.habitat = habitat['id']
    }
  }
}
</script>
