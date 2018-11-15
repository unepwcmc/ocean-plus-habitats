<template>
  <span :class="smTarget">{{ styledNumber }}</span>
</template>

<script>
  import ScrollMagic from 'scrollmagic'

  export default {
    name: 'counter',

    props: {
      smTrigger: {
        type: String,
        required: true
      },
      smTarget: {
        type: String,
        required: true
      },
      number: {
        type: Number,
        required: true
      },
      speed: {
        type: Number,
        default: 30
      },
      divisor: {
        type: Number,
        default: 50
      }
    },

    data () {
      return {
        currentNumber: 0,
        // current: 0,
        step: 0,
        increase: true
      }
    },

    computed: {
      styledNumber: function () {
        const roundingNumber = 1

        return (Math.ceil(this.currentNumber * roundingNumber)/roundingNumber).toLocaleString()
      }
    },

    created: function() {
      this.step = Math.abs(this.number - this.currentNumber) / this.divisor
    },

    mounted: function() {
      this.scrollMagicHandlers()
    },

    methods: {
      count: function () {
        this.increase = this.currentNumber < this.number ? true : false

        var interval = window.setInterval(() => {
          if(this.increase && this.currentNumber + this.step < this.number){
              this.updateCurrentNumber(true)

          } else if (!this.increase && this.currentNumber - this.step > this.number ){
              this.updateCurrentNumber(true)

          } else {
            this.currentNumber = this.number
            clearInterval(interval)
          }
        }, this.speed)
      },

      updateCurrentNumber: function (increment) {
        this.currentNumber = increment ? this.currentNumber + this.step : this.currentNumber - this.step
      },

      scrollMagicHandlers: function () {
        let scrollMagicCounter = new ScrollMagic.Controller()

        new ScrollMagic.Scene({ triggerElement: `.${this.smTrigger}`, reverse: false })
          .on('start', () => {
            if(this.$el.classList.contains(this.smTarget)) { this.count() }
          })
          .addTo(scrollMagicCounter)
      }
    }
  }
</script>
