<template>
  <section class="bg--grey-light section-padding sm-trigger-column">
    <div class="container">
      <div class="chart--column">
        <div class="chart__content">
          <h3 v-if="habitatType == 'points'">Top five countries and territories with the greatest number of records of {{ habitatTitle.toLowerCase() }}</h3>

          <h3 v-else>Top five countries and territories with the greatest coverage of {{ habitatTitle.toLowerCase() }}</h3>

          <p v-for="p in description" v-html="p"></p>
        </div>

        <div class="chart__scrollable">
          <div class="chart__chart center flex flex-h-between">
            <div v-for="item in data" class="chart__item">
              <div class="chart__bar sm-target-column">
                <p class="chart__bar-label sm-target-column no-margin">
                  {{ item.value }}
                  <template v-if="habitatType != 'points'">km<sup>2</sup></template>
                </p>
                <span class="chart__colour sm-target-child-column" :style="{ height: item.percent + '%' }"></span>
              </div>
              <p class="chart__label bold">{{ item.label }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
  export default {
    name: 'chart-column',

    props: {
      habitatType: String,
      habitatTitle: String,
      description: Array,
      data: Array
    }
  }
</script>