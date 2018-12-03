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
      }
    },

    methods: {
      id (title) {
        return title.toLowerCase().replace(/\s+/g, '')
      }
    }
  }
</script>