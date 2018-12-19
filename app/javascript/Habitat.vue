<template>
  <div :class="[`theme--${habitat.theme}`]">
    <sticky-bar class="nav-wrapper sm-trigger-sticky">
      <div class="nav-scrollable sm-target-sticky">
        <nav-bar :nav="nav" :default="defaultHabitat" class="gutters flex flex-v-center flex-h-between"></nav-bar>
      </div>
    </sticky-bar>

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
      <div class="container smallprint">
        <div class="smallprint__citations">
          <h4>Citations</h4>
          <p class="text--smallprint" v-html="citation"></p>
        </div>
        
        <div class="smallprint__disclaimer">
          <h4>Limitations</h4>
          <p v-for="p in habitat.disclaimer" class="text--smallprint" v-html="p"></p>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
  import axios from 'axios'
  import { eventHub } from './packs/application.js'

  import ChartColumn from './components/chart/ChartColumn.vue'
  import ChartRow from './components/chart/ChartRow.vue'
  import Tab from './components/tabs/Tab.vue'
  import Tabs from './components/tabs/Tabs.vue'
  import Mapbox from './components/map/Mapbox.vue'
  import NavBar from './components/nav/NavBar.vue'
  import StickyBar from './components/sticky/StickyBar.vue'

  export default {
    name: 'habitat',

    components: { ChartColumn, ChartRow, Tab, Tabs, Mapbox, NavBar, StickyBar },

    props: {
      nav: {
        type: Array,
        required: true
      },
      source: {
        type: String,
        required: true
      }
    },

    data () {
      return {
        habitat: {},
        content: [],
        map: {},
        citation: ''
      }
    },

    created () {
      const hash = window.location.hash.substr(1)
      
      this.defaultHabitat = hash ? hash : 'coralreef'
      this.getHabitatData(this.defaultHabitat)

      eventHub.$on('changeHabitat', this.getHabitatData)
    },

    methods: {
      id (title) {
        return title.toLowerCase().replace(/\s+/g, '')
      },

      getHabitatData (habitat) {
        const csrf = document.querySelectorAll('meta[name="csrf-token"]')[0].getAttribute('content')

        axios.defaults.headers.common['X-CSRF-Token'] = csrf
        axios.defaults.headers.common['Accept'] = 'application/json'

        const data = {
          params: {
            habitat: habitat
          }
        }

        axios.get(this.source, data)
          .then((response) => {
            this.habitat = response.data
            this.content = this.habitat.content
            this.map = this.habitat.map
            this.citation = this.habitat.content.citations
          })
          .catch(function (error) {
            console.log(error)
          })
      }
    }
  }
</script>