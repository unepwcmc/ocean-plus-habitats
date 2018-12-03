<template>
  <div>
    <mapbox
      :habitatTitle="map.habitatTitle"
      :habitatType="map.habitatType"
      :theme="map.theme"
      :tables="map.tables"
      :titleGlobal="map.titleGlobal"
      :titleProtected="map.titleProtected"
      :percentageGlobal="map.percentageGlobal"
      :percentageProtected="map.percentageProtected"
      :wmsUrl="map.wmsUrl">
    </mapbox>

    <chart-column
      :habitatTitle="map.habitatTitle"
      :habitatType="map.habitatType"
      :description="content.top_coverage_description"
      :data="habitat.columnChart">
    </chart-column>

    <chart-row
      :description="content.top_protected_description"
      :data="habitat.rowChart">
    </chart-row>
    
    <section class="section-padding bg--navy white">
      <div class="container">
        <h3 class="white">Commitments and pledges</h3>
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
      </div>
    </section>

    <section class="section-padding-small">
      <div class="container">
        <div>
          <h4>Citations</h4>
          <p class="text--smallprint" v-html="citation"></p>
        </div>
        
        <div>
          <h4>Disclaimer</h4>
          <p v-for="p in habitat.disclaimer" class="tab__content-text text--smallprint" v-html="p"></p>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
  import ChartColumn from './components/chart/ChartColumn.vue'
  import ChartRow from './components/chart/ChartRow.vue'
  import Tab from './components/tabs/Tab.vue'
  import Tabs from './components/tabs/Tabs.vue'
  import Mapbox from './components/map/Mapbox.vue'
  import StickyBar from './components/sticky/StickyBar.vue'

  export default {
    name: 'habitat',

    components: { ChartColumn, ChartRow, Tab, Tabs, Mapbox },

    props: {
      habitat: {
        type: Object,
        required: true
      }
    },

    data () {
      return {
        content: this.habitat.content,
        map: this.habitat.map,
        citation: this.habitat.content.citations
      }
    },

    methods: {
      id (title) {
        return title.toLowerCase().replace(/\s+/g, '')
      }
    }
  }
</script>