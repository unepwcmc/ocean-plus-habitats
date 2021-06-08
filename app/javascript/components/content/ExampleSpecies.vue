<template>
  <div class="cards--example-species">
    <h4 class="cards__title">
      {{ content.title }}
    </h4>
    <p v-show="!examples">No species could be found for this particular habitat and category.</p>
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
          :class="{'card__image-svg': example.has_image == false}"
        >

        <div class="card__content">
          <p
            class="card__title"
            :class="{'card__title-noname': !example.name_common}"
          >
            {{ example.name_common }}
            <span class="card__title-scientific">{{ example.name_scientific }}</span>
          </p>

          <i class="card__icon icon--redlist">{{ example.redlist }}</i>

          <a
            :href="example.redlist_url"
            class="card__link"
            target="_blank"
          >
            IUCN Species page
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
