<template>
  <div>
    <tabs>
      <tab v-for="commitment in habitat.commitments" :id="id(commitment.title)" :title="commitment.title" class="tab__content">
        <div v-for="item in commitment.list" class="tab__content-item flex">
          <template v-if="item.icon">
            <img :src="item.icon" :alt="item.title" class="tab__content-icon">

            <p class="tab__content-text" v-html="item.text"></p>
          </template>

          <template v-else>
            <p v-html="item.text"></p>
          </template>
        </div>
      </tab>
    </tabs>
    {{ habitat }}
  </div>
</template>

<script>
  import Tab from './components/tabs/Tab.vue'
  import Tabs from './components/tabs/Tabs.vue'
  import Mapbox from './components/map/Mapbox.vue'
  import StickyBar from './components/sticky/StickyBar.vue'

  export default {
    name: 'habitat',

    components: { Tab, Tabs, Mapbox },

    props: {
      habitat: {
        type: Object,
        required: true
      }
    },

    methods: {
      id (title) {
        return title.toLowerCase().replace(/\s+/g, '')
      }
    }
  }
</script>