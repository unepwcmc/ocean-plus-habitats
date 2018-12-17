<template>
  <section class="section-padding sm-trigger-row">
    <div class="container">
      <div class="chart--row">
        <div class="chart__content">
          <h3>Top five countries and territories with habitat area covered by a protected area</h3>

          <p v-for="p in description" v-html="p"></p>
        </div>
        
        <div class="chart__chart">
          <div v-for="item in data" class="chart__item">
            <p class="chart__label bold">{{ item.label }}</p>
            <div class="chart__bar sm-target-row">
              <span class="chart__bar-label sm-target-child-row">{{ item.percent }}%</span>
              <span class="chart__colour sm-target-child-row" :style="{ width: item.percent + '%' }"></span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
  import ScrollMagic from 'scrollmagic'

  export default {
    name: 'chart-row',

    props: {
      description: Array,
      data: Array
    },

    updated () {
      if(this.data.length > 0) { this.scrollMagicHandlers() }
    },

    methods: {
      scrollMagicHandlers () {
        let scrollMagicController = new ScrollMagic.Controller()

        new ScrollMagic.Scene({ triggerElement: '.sm-trigger-row', reverse: false })
          .setClassToggle('.sm-target-row .sm-target-child-row, .sm-target-row', 'animate')
          .addTo(scrollMagicController)
      }
    }
  }
</script>