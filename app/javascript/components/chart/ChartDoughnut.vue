<template>
  <div class="chart--doughnut flex flex-v-start flex-h-between">
    <div class="chart__wrapper-ie11">
      <svg class="chart__chart" width="100%" height="100%" viewBox="-340 -340 680 680" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid">
        <circle cx="0" cy="0" :r="radiusBackground" :fill="colours.grey"></circle>
        
        <g transform="rotate(-26)">

          <g v-for="dataset, index in datasets" 
            @click="clickSegment(dataset)"
            class="chart__segment"
            :class="{ 'active': getSegmentStatus(dataset.title) }"> 

            <path class="chart__segment-path" :d="getArcPath(index)" :fill="dataset.colour" stroke="#ffffff" />
            
            <g :style="getTextTranslate(index)"> 
              <text 
                class="chart__segment-text"
                fill="white"
                x="0" 
                y="0" 
                text-anchor="middle"
                font-size="25px"
                :style="getTextRotation(index)"
                >
                {{ index + 1 }}
              </text>
            </g>
          </g>
        </g>      

        <g x="0" y="0">
          <image :xlink:href="active.icon" width="120px" height="120px" transform="translate(-60, -100)"></image>
          
          <foreignObject transform="translate(-130, 30)" width="260" height="100">
            <p xmlns="http://www.w3.org/1999/xhtml" style="font-size: 25px; font-weight: 300; text-align: center;">{{ active.title }}</p>
          </foreignObject>
        </g>
      </svg>
    </div>

    <div class="chart__side">
      <div class="chart__panel" :style="{ 'background-color': active.colour}">
        <h3 class="heading--doughnut-chart">{{ active.title }}</h3>
        <p class="chart__panel-text">{{ active.description }}</p>
        <a :href="active.url" title="Link to SDG website" target="_blank" class="button--link">Find out more about this goal on the UN SDG website</a>
      </div>

      <p v-if="smallprint" class="chart__smallprint">{{ smallprint }}</p>
    </div>
  </div>  
</template>

<script>
  export default {
    name: 'chart-doughnut',

    props: {
      datasets: {
        type: Array,
        required: true
      },
      smallprint: String
    },

    data () {
      return {
        radiusBackground: 300,
        radiusOuter: 286,
        radiusInner: 160,
        radiusText: 240,
        segmentWidth: 0,
        colours: {
          grey: '#ededed',
        },
        active: {
          title: '',
          description: '',
          url: '',
          colour: '',
          icon: ''
        },
      }
    },

    created () {
      this.segmentWidth = 100/this.datasets.length
      this.clickSegment(this.datasets[0])
    },

    methods: {
      clickSegment (dataset) {
        this.active.title = dataset.title
        this.active.description = dataset.description
        this.active.url = dataset.url
        this.active.colour = dataset.colour
        this.active.icon = dataset.icon
      },

      getSegmentStatus (title) {
        return title == this.active.title
      },

      getArcPath (index) {
        const 
          start = this.segmentWidth * (index - 1) + .5,
          end = this.segmentWidth * index - .5,
          outerStartX = this.getCoord(start, 'x', this.radiusOuter),
          outerStartY = this.getCoord(start, 'y', this.radiusOuter),
          outerEndX = this.getCoord(end, 'x', this.radiusOuter),
          outerEndY = this.getCoord(end, 'y', this.radiusOuter),
          innerStartX = this.getCoord(end, 'x', this.radiusInner),
          innerStartY = this.getCoord(end, 'y', this.radiusInner),
          innerEndX = this.getCoord(start, 'x', this.radiusInner),
          innerEndY = this.getCoord(start, 'y', this.radiusInner)

        const d = `M ${outerStartX} ${outerStartY} 
          A ${this.radiusOuter} ${this.radiusOuter} 0 0 1 ${outerEndX} ${outerEndY} 
          L ${innerStartX} ${innerStartY} 
          A ${this.radiusInner} ${this.radiusInner} 0 0 0 ${innerEndX} ${innerEndY} 
          Z`

        return d
      },

      getCoord (percent, coord, radius) {
        const trig = coord == 'x' ? 'cos' : 'sin'

        return radius * Math[trig]((percent/100) * 2 * Math.PI)
      },

      getTextPosition (index, coord) {
        const percentage = this.segmentWidth * (index - .5),
          trig = coord == 'x' ? 'cos' : 'sin'

        return this.radiusText * Math[trig](percentage/100 * 2 * Math.PI) 
      },

      getTextTranslate (index) {
        const x = this.getTextPosition(index, 'x'),
          y = this.getTextPosition(index, 'y')

        const style = {
          'transform': `translate(${x}px, ${y}px)`,
        }

        return style
      },

      getTextRotation (index) {
        const percentage = this.segmentWidth * (index - .5),
           style = {
            'transform': `rotateZ(${((percentage/100) * 360) + 90}deg)`,
          }

        return style
      }
    }
  }  
</script>