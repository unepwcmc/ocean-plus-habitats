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
        step: 0
      }
    },

    watch: {
      number () {
        this.currentNumber = 0
        this.calcuateStep()
      }
    },

    computed: {
      styledNumber () {
        const roundingNumber = 1

        return (Math.ceil(this.currentNumber * roundingNumber)/roundingNumber).toLocaleString()
      }
    },

    created () {
      this.calcuateStep()
    },

    mounted () {
      this.scrollMagicHandlers()
    },

    methods: {
      calcuateStep () {
        this.step = Math.abs(this.number - this.currentNumber) / this.divisor
      },

      count () {
        const increase = this.currentNumber < this.number ? true : false

        let interval = window.setInterval(() => {
          if(increase && this.currentNumber + this.step < this.number){
              this.updateCurrentNumber(true)

          } else if (!increase && this.currentNumber - this.step > this.number ){
              this.updateCurrentNumber(false)

          } else {
            this.currentNumber = this.number
            clearInterval(interval)
          }
        }, this.speed)
      },

      updateCurrentNumber: function (increment) {
        this.currentNumber = increment ? this.currentNumber + this.step : this.currentNumber - this.step
      },

      scrollMagicHandlers () {
        let scrollMagicCounter = new ScrollMagic.Controller()

        new ScrollMagic.Scene({ triggerElement: `.${this.smTrigger}`, reverse: true })
          .on('start', () => {
            if(this.$el.classList.contains(this.smTarget)) { this.count() }
          })
          .addTo(scrollMagicCounter)
      }
    }
  }
</script>
