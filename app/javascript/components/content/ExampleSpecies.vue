<template>
  <div class="cards--example-species">
    <h3 class="cards__title">{{ content.title }}</h3>
    
    <div class="cards__cards">
      <div 
        v-for="example in examples" 
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
            <span class="card__title-scientific">{{ example.name_scientific }}</span>
          </p>
          
          <i class="card__icon icon--redlist">{{ example.redlist }}</i>
          
          <a 
            :href="example.redlist_url" 
            class="card__link"
          >
            IUCN Species page
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    name: 'example-species',

    props: {
      content: {
        type: Object, //{ title: String, examples: [ { name_common: String, name_scientific: String, image: String, redlist: String, redlist_url: String} ] }
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

    created () {
      this.$eventHub.$on(this.event, this.updateContent)
    },

    computed: {
      examples () {
        return this.content.examples[this.habitat]
      }
    },

    methods: {
      updateContent(habitat) {
        this.habitat = habitat['id']
      }
    }
  }
</script>